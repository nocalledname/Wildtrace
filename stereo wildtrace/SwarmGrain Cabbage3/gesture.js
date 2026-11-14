/* MediaPipe 手部追踪:只取食指指尖,把画面中央 60% 的 ROI 压成两个 0~1 控制量。
 *
 *   工作区 ROI = 画面 x / y 各 20% ~ 80%(中央 60%,四边各留 20%)
 *   外圈 20% 是手掌活动冗余:指尖拖出 ROI 时钳制在边缘,跟踪不中断。
 *   输出:latest.x → cutoff(手往右 = 1),latest.y → q(手往上 = 1)
 *
 *   手性锁定:camera-left 只认**左手**,camera-right 只认**右手**。
 *   另一只手进画面不产生任何控制量(参数保持上一次值)。
 *
 * ── 设计要点 1:推理与发送解耦 ────────────────────────────────────────────
 *   本模块只以自身节奏(≤CFG.INFER_FPS)更新 latest,
 *   由 index.html 的 rAF 循环(60fps)读取 latest 并平滑后发送 ——
 *   latest 本身是原始拾取值(跟手优先),抖动抑制全在发送端。
 *   这样 GPU 慢或推理抖动都不会影响控制的手感。
 *
 * ── 设计要点 2:隐藏即释放(实测驱动) ──────────────────────────────────────
 *   实测(2026-10, Ableton Live + WKWebView, htmltry.au):
 *     切走插件界面后, rAF 完全停摆(48/48 采样全停滞), 推理归零;
 *     但 MediaStreamTrack 仍在跑 —— 47.1 秒里送了 1383 帧(29.4fps)。
 *     结果:Live 里摄像头指示灯常亮、白白耗电,而手势已失效。
 *
 *   原因是"采集"和"计算"用两套调度:
 *     rAF 停 → tick() 不跑 → 不推理 → 手势失效
 *     MediaStreamTrack 不依赖 rAF → 继续以 30fps 采集
 *
 *   所以本模块维护一个状态机,在隐藏时主动 release()(灭灯 + 释放 GPU),
 *   重新可见时自动 acquire() 恢复。用户没选过 camera-off,就不该被关闭。
 *
 * ── 状态机 ────────────────────────────────────────────────────────────────
 *                    start()                 hidden
 *     off ──────────────────► starting ──► running ────► suspended
 *      ▲                        │              ▲             │
 *      │ stop()                 │ 失败         │ visible     │
 *      └────────────────────────┴──────────────┴─────────────┘
 *                                    stop()
 */

const WASM_DIR = './mediapipe/wasm';
const MODEL = './mediapipe/hand_landmarker.task';
const BUNDLE = './mediapipe/vision_bundle.js';

/* ── 可调参数 ─────────────────────────────────────────────────────────────
 * 性能优先:控制量靠 60fps 插值补顺,15fps 推理完全够用。
 * 若手感发涩,把 INFER_FPS 提到 20~24,代价是 GPU 占用等比上升。
 * ──────────────────────────────────────────────────────────────────────── */
const CFG = {
    INFER_FPS: 15,                 // 推理帧率上限
    NUM_HANDS: 2,                  // 必须同时看两只手,才能保证只跟目标手(camera-left/right)
    CAPTURE: { width: 640, height: 480, frameRate: { ideal: 30 } },
    /* 手性对调。本机实测(2026-11):MediaPipe 报告的 Left/Right 与真实手一致,
     * 不需要对调。若换机器后 left 模式控住右手(或反之),把这一项改成 true。 */
    HANDEDNESS_SWAP: false,
    /* 拾取端一帧低通。单极点 y += (x - y) * a 的平均延迟是 (1 - a) / a 帧:
     *   a = 0.5  → 约 1 帧(15fps 下 67ms),只抹掉单帧尖刺,不牺牲跟手
     *   a = 1.0  → 关闭平滑(直通)
     *   a = 0.25 → 约 3 帧,更稳但偏钝
     * 更重的滤波在发送端(index.html 的 60fps 循环),那里帧率更高。 */
    SMOOTH: 0.5,
    WATCHDOG_MS: 2000,             // rAF 停滞多久判定为隐藏
    WATCHDOG_POLL_MS: 700,
};

/* 每个模式锁定一只真实的手:left 模式只认左手,right 只认右手 */
const WANT_HAND = { 'camera-left': 'Left', 'camera-right': 'Right' };

const MIN_INTERVAL = 1000 / CFG.INFER_FPS;

/* 手势工作区:画面中央 60%,四边各留 20% 冗余 */
const ROI_LO = 0.20;
const ROI_HI = 0.80;
const ROI_SPAN = ROI_HI - ROI_LO;

/* ── 方向定标(实测,可直接改) ──────────────────────────────────────────
 * 目标手感:手往右 → x 变大(cutoff 升高);手往上 → y 变大(q 升高)。
 *
 * 本机实测:MediaPipe 的原始 y 向下递增(y 小 = 手在上方),
 * 所以 Y 要取反才能"抬手 = 变大";X 同样取反。
 * 换机器/换摄像头后哪一轴反了,就翻哪一项。
 * 若调用方传入了小画布,还可以当场试:Shift+点击翻 Y,Alt/Option+点击翻 X。
 * (本仓十二台都不传 canvas —— 没有预览画布,所以这条只在 htmltry 里可用。)
 * ──────────────────────────────────────────────────────────────────── */
const ORIENT = {
    'camera-left': { invertX: true, invertY: true },
    'camera-right': { invertX: true, invertY: true },
};

export const latest = {
    present: false,
    x: 0.5,         // ROI 内横向位置,手往右 = 1
    y: 0.5,         // ROI 内纵向位置,手往上 = 1
    hand: -1,       // 当前被跟踪的手在 landmarks 里的下标
    fps: 0,
    seq: 0,         // 推理序号:每出一帧 +1,UI 用它判断"来了新样本"
};

/* 状态对外只读,便于 UI 显示"恢复中…"之类 */
export const status = { state: 'off', desired: false, resumeCount: 0 };

const listeners = new Set();
export function onStatus(cb) {
    listeners.add(cb);
    return () => listeners.delete(cb);
}
function emit() {
    status.state = state;          // 同步内部状态,否则对外永远看到 'off'
    const s = { ...status };
    for (const cb of listeners) {
        try { cb(s); } catch (e) { /* 监听者出错不影响主流程 */ }
    }
}

let state = 'off';        // off | starting | running | suspended
let desired = false;      // 用户意图:选过 camera-left/right 且还没选回 off
let gen = 0;              // 代际令牌:每次 acquire/release 自增,让在途异步作废

let landmarker = null;
let video = null;
let stream = null;
let vraf = 0;
let lastInfer = 0;
let fpsT0 = 0, fpsN = 0;
let draw = null;
let canvasRef = null;
let lastLm = null;
let cameraMode = 'camera-left';
let orient = { ...ORIENT['camera-left'] };
let handedLogged = false;   // 手性日志只打一次,避免 15fps 刷屏
/* 拾取端平滑状态,跨帧保留。手短暂丢失再回来时不对齐,
 * 否则会从旧位置慢慢滑过去;所以用 wasPresent 判断"重新捕获"并直接对齐。 */
const pickSmooth = { x: 0.5, y: 0.5 };
let wasPresent = false;

/* 哨兵 rAF:只更新时间戳,不做事。用来判断页面是否还"活着"。
 * 比 visibilitychange 更底层 —— 即使宿主不派发事件也能靠它兜底。 */
let sentinelGen = 0;
let lastSentinel = 0;
let watchdogTimer = 0;
let guardsInstalled = false;

const clamp01 = v => (v < 0 ? 0 : v > 1 ? 1 : v);

/**
 * 画面坐标 → ROI 归一化控制量(超出 ROI 钳制在边缘)。
 * @param {number} tipX 食指指尖画面 x(0~1)
 * @param {number} tipY 食指指尖画面 y(0~1)
 * @param {{invertX?: boolean, invertY?: boolean}} [o] 方向定标,见 ORIENT
 */
export function mapTip(tipX, tipY, o = ORIENT['camera-left']) {
    const rx = clamp01((tipX - ROI_LO) / ROI_SPAN);
    const ry = clamp01((tipY - ROI_LO) / ROI_SPAN);

    return {
        x: o.invertX ? 1 - rx : rx,
        y: o.invertY ? 1 - ry : ry,
    };
}

/**
 * 拾取端单极点低通:y += (x - y) * a。
 * 平均延迟 = (1 - a) / a 帧;默认 0.5 → 约 1 帧。
 * @param {number} raw 本帧原始值(0~1)
 * @param {'x'|'y'} key 轴
 * @param {number} [a] 系数,1 = 直通
 * @param {{x:number,y:number}} [st] 状态,跨帧保留
 */
export function smoothPick(raw, key, a = CFG.SMOOTH, st = pickSmooth) {
    if (a >= 1) { st[key] = raw; return raw; }
    st[key] += (raw - st[key]) * a;
    return st[key];
}

/* Cabbage 的 UI 跑在自定义 scheme(choc://app)下,非 HTTP 响应没有状态码,
 * Response.ok 恒为 false。Emscripten 的 wasm 加载器会判 !ok 直接放弃,所以:
 *   - wasm 二进制改用 XHR 取字节,再包成 blob: URL 交给它(blob 是标准 200)
 *   - 模型改用 modelAssetBuffer 直接给字节,同样不过网络层
 */
const xhrBytes = url => new Promise((ok, no) => {
    const x = new XMLHttpRequest();
    x.open('GET', url, true);
    x.responseType = 'arraybuffer';
    x.onload = () => (x.response && x.response.byteLength
        ? ok(new Uint8Array(x.response))
        : no(new Error('空文件: ' + url)));
    x.onerror = () => no(new Error('读取失败: ' + url));
    x.send();
});

/* ══════════════════════════════════════════════════════════════════════════
 * 资源获取 / 释放
 * ════════════════════════════════════════════════════════════════════════ */

/* camera-left 用系统首选设备;camera-right 优先第 2 个视频设备
 * (stereo 左右机位),只有一个或拿不到 deviceId 时回退默认,不会失败。 */
async function openCamera(mode) {
    const base = Object.assign({}, CFG.CAPTURE);

    if (mode === 'camera-right') {
        try {
            const devs = (await navigator.mediaDevices.enumerateDevices())
                .filter(d => d.kind === 'videoinput' && d.deviceId);
            if (devs.length > 1) {
                return await navigator.mediaDevices.getUserMedia({
                    video: Object.assign({}, base, { deviceId: { exact: devs[1].deviceId } }),
                    audio: false,
                });
            }
        } catch (e) {
            console.warn('Cabbage: 第 2 个摄像头不可用,回退默认 —', e);
        }
    }

    return navigator.mediaDevices.getUserMedia({ video: base, audio: false });
}

async function acquire(reason) {
    if (state === 'starting' || state === 'running') return;
    if (!desired) return;

    state = 'starting';
    const myGen = ++gen;
    emit();

    try {
        const { FilesetResolver, HandLandmarker } = await import(BUNDLE);
        if (myGen !== gen) return;                      // 被 release 打断

        const fileset = await FilesetResolver.forVisionTasks(WASM_DIR);
        if (myGen !== gen) return;

        let wasmBlob = null;
        let modelBuffer = null;
        try {
            const wasm = await xhrBytes(WASM_DIR + '/vision_wasm_internal.wasm');
            wasmBlob = URL.createObjectURL(new Blob([wasm], { type: 'application/wasm' }));
            fileset.wasmBinaryPath = wasmBlob;
        } catch (e) {
            console.warn('Cabbage: 无法预读 wasm,回退默认路径 —', e);
        }
        try {
            modelBuffer = await xhrBytes(MODEL);
        } catch (e) {
            console.warn('Cabbage: 无法预读模型,回退默认路径 —', e);
        }
        if (myGen !== gen) {
            if (wasmBlob) URL.revokeObjectURL(wasmBlob);
            return;
        }

        const opts = delegate => ({
            baseOptions: modelBuffer
                ? { modelAssetBuffer: modelBuffer, delegate }
                : { modelAssetPath: MODEL, delegate },
            runningMode: 'VIDEO',
            numHands: CFG.NUM_HANDS,
            minHandDetectionConfidence: 0.5,
            minHandPresenceConfidence: 0.5,
            minTrackingConfidence: 0.5,
        });

        let lm;
        try {
            try {
                lm = await HandLandmarker.createFromOptions(fileset, opts('GPU'));
            } catch (e) {
                console.warn('Cabbage: GPU delegate 失败,退回 CPU —', e);
                lm = await HandLandmarker.createFromOptions(fileset, opts('CPU'));
            }
        } finally {
            if (wasmBlob) URL.revokeObjectURL(wasmBlob);
        }

        if (myGen !== gen) {
            try { lm.close(); } catch (e) { }
            return;
        }
        landmarker = lm;

        // 首次会弹系统授权框,给足时间让用户点「允许」
        const gum = openCamera(cameraMode);
        const s = await Promise.race([gum, new Promise((_, no) =>
            setTimeout(() => no(new Error('摄像头授权超时')), 25000))]);

        if (myGen !== gen) {
            s.getTracks().forEach(t => t.stop());
            try { landmarker.close(); } catch (e) { }
            landmarker = null;
            return;
        }
        stream = s;

        const v = ensureVideo();
        v.srcObject = stream;

        /* play() 在"复用 video 元素 + 重新挂 srcObject"时可能永不 settle
         * (实测:首次 start 正常,恢复时挂起 → 状态卡在 starting)。
         * 必须加超时竞速,否则状态机会永久卡住。
         * 即使 play 没成功也不影响状态推进 —— tick() 里已有 readyState 守卫。 */
        try {
            await Promise.race([
                v.play(),
                new Promise(resolve => setTimeout(resolve, 1500)),
            ]);
        } catch (e) {
            /* 有些宿主需要用户手势后才允许播放,忽略即可 */
        }

        if (myGen !== gen) return;

        state = 'running';
        lastInfer = 0;
        fpsT0 = performance.now();
        fpsN = 0;
        emit();

        startTick(myGen);
    } catch (e) {
        if (myGen === gen) {
            // 回到一个明确的状态:用户还想要,就标记为 suspended 等待重试
            hardRelease();
            state = desired ? 'suspended' : 'off';
            emit();
        }
        throw e;
    }
}

/* 真正的资源释放。调用后摄像头指示灯应熄灭。
 * 刻意保持同步:release 必须立即发生,不能等微任务,
 * 否则快速切换可见性时会出现"已判定挂起但灯还亮"的窗口。 */
function hardRelease() {
    gen++;                       // 让在途的 detectForVideo / acquire 作废

    if (vraf) cancelAnimationFrame(vraf);
    vraf = 0;

    if (stream) {
        stream.getTracks().forEach(t => { try { t.stop(); } catch (e) { } });
        stream = null;
    }

    if (video) {
        try { video.pause(); } catch (e) { }
        video.srcObject = null;
    }

    if (landmarker) {
        try { landmarker.close(); } catch (e) { }
        landmarker = null;
    }

    latest.present = false;
    latest.fps = 0;
    latest.hand = -1;

    // 释放后重新开始:下次识别到的手直接对齐,不从旧位置滑过去
    wasPresent = false;
    pickSmooth.x = latest.x;
    pickSmooth.y = latest.y;

    if (draw) {
        try { draw.clearRect(0, 0, draw.canvas.width, draw.canvas.height); } catch (e) { }
    }
}

/* 同步:先置位状态再释放,避免重入 */
function suspend(reason) {
    if (state !== 'running' && state !== 'starting') return;
    state = 'suspended';
    hardRelease();
    emit();
    console.log('[gesture] 挂起(' + reason + '):摄像头与推理已释放');
}

async function resume(reason) {
    if (state !== 'suspended' || !desired) return;
    status.resumeCount++;
    console.log('[gesture] 恢复(' + reason + ')');
    try {
        await acquire(reason);
    } catch (e) {
        console.warn('[gesture] 恢复失败 —', e);
        state = 'suspended';
        emit();
    }
}

/* ══════════════════════════════════════════════════════════════════════════
 * 推理循环
 * ════════════════════════════════════════════════════════════════════════ */

function startTick(myGen) {
    if (vraf) cancelAnimationFrame(vraf);

    function tick() {
        // 代际不匹配说明已被挂起/重启,立刻退出,不再排下一帧
        if (myGen !== gen || state !== 'running') return;
        vraf = requestAnimationFrame(tick);

        const now = performance.now();
        if (now - lastInfer < MIN_INTERVAL) return;
        if (!video || video.readyState < 2) return;
        if (!landmarker) return;

        lastInfer = now;
        let out;
        try {
            out = landmarker.detectForVideo(video, now);
        } catch (e) {
            return;
        }

        fpsN++;
        if (now - fpsT0 > 1000) {
            latest.fps = Math.round((fpsN * 1000) / (now - fpsT0));
            fpsT0 = now;
            fpsN = 0;
        }

        latest.seq++;                 // 新样本到达(UI 的发送端滤波据此更新)
        const lm = pickWantedHand(out);
        lastLm = lm;

        if (lm) {
            const p = mapTip(lm[8].x, lm[8].y, orient);   // 食指指尖 lm[8]

            // 重新捕获时直接对齐,否则会从上一次的位置慢慢滑过去
            if (!wasPresent) {
                pickSmooth.x = p.x;
                pickSmooth.y = p.y;
            }

            latest.present = true;
            latest.x = smoothPick(p.x, 'x');
            latest.y = smoothPick(p.y, 'y');
            wasPresent = true;
        } else {
            latest.present = false;
            latest.hand = -1;
            wasPresent = false;
        }

        paint(lm);
    }

    tick();
}

function ensureVideo() {
    if (!video) {
        video = document.createElement('video');
        video.playsInline = true;
        video.muted = true;
        video.autoplay = true;
    }
    return video;
}

/* 手性判定 → 只返回模式锁定的那只手的关键点,另一只当没看见。
 *
 * handednesses 是 Category[][]:每个手一组分类,取第 0 组的 categoryName。
 * 报告值与真实手性是否相反因机器而异,由 CFG.HANDEDNESS_SWAP 现场校准。 */
export function resolveHanded(raw, swap = CFG.HANDEDNESS_SWAP) {
    if (raw !== 'Left' && raw !== 'Right') return raw;
    return swap ? (raw === 'Left' ? 'Right' : 'Left') : raw;
}

/* 在检测到的多只手里选出本模式锁定的那只,返回下标;没有就 -1。
 * 纯函数,方便单测。 */
export function pickHand(hands, cats, mode, swap = CFG.HANDEDNESS_SWAP) {
    const want = WANT_HAND[mode] || 'Left';
    const list = hands || [];
    const groups = cats || [];

    for (let i = 0; i < list.length; i++) {
        const raw = groups[i] && groups[i][0] && groups[i][0].categoryName;
        if (resolveHanded(raw, swap) === want) return i;
    }
    return -1;
}

/* 推理结果 → 本模式该跟的那只手的关键点;另一只手当没看见。 */
function pickWantedHand(out) {
    const hands = out.landmarks || [];
    const cats = out.handednesses || out.handedness || [];
    const want = WANT_HAND[cameraMode] || 'Left';

    const i = pickHand(hands, cats, cameraMode);

    if (i >= 0) {
        if (!handedLogged) {
            handedLogged = true;
            const raw = cats[i] && cats[i][0] && cats[i][0].categoryName;
            console.log('[gesture] 手性: 报告 ' + raw + ' → 判定 '
                + resolveHanded(raw) + ';本模式只用 ' + want + ' 手');
        }
        latest.hand = i;
        return hands[i];
    }

    /* 结果里完全没有 handedness 时不能把功能锁死:退回第一只手,只警告一次 */
    if (hands.length && !cats.length) {
        if (!handedLogged) {
            handedLogged = true;
            console.warn('[gesture] 结果里没有 handednesses,无法按手性过滤,暂用第一只手');
        }
        latest.hand = 0;
        return hands[0];
    }

    return null;
}

/* 只画 ROI 与指尖,不显示摄像头画面 —— 预览区是控制坐标,不是监控画面 */
function paint(lm) {
    if (!draw) return;

    const w = draw.canvas.width, h = draw.canvas.height;
    draw.clearRect(0, 0, w, h);

    // ROI 边框 + 三分参考线
    draw.strokeStyle = 'rgba(255,255,255,.17)';
    draw.lineWidth = 1;
    draw.strokeRect(0.5, 0.5, w - 1, h - 1);

    draw.beginPath();
    for (const f of [1 / 3, 2 / 3]) {
        draw.moveTo(w * f, 0);
        draw.lineTo(w * f, h);
        draw.moveTo(0, h * f);
        draw.lineTo(w, h * f);
    }
    draw.stroke();

    if (!lm) return;

    /* latest.y 的约定是「手往上 = 1」,而 canvas 的 y 轴朝下,
       所以要翻转后再画 —— 否则手往上抬,点反而往下走。 */
    const px = latest.x * w, py = (1 - latest.y) * h;

    // 指尖十字线
    draw.strokeStyle = 'rgba(255,255,255,.30)';
    draw.beginPath();
    draw.moveTo(px, 0);
    draw.lineTo(px, h);
    draw.moveTo(0, py);
    draw.lineTo(w, py);
    draw.stroke();

    // 指尖
    draw.fillStyle = '#fff';
    draw.shadowColor = 'rgba(255,255,255,.9)';
    draw.shadowBlur = 9;
    draw.beginPath();
    draw.arc(px, py, 2.6, 0, Math.PI * 2);
    draw.fill();
    draw.shadowBlur = 0;
}

/* 便携定标:Shift+点击画布翻转 Y,Alt/Option+点击翻转 X。
 * 换摄像头后某一轴手感反了,不用改代码就能当场纠正(仅本次会话有效)。 */
function installCalibration() {
    if (!canvasRef || canvasRef.__calInstalled) return;
    canvasRef.__calInstalled = true;

    canvasRef.addEventListener('click', e => {
        if (!e.shiftKey && !e.altKey) return;
        if (e.shiftKey) orient.invertY = !orient.invertY;
        if (e.altKey) orient.invertX = !orient.invertX;

        console.log('[gesture] 方向定标:', { ...orient });

        if (lastLm) {
            const p = mapTip(lastLm[8].x, lastLm[8].y, orient);
            latest.x = p.x;
            latest.y = p.y;
        }
        paint(lastLm);
    });
}

/* ══════════════════════════════════════════════════════════════════════════
 * 可见性守卫
 * ════════════════════════════════════════════════════════════════════════ */

/* 自愈式哨兵。
 *
 * 为什么不用 "sentinelId 是否非零" 判断存活:实测发现只要 rAF 被宿主
 * 打断一次(回调不再排队),旧循环就永久死亡,而 sentinelId 会残留一个
 * 非零值 —— 之后再也无法重建,导致"恢复后检测不到已可见",自动恢复失效。
 *
 * 改用代际令牌:每次 armSentinel() 都会作废前任并重新排队,
 * 因此可以在看门狗里放心地反复调用(隐藏期间只是空排一帧,无害)。 */
function armSentinel() {
    const my = ++sentinelGen;
    const loop = () => {
        if (my !== sentinelGen) return;      // 已被更新的哨兵取代
        lastSentinel = performance.now();
        requestAnimationFrame(loop);
    };
    requestAnimationFrame(loop);
}

function disarmSentinel() {
    sentinelGen++;                            // 让当前循环自行退出
}

function initGuards() {
    /* 事件监听只装一次:stop() 会清定时器,但不该重复叠监听器 */
    if (!guardsInstalled) {
        guardsInstalled = true;

        /* 主防线:visibilitychange 在 Live 里实测可靠触发,响应即时。
           visible 时直接恢复,不再用 rAF 抖动做前置判断 ——
           该事件比 rAF 更权威;若 rAF 实际仍停着,看门狗会在 2s 后再次挂起,
           且之后不会再自动恢复(恢复要求 rAF 活着),不会形成反复启停。 */
        document.addEventListener('visibilitychange', () => {
            if (document.hidden) {
                if (state === 'running' || state === 'starting') suspend('visibilitychange');
            } else if (state === 'suspended' && desired) {
                resume('visibilitychange');
            }
        });

        window.addEventListener('pagehide', () => {
            if (state === 'running' || state === 'starting') suspend('pagehide');
        });
    }

    armSentinel();

    /* 兜底:某些宿主不派发 visibilitychange,但 rAF 一定会停。
       注意:隐藏时定时器会被节流到 ~1-2s,所以这条路径有延迟,属预期。 */
    if (!watchdogTimer) {
        watchdogTimer = setInterval(() => {
            const stall = performance.now() - lastSentinel;

            /* 若哨兵循环因宿主原因被彻底打断(rAF 回调不再排队),
               这里负责重建。真隐藏时只是空排一帧,无害;
               但如果不重建,恢复后将永远检测不到"已可见",自动恢复会失效。 */
            if (stall > CFG.WATCHDOG_MS) armSentinel();

            /* 判据只看 rAF 是否停滞,不能再看 document.hidden:
               实测存在"document.hidden=true 但没派发 visibilitychange"的情况,
               若把 !document.hidden 作为前置条件就会漏掉挂起,摄像头永远不关。

               只对 running 生效:starting 期间 rAF 本来就不会喂哨兵,
               在这里挂起只会打断正在进行的 acquire(由 visibilitychange 立即处理即可)。 */
            if (stall > CFG.WATCHDOG_MS) {
                if (state === 'running') suspend('watchdog');
            } else if (state === 'suspended' && desired && stall < 500) {
                resume('watchdog');
            }
        }, CFG.WATCHDOG_POLL_MS);
    }
}

/* ══════════════════════════════════════════════════════════════════════════
 * 对外 API(与旧版兼容:start / stop / latest)
 * ════════════════════════════════════════════════════════════════════════ */

/**
 * 开启手势追踪。重复调用无副作用。
 * @param {HTMLCanvasElement} [canvas] 只显示 ROI 与指尖的小画布
 * @param {{camera?: 'camera-left'|'camera-right'}} [opts]
 *        camera-left  = 首选设备 + **只认左手**
 *        camera-right = 优先第 2 个视频设备(只有一个时回退) + **只认右手**
 */
export async function start(canvas, opts = {}) {
    if (canvas && canvas !== canvasRef) {
        canvasRef = canvas;
        draw = canvas.getContext('2d');
    }

    cameraMode = opts.camera === 'camera-right' ? 'camera-right' : 'camera-left';
    wasPresent = false;
    orient = { ...ORIENT[cameraMode] };
    handedLogged = false;

    initGuards();
    installCalibration();

    desired = true;
    status.desired = true;

    // 若正处于挂起(用户没关,只是不可见),先恢复
    if (state === 'suspended') {
        await resume('start');
        return latest;
    }
    if (state === 'running') {
        emit();
        return latest;
    }

    status.resumeCount = 0;
    await acquire('start');
    return latest;
}

/**
 * 关闭手势追踪 —— 只有用户显式选 camera-off 才调用。
 * 关闭后摄像头熄灭,且不再自动恢复。
 */
export function stop() {
    desired = false;
    status.desired = false;
    state = 'off';
    hardRelease();                 // 同步:摄像头立刻熄灭

    if (watchdogTimer) {
        clearInterval(watchdogTimer);
        watchdogTimer = 0;
    }
    disarmSentinel();

    emit();
}

/** 运行时调整识别手数(需先 stop 再 start 才生效) */
export function setNumHands(n) {
    CFG.NUM_HANDS = Math.max(1, Math.min(2, n | 0));
}
