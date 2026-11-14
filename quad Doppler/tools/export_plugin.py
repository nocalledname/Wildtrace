#!/usr/bin/env python3
"""把 quad Doppler 下的插件导出成 AUv2 (.component) + VST3，并装到用户级目录。

用法：
    python3 tools/export_plugin.py "Quad-Orbita Cabbage3" [--no-install] [--no-vst3]

    --no-vst3  只出 AU。四声道的 VST3 在 Cabbage 3 里不可用（§9.1 末「决定」：Lattice 的
               process() 只喂端口 0 却按总声道数写，越界），这是包装器 C++ 的问题，
               CSD 层无解。四声道交付一律走 AU；立体声（depth）版 VST3 正常，不要加这个开关。

做的事（与模板 §8.1 完全一致，另外补上 VST3 与验证）：
  1. 从 CSD 的 <Cabbage> 里读 pluginId / caption（不靠手抄，避免与 CSD 不一致）
  2. 复制模板 bundle，按 4 字符 ID 打补丁（等长替换，长度不等直接报错）
  3. 重命名二进制 + chmod 755（模板是 644，缺执行位宿主看不到）
  4. 改 Info.plist（CFBundle* / AudioComponents.subtype / name）
  5. 部署运行时到 ~/Library/CabbageAudio/<NAME>/（整目录同步，跳过 build/；
     源工程里的 help.html / help-ui.js / gesture.js / gesture-ui.js / mediapipe/ 一并带过去）
  6. codesign -s - 并校验
  7. 装到 ~/Library/Audio/Plug-Ins/{Components,VST3}（--no-vst3 时只装 Components）
"""
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

def find_extension():
    """定位已安装的 Cabbage 3 扩展（版本号会变，不写死）。

    VS Code 把扩展装在 ~/.vscode/extensions/cabbageaudio.vscabbage-<版本>/，
    版本号随更新变化（写作时 3.0.10-beta，之后出现了 3.0.27-beta）。
    这里取目录名排序最后的那个（同版本时 beta 版排在后）。
    """
    roots = [
        Path.home() / ".vscode/extensions",
        Path.home() / ".vscode-insiders/extensions",
        Path.home() / ".vscode-server/extensions",
    ]
    found = []
    for root in roots:
        if root.is_dir():
            found += sorted(root.glob("cabbageaudio.vscabbage-*"))
    if not found:
        raise SystemExit(
            "✗ 找不到 Cabbage 3 扩展。请先在 VS Code 里安装 Cabbage 扩展（.vsix），\n"
            "  确认它出现在 ~/.vscode/extensions/cabbageaudio.vscabbage-* 下。"
        )
    latest = found[-1]
    if not (latest / "src/CabbageBinaries").is_dir():
        raise SystemExit(f"✗ 扩展目录里没有 src/CabbageBinaries：{latest}")
    return latest


EXT = find_extension()
BIN = EXT / "src/CabbageBinaries"
AU_TPL = BIN / "CabbagePluginEffectAUv2.component"
VST3_TPL = BIN / "CabbagePluginEffect.vst3"

AU_ORIG = (b"com.cabbageaudio.1d47", b"com_cabbageaudio_1d47", b"Cp47")
AU_BIN_NAME = "CabbagePluginEffectAUv2"
VST3_BIN_NAME = "CabbagePluginEffect"

HOME = Path.home()
RUNTIME_ROOT = HOME / "Library/CabbageAudio"
AU_DEST = HOME / "Library/Audio/Plug-Ins/Components"
VST3_DEST = HOME / "Library/Audio/Plug-Ins/VST3"


def run(cmd, **kw):
    r = subprocess.run(cmd, capture_output=True, text=True, **kw)
    if r.returncode != 0:
        raise SystemExit(f"✗ {' '.join(map(str, cmd))}\n{r.stdout}\n{r.stderr}")
    return r.stdout


def read_identity(proj: Path):
    csd = next(proj.glob("*.csd"))
    src = csd.read_text(encoding="utf-8")
    cfg = json.loads(re.search(r"<Cabbage>(.*?)</Cabbage>", src, re.S).group(1))
    pid = cfg["pluginId"]
    if len(pid) != 4:
        raise SystemExit(f"✗ pluginId 必须 4 字符，当前 {pid!r}")
    caption = next(w for w in cfg["widgets"] if w["type"] == "form")["caption"]
    return csd, pid, caption


def patch_binary(path: Path, pid: str, au_only: bool = True):
    """等长替换，长度不等说明 ID 不合法，直接报错而不是写坏二进制。

    AU 模板里有三处（CLAP id / NSView id / AU subtype）；VST3 模板里只有 subtype 一处。
    """
    data = path.read_bytes()
    new_id = f"com.cabbageaudio.{pid.lower()}".encode()
    new_ns = f"com_cabbageaudio_{pid.lower()}".encode()
    pairs = [(AU_ORIG[2], pid.encode())]
    if au_only:
        pairs = [(AU_ORIG[0], new_id), (AU_ORIG[1], new_ns)] + pairs
    for old, new in pairs:
        assert len(old) == len(new), f"长度不等: {old!r} → {new!r}"
        if data.count(old) == 0:
            raise SystemExit(f"✗ 二进制里找不到 {old!r}")
        data = data.replace(old, new)
    path.write_bytes(data)


def deploy_runtime(src_proj: Path, csd: Path, name: str):
    """整目录同步（跳过 build/）。

    ★ 不能只拷一个固定清单：Stasis / SwarmGrain / Boids 六台还有
      help.html + help-ui.js + gesture.js + gesture-ui.js + mediapipe/（17MB）。
      早先这里 rmtree 后按固定清单重拷，结果「改了图标 → 重新导出」把手工放进运行时的
      手册和手势文件全删了，宿主里 `?` 与 CAMERA 直接失效，而且没有任何报错。
      现在按源目录整份同步：新增什么前端文件都不用改这里。
    """
    dst = RUNTIME_ROOT / name
    if dst.exists():
        shutil.rmtree(dst)
    dst.mkdir(parents=True)

    for item in src_proj.iterdir():
        if item.name in ("build", "__pycache__", ".DS_Store"):
            continue
        if item.is_dir():
            shutil.copytree(item, dst / item.name, symlinks=True)
        else:
            shutil.copy2(item, dst / item.name)

    # 部署名必须 = 二进制名（CSD 文件名就是宿主查找的键）
    (dst / csd.name).rename(dst / f"{name}.csd")

    # 运行时：cabbage/ 必须是**完整**的（约 12 个文件），不是只有 cabbage.js。
    # ★ 源工程里的 cabbage/ 常常只放了 cabbage.js（手抄示例目录的习惯），
    #   直接同步过去会让 Cabbage 判定「这不是 C3 工程」→ 静默退回 C2 解析：
    #   日志刷 "Unknown widget type: form / rotarySlider"、参数全消失、**四路输出全零**
    #   而宿主照样能加载。所以这里按「有没有 main.js」判完整，不完整就整份换成扩展内置的。
    dst_cabbage = dst / "cabbage"
    if not (dst_cabbage / "main.js").exists():
        if dst_cabbage.exists():
            shutil.rmtree(dst_cabbage)
        shutil.copytree(EXT / "src/cabbage", dst_cabbage)
    shutil.copy2(EXT / "media/cabbage.css", dst / "cabbage.css")

    if not (dst_cabbage / "main.js").exists():
        raise SystemExit(f"✗ 运行时 cabbage/ 不完整（缺 main.js），宿主会静默退回 C2 解析：{dst}")
    return dst


def build_au(proj: Path, name: str, pid: str):
    out = proj / "build" / f"{name}.component"
    if out.exists():
        shutil.rmtree(out)
    subprocess.run(["ditto", str(AU_TPL), str(out)], check=True)

    macos = out / "Contents/MacOS"
    patch_binary(macos / AU_BIN_NAME, pid)
    (macos / AU_BIN_NAME).rename(macos / name)
    (macos / name).chmod(0o755)

    plist = out / "Contents/Info.plist"
    for key, val in [
        ("CFBundleExecutable", name),
        ("CFBundleName", name),
        ("CFBundleIdentifier", f"com.cabbageaudio.{name.lower()}"),
        ("AudioComponents.0.subtype", pid),
        ("AudioComponents.0.name", f"CabbageAudio: {name}"),
    ]:
        run(["plutil", "-replace", key, "-string", val, str(plist)])
    return out


def build_vst3(proj: Path, name: str, pid: str):
    out = proj / "build" / f"{name}.vst3"
    if out.exists():
        shutil.rmtree(out)
    subprocess.run(["ditto", str(VST3_TPL), str(out)], check=True)

    macos = out / "Contents/MacOS"
    patch_binary(macos / VST3_BIN_NAME, pid, au_only=False)
    (macos / VST3_BIN_NAME).rename(macos / name)
    (macos / name).chmod(0o755)

    plist = out / "Contents/Info.plist"
    for key, val in [
        ("CFBundleExecutable", name),
        ("CFBundleName", name),
        ("CFBundleIdentifier", f"com.cabbageaudio.{name.lower()}.vst3"),
    ]:
        run(["plutil", "-replace", key, "-string", val, str(plist)])
    return out


def sign(bundle: Path):
    run(["codesign", "--force", "--deep", "--sign", "-", str(bundle)])
    run(["codesign", "--verify", "--deep", "--strict", str(bundle)])


def install(src: Path, dest: Path):
    dest.mkdir(parents=True, exist_ok=True)
    target = dest / src.name
    if target.exists():
        shutil.rmtree(target)
    subprocess.run(["ditto", str(src), str(target)], check=True)
    return target


def main(proj_name, do_install=True, do_vst3=True):
    # 支持三种写法：quad 下的目录名 / 绝对路径 / 相对 wildtrace 根的路径
    cand = Path(proj_name).expanduser()
    if cand.is_absolute() and cand.is_dir():
        proj = cand
    else:
        base = Path(__file__).resolve().parent.parent
        proj = base / proj_name
        if not proj.is_dir():
            alt = base.parent / proj_name          # 例如 "stereo wildtrace/Boids Cabbage3"
            if alt.is_dir():
                proj = alt
    csd, pid, name = read_identity(proj)
    print(f"── {name}  (id={pid}, csd={csd.name})")

    au = build_au(proj, name, pid)
    print(f"   ✓ AU   {au.relative_to(proj)}")
    vst3 = build_vst3(proj, name, pid) if do_vst3 else None
    print(f"   ✓ VST3 {vst3.relative_to(proj)}" if vst3 else "   – VST3 跳过（--no-vst3）")

    rt = deploy_runtime(proj, csd, name)
    print(f"   ✓ 运行时 {rt}")

    sign(au)
    if vst3:
        sign(vst3)
    print("   ✓ 签名通过")

    if do_install:
        install(au, AU_DEST)
        if vst3:
            install(vst3, VST3_DEST)
            print(f"   ✓ 安装 → {AU_DEST.name} / {VST3_DEST.name}")
        else:
            print(f"   ✓ 安装 → {AU_DEST.name}")

    return name, pid


if __name__ == "__main__":
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if not args:
        print(__doc__.strip())
        raise SystemExit(2)
    do_install = "--no-install" not in sys.argv
    do_vst3 = "--no-vst3" not in sys.argv
    done = [main(a, do_install, do_vst3) for a in args]
    print("\n导出清单：")
    for n, p in done:
        print(f"  {p}  {n}")
