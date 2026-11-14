/* 顶栏 `?` + 内嵌 iframe 使用手册。
 *
 * 为什么必须是 iframe：插件 WebView（choc::ui::WebView / WKWebView）没有实现
 * createWebViewWithConfiguration，window.open() 只会返回一个被丢弃的 WindowProxy，
 * 点了毫无反应。所以只做内嵌查看，不提供"在浏览器打开"。
 *
 * 手册 lazy load：不点 `?` 就不加载 help.html，常驻内存为 0。
 */

const CSS = `
.help-btn {
    appearance: none;
    -webkit-appearance: none;
    background: none;
    border: 1px solid rgba(255, 255, 255, .22);
    border-radius: 50%;
    width: 14px;
    height: 14px;
    padding: 0;
    margin: 0;
    font-family: ui-monospace, Menlo, Consolas, monospace;
    font-size: 9px;
    line-height: 1;
    color: rgba(255, 255, 255, .62);
    cursor: pointer;
    pointer-events: auto;
    vertical-align: middle;
    flex: none;
    transition: color .16s ease, border-color .16s ease;
}
.help-btn:hover { color: #fff; border-color: rgba(255, 255, 255, .60); }
.help-btn:focus { outline: none; }

.help-overlay {
    position: fixed;
    inset: 0;
    z-index: 200;
    display: flex;
    padding: 8px;
    background: rgba(0, 0, 0, .84);
    opacity: 0;
    pointer-events: none;
    transition: opacity .18s ease;
}
.help-overlay.on { opacity: 1; pointer-events: auto; }

.help-sheet {
    flex: 1 1 auto;
    min-width: 0;
    display: flex;
    flex-direction: column;
    border: 1px solid rgba(255, 255, 255, .16);
    background: #000;
    overflow: hidden;
}

.help-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
    padding: 5px 8px;
    border-bottom: 1px solid rgba(255, 255, 255, .14);
    flex: none;
}

.help-title {
    font-family: ui-monospace, Menlo, Consolas, monospace;
    font-size: 8px;
    letter-spacing: .24em;
    text-transform: uppercase;
    color: rgba(255, 255, 255, .58);
}

.help-close {
    appearance: none;
    background: none;
    border: none;
    padding: 0 2px;
    font-family: inherit;
    font-size: 13px;
    line-height: 1;
    color: rgba(255, 255, 255, .45);
    cursor: pointer;
}
.help-close:hover { color: #fff; }

.help-frame {
    flex: 1 1 auto;
    width: 100%;
    border: 0;
    background: #000;
}

.help-fallback {
    display: none;
    padding: 14px 12px;
    font-family: ui-monospace, Menlo, Consolas, monospace;
    font-size: 9.5px;
    line-height: 1.8;
    color: rgba(255, 255, 255, .6);
}
.help-fallback.on { display: block; }
.help-fallback code {
    font-size: 9px;
    color: rgba(255, 255, 255, .88);
    word-break: break-all;
}
`;

function injectStyle() {
    if (document.getElementById('help-ui-style')) return;
    const style = document.createElement('style');
    style.id = 'help-ui-style';
    style.textContent = CSS;
    document.head.appendChild(style);
}

/* 按钮排在 camera 下拉之后；没有下拉时退回顶栏右侧。
 * .tag 是行内文本容器（没有 flex gap），要自己补左右间距；
 * .hdr / header 是 flex 容器，间距交给 gap。 */
function mountButton(BTN) {
    const inline = () => {
        BTN.style.marginLeft = '6px';
        BTN.style.marginRight = '7px';
    };

    const cam = document.querySelector('.gesture-cam');
    if (cam && cam.parentNode) {
        cam.parentNode.insertBefore(BTN, cam.nextSibling);
        if (BTN.parentElement.closest('.tag')) inline();
        return;
    }
    const tag = document.querySelector('header .tag, .hdr .tag');
    if (tag && !tag.id) {
        tag.prepend(BTN);
        inline();
        return;
    }
    const host = document.querySelector('header') || document.querySelector('.hdr');
    if (host) {
        host.appendChild(BTN);
        return;
    }
    BTN.style.position = 'fixed';
    BTN.style.right = '8px';
    BTN.style.bottom = '8px';
    BTN.style.zIndex = '200';
    document.body.appendChild(BTN);
}

/**
 * @param {{ src?: string, title?: string }} [opts]
 */
export function attachHelp(opts = {}) {
    const src = opts.src || './help.html';
    const title = opts.title || 'HELP';

    if (document.querySelector('.help-btn')) return;   // 只装一次
    injectStyle();

    const BTN = document.createElement('button');
    BTN.type = 'button';
    BTN.className = 'help-btn';
    BTN.textContent = '?';
    BTN.title = '使用手册';
    BTN.setAttribute('aria-label', '使用手册');
    mountButton(BTN);

    const OVERLAY = document.createElement('div');
    OVERLAY.className = 'help-overlay';
    OVERLAY.setAttribute('aria-hidden', 'true');
    OVERLAY.innerHTML =
        '<div class="help-sheet">' +
            '<div class="help-bar">' +
                '<span class="help-title"></span>' +
                '<button class="help-close" type="button" aria-label="关闭手册">×</button>' +
            '</div>' +
            '<iframe class="help-frame" title="使用手册"></iframe>' +
            '<div class="help-fallback">' +
                '手册没能加载出来。请确认运行目录里存在 <code>help.html</code>：<br>' +
                '<code class="help-path"></code>' +
            '</div>' +
        '</div>';
    document.body.appendChild(OVERLAY);

    const FRAME = OVERLAY.querySelector('.help-frame');
    const FALLBACK = OVERLAY.querySelector('.help-fallback');
    const PATH = OVERLAY.querySelector('.help-path');
    const CLOSE = OVERLAY.querySelector('.help-close');
    OVERLAY.querySelector('.help-title').textContent = title;

    let loaded = false;
    let loading = false;
    let ready = false;
    let probeOk = false;

    FRAME.addEventListener('load', () => {
        ready = true;
        if (probeOk) FALLBACK.classList.remove('on');

        /* iframe 夺走焦点后 Esc 不会冒泡到父窗口，手册内部自己收一份 */
        try {
            FRAME.contentDocument.addEventListener('keydown', ev => {
                if (ev.key === 'Escape') close();
            });
        } catch (e) { /* 跨源时读不到，忽略 */ }
    });

    /* 先探一次文件在不在。不能只靠 iframe 的 load 事件：
     * 加载失败时浏览器也会对错误页触发 load，兜底提示永远不会出现。
     * choc:// 下没有 HTTP 状态码（status 恒为 0），所以只能「不 reject 就算通过」，
     * 有状态码时（http）才用 ok 判断。 */
    const probe = async () => {
        try {
            const res = await fetch(src, { cache: 'no-store' });
            return res && (res.status === 0 || res.ok);
        } catch (e) {
            console.warn('Cabbage: 手册加载失败 —', e);
            return false;
        }
    };

    const open = async () => {
        OVERLAY.classList.add('on');
        OVERLAY.setAttribute('aria-hidden', 'false');
        PATH.textContent = new URL(src, location.href).href;

        if (loaded) {
            setTimeout(() => {
                if (!ready) FALLBACK.classList.add('on');
            }, 1200);
            return;
        }
        if (loading) return;

        loading = true;
        const ok = await probe();
        loading = false;
        if (!ok) {
            FALLBACK.classList.add('on');
            return;
        }

        loaded = true;
        probeOk = true;
        ready = false;
        FRAME.src = src;

        setTimeout(() => {
            if (!ready) FALLBACK.classList.add('on');
        }, 1200);
    };

    const close = () => {
        OVERLAY.classList.remove('on');
        OVERLAY.setAttribute('aria-hidden', 'true');
    };

    BTN.addEventListener('click', open);
    CLOSE.addEventListener('click', close);

    /* 点遮罩空白处关闭 */
    OVERLAY.addEventListener('click', ev => {
        if (ev.target === OVERLAY) close();
    });

    window.addEventListener('keydown', ev => {
        if (ev.key === 'Escape' && OVERLAY.classList.contains('on')) close();
    });

    return { open, close };
}
