#!/usr/bin/env python3
"""把手势资源（MediaPipe WASM + 手部模型）分发到需要它的插件工程。

仓库里只保留一份 `shared/gesture/`（16.8 MB）。接入手势的工程共 12 个
（Stasis / SwarmGrain / Boids × Depth / Quad / HRTF / Ambi），
它们在运行时从自己目录下的 `mediapipe/` 读取资源，所以要复制过去。

用法：
    python3 scripts/gesture-assets.py            # 复制（或覆盖）到所有带 gesture.js 的工程
    python3 scripts/gesture-assets.py --check    # 只检查，不改文件
    python3 scripts/gesture-assets.py --clean    # 删除工程里的副本

复制出来的 `mediapipe/` 已在 .gitignore 里排除，不会进 git。
没有这些文件时插件其余功能不受影响，只有手势菜单（CAMERA）失效。
"""
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "shared" / "gesture"
DEST_NAME = "mediapipe"
EXPECTED = ["vision_bundle.js", "hand_landmarker.task", "wasm/vision_wasm_internal.wasm"]


def targets():
    return sorted(p for p in ROOT.glob("*/*Cabbage3") if (p / "gesture.js").exists())


def missing(dst: Path):
    return [f for f in EXPECTED if not (dst / f).exists()]


def main(argv):
    mode = "apply"
    for flag in ("--check", "--clean"):
        if flag in argv:
            mode = flag[2:]

    if not SRC.is_dir():
        raise SystemExit(f"✗ 缺少源目录 {SRC.relative_to(ROOT)}")
    absent = missing(SRC)
    if absent:
        raise SystemExit(f"✗ {SRC.relative_to(ROOT)} 不完整，缺：{', '.join(absent)}")

    projects = targets()
    if not projects:
        raise SystemExit("✗ 没找到带 gesture.js 的工程")

    if mode == "check":
        bad = 0
        for proj in projects:
            lack = missing(proj / DEST_NAME)
            ok = not lack
            bad += 0 if ok else 1
            print(f"{'✓' if ok else '✗'} {proj.relative_to(ROOT)}")
            if lack:
                print(f"    缺：{', '.join(lack)}")
        print(f"\n{len(projects) - bad}/{len(projects)} 已就绪")
        return 0 if bad == 0 else 1

    if mode == "clean":
        for proj in projects:
            dst = proj / DEST_NAME
            if dst.exists():
                shutil.rmtree(dst)
                print(f"– 删除 {dst.relative_to(ROOT)}")
        return 0

    for proj in projects:
        dst = proj / DEST_NAME
        if dst.exists():
            shutil.rmtree(dst)
        shutil.copytree(SRC, dst, ignore=shutil.ignore_patterns("README.md", "*.md", ".DS_Store"))
        print(f"✓ {dst.relative_to(ROOT)}")
    print(f"\n完成：{len(projects)} 个工程。导出（export_plugin.py）之前要先跑这一步，")
    print("否则部署到 ~/Library/CabbageAudio/<NAME>/ 的运行时里不会带 mediapipe/。")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
