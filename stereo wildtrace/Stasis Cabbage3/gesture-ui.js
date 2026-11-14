/* 手势 → 两个 0~1 控制通道的桥接层。
 *
 * `gesture.js` 负责拾取 + 一帧单极点低通(`CFG.SMOOTH = 0.5`)。本模块负责:
 *   · 在前端顶栏插一个 camera 下拉口(camera-off / camera-left / camera-right)
 *   · 生命周期:选左侧/右侧才动态 import gesture.js,选 camera-off 立即 stop(),
 *     隐藏/恢复由 gesture.js 自己托管
 *   · 发送端两级平滑(样本级 + 帧级),见 摄像头手势模块.md §0.3
 *   · 0.15% 死区,避免 60Hz × 2 条 JSON 白占 IPC
 *
 * 不画任何预览:坐标只有一个出口 —— 插件自己的中央 pad / 雷达。
 * 因此传给 gesture.js 的 canvas 是空,ROI 与指尖不绘制。
 *
 * 每个插件只需要接 5 个回调:
 *   read()      读当前 UI 里的 x / y(0~1),用于起步不跳变
 *   write(x,y)  把手势值写回插件自己的状态与画面
 *   send(id,v)  发给 Cabbage(sendControlData)
 *   blocked()   用户正在手动拖拽时返回 true,手势让位
 *   channels    通道名,默认 { x: 'x', y: 'y' }
 */

const GST = {
    A_SLOW: 0.16,   // 抖动通道:慢,压抖
    A_STEADY: 0.55, // 连续同向(真移动):快,跟手
    A_FAST: 0.80,   // 大幅偏差:更快
    NOISE: 0.022,   // 死区:偏差在此以内不额外加速
    SPAN: 0.030,    // 超出死区后再走 3% ROI 升到 A_FAST
    SNAP: 0.12,     // 单样本跳变 > 12% ROI 直接跟上(重新捕获)
    TAU_I: 0.05,    // s,帧级插值时间常数
};

const EPS = 0.0015; // 0.15% 变化阈值
const clamp01 = v => (v < 0 ? 0 : v > 1 ? 1 : v);
const num = v => (Number.isFinite(v) ? v : 0.5);
const editing = () => {
    const el = document.activeElement;
    return !!el && (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA');
};

const CSS = `
.gesture-cam {
    appearance: none;
    -webkit-appearance: none;
    background-color: transparent;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='6' height='4' viewBox='0 0 6 4'%3E%3Cpath d='M0 0l3 4 3-4z' fill='rgba(255,255,255,.62)'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 4px center;
    border: 1px solid transparent;
    border-radius: 0;
    padding: 2px 14px 2px 5px;
    margin: 0;
    font-family: "SF Mono", ui-monospace, Menlo, Consolas, monospace;
    font-size: 7px;
    font-weight: 500;
    letter-spacing: .14em;
    text-transform: uppercase;
    line-height: 1.4;
    color: rgba(255, 255, 255, .70);
    cursor: pointer;
    pointer-events: auto;
    vertical-align: middle;
    transition: color .16s ease, border-color .16s ease;
}
.gesture-cam:hover { color: rgba(255, 255, 255, .95); border-color: rgba(255, 255, 255, .28); }
.gesture-cam:focus { outline: none; }
.gesture-cam.on { color: #fff; border-color: rgba(255, 255, 255, .32); }
.gesture-cam.busy { color: rgba(255, 255, 255, .28); cursor: default; }
.gesture-cam option { background: #000; color: #fff; letter-spacing: .1em; }
`;

function injectStyle() {
    if (document.getElementById('gesture-ui-style')) return;
    const style = document.createElement('style');
    style.id = 'gesture-ui-style';
    style.textContent = CSS;
    document.head.appendChild(style);
}

/* 下拉口插进现有顶栏,不新增任何浮层。
 *  · 静态标签(span.tag 里是固定文字)→ 放进标签内、文字之前,右对齐不变
 *  · 动态标签(#posTag 每帧改 textContent,放进去会被冲掉)→ 挂到 .hdr 末尾
 *  · 都没有时退回到左下角固定位
 */
function mountSelect(CAM) {
    const header = document.querySelector('header');
    const hdr = document.querySelector('.hdr');
    const tag = (header || hdr || document).querySelector('.tag');

    if (tag && !tag.id) {
        tag.prepend(CAM);
        return;
    }
    if (hdr || header) {
        CAM.style.marginLeft = '10px';
        (hdr || header).appendChild(CAM);
        return;
    }
    Object.assign(CAM.style, {
        position: 'fixed',
        left: '8px',
        bottom: '8px',
        zIndex: '60',
    });
    document.body.appendChild(CAM);
}

/**
 * @param {{
 *   channels?: { x: string, y: string },
 *   read: () => { x: number, y: number },
 *   write: (x: number, y: number) => void,
 *   send: (id: string, value: number, gesture: string) => void,
 *   blocked?: () => boolean,
 * }} opts
 */
export function attachGestureControl(opts = {}) {
    const channels = opts.channels || { x: 'x', y: 'y' };
    const read = opts.read || (() => ({ x: 0.5, y: 0.5 }));
    const write = opts.write || (() => {});
    const send = opts.send || (() => {});
    const blocked = opts.blocked || (() => false);

    injectStyle();

    const CAM = document.createElement('select');
    CAM.className = 'gesture-cam';
    CAM.setAttribute('aria-label', 'Gesture camera mode');
    CAM.title = 'Gesture camera';
    CAM.innerHTML = '<option value="camera-off" selected>camera-off</option>' +
        '<option value="camera-left">camera-left</option>' +
        '<option value="camera-right">camera-right</option>';
    mountSelect(CAM);

    let mod = null;
    let on = false;
    let token = 0;          // 作废在途的启动
    let runId = 0;          // 只允许一条 rAF 链
    let seq = -1;           // 已处理的推理序号
    let lastT = 0;

    const now = { x: 0.5, y: 0.5 };
    const to = { x: 0.5, y: 0.5 };
    const filt = { x: { v: 0.5, sg: 0, n: 0 }, y: { v: 0.5, sg: 0, n: 0 } };
    const lastSent = { x: null, y: null };

    /* 从插件当前值起步:开启手势时参数不跳变 */
    const seed = () => {
        const p = read() || {};
        const x = clamp01(num(p.x));
        const y = clamp01(num(p.y));
        for (const k of ['x', 'y']) {
            const v = k === 'x' ? x : y;
            now[k] = to[k] = filt[k].v = v;
            filt[k].sg = 0;
            filt[k].n = 0;
            lastSent[k] = v;
        }
        seq = -1;
        lastT = 0;
    };

    /* 样本级:抖动会不断变号走慢通道;同向连续样本走快通道 */
    const sample = (k, raw) => {
        const st = filt[k];
        const d = raw - st.v;
        if (Math.abs(d) > GST.SNAP) {
            st.v = raw;
            st.sg = 0;
            st.n = 0;
            return;
        }
        const sg = Math.sign(d);
        if (sg === 0) return;
        if (sg === st.sg) st.n++;
        else { st.sg = sg; st.n = 1; }

        const gain = Math.min(1, Math.max(0, Math.abs(d) - GST.NOISE) / GST.SPAN);
        const a = st.n >= 2
            ? Math.max(GST.A_STEADY, GST.A_SLOW + (GST.A_FAST - GST.A_SLOW) * gain)
            : GST.A_SLOW + (GST.A_FAST - GST.A_SLOW) * gain;
        st.v += d * a;
    };

    const emit = (k, v) => {
        const prev = lastSent[k];
        if (prev !== null && Math.abs(v - prev) <= EPS) return;
        lastSent[k] = v;
        send(channels[k], v, 'value');
    };

    /* 帧级:把 15fps 的台阶抹平 */
    const loop = id => {
        if (!on || id !== runId) return;
        requestAnimationFrame(() => loop(id));

        const t = performance.now();
        const dt = lastT ? Math.min(0.1, (t - lastT) / 1000) : 1 / 60;
        lastT = t;

        const L = mod && mod.latest;
        if (!L) return;

        if (L.seq !== seq) {
            seq = L.seq;
            if (L.present) {
                to.x = clamp01(num(L.x));
                to.y = clamp01(num(L.y));
                sample('x', to.x);
                sample('y', to.y);
            }
        }

        const gi = 1 - Math.exp(-dt / GST.TAU_I);
        now.x += (filt.x.v - now.x) * gi;
        now.y += (filt.y.v - now.y) * gi;

        if (blocked() || editing()) return;

        write(now.x, now.y);
        emit('x', now.x);
        emit('y', now.y);
    };

    const stopGesture = () => {
        on = false;
        runId++;
        if (mod) {
            try { mod.stop(); } catch (e) { /* 已释放 */ }
            mod = null;
        }
        CAM.classList.remove('on');
    };

    const startGesture = async mode => {
        const my = ++token;
        CAM.classList.add('busy');
        CAM.disabled = true;

        try {
            const m = await import('./gesture.js');
            await m.start(undefined, { camera: mode });

            /* 启动期间选择已变:丢弃这次结果并释放摄像头 */
            if (my !== token) {
                m.stop();
                return;
            }

            mod = m;
            on = true;
            runId++;
            seed();
            CAM.classList.add('on');
            requestAnimationFrame(() => loop(runId));
        } catch (e) {
            console.error('Cabbage: 手势启动失败', e);
            if (my === token) {
                CAM.value = 'camera-off';
                stopGesture();
            }
        } finally {
            if (my === token) {
                CAM.disabled = false;
                CAM.classList.remove('busy');
            }
        }
    };

    CAM.addEventListener('change', () => {
        token++;
        stopGesture();
        if (CAM.value !== 'camera-off') startGesture(CAM.value);
    });

    return {
        stop: () => { token++; stopGesture(); CAM.value = 'camera-off'; },
        get running() { return on; },
    };
}
