#!/usr/bin/env python3
"""Csound 语法自检：给 Cabbage 专有 opcode 打桩，再用 CLI csound 编译一遍。

Cabbage 的 cabbageGetValue / cabbageSetValue / cabbageSet 只在宿主里存在，
CLI csound 不认识它们，直接编译会在第一处报 syntax error。
这里插入最小桩函数，只是为了把整份 orchestra 真编译一遍，抓真正的语法/变量错误。
"""
import re
import subprocess
import sys
import tempfile
from pathlib import Path

STUB = """
; ---- test stubs (only for CLI syntax check) ----
opcode cabbageGetValue, k, S
    Sname xin
    kval init 0
    xout kval
endop
opcode cabbageGetValue, k, Sk
    Sname, kdef xin
    kval init 0
    xout kval
endop
opcode cabbageSetValue, 0, Sk
    Sname, kval xin
endop
opcode cabbageSetValue, 0, Skk
    Sname, kval, ktrig xin
endop
opcode cabbageSet, 0, kSS
    ktrig, Sname, Sval xin
endop
opcode cabbageSet, 0, kSSS
    ktrig, Sname, Sattr, Sval xin
endop
opcode cabbageSet, 0, kSkk
    ktrig, Sname, kx, ky xin
endop
opcode cabbageSet, 0, kSkkk
    ktrig, Sname, kx, ky, kw xin
endop
opcode cabbageSet, 0, kSkkkk
    ktrig, Sname, kx, ky, kw, kh xin
endop
; Cabbage 3 自带 Csound 7 才有 maxk(a,k,i) 重载；CLI 6.18 只有 maxk(k,k)，补一个桩
opcode maxk, k, aki
    ain, kmet, itrig xin
    kval init 0
    xout kval
endop
; ---- end stubs ----
"""

def main(path):
    src = Path(path).read_text(encoding="utf-8")
    m = re.search(r"(0dbfs\s*=\s*[0-9.]+)", src)
    if not m:
        raise SystemExit("找不到 0dbfs 行")
    test = src[: m.end()] + "\n" + STUB + src[m.end():]
    # f 0 z 是无限时长，用 score 的 e 指令把离线渲染截到 0.05 秒
    test = test.replace("</CsScore>", "e 0.05\n</CsScore>")
    with tempfile.NamedTemporaryFile("w", suffix=".csd", delete=False, encoding="utf-8") as f:
        f.write(test)
        tmp = f.name
    # 本机 CLI csound 没有可用音频设备：解析完就卡在音频初始化。
    # 解析是同步的、很靠前，所以只取前几秒输出判断语法即可。
    try:
        r = subprocess.run(["csound", "-n", "-d", "-+rtmidi=NULL", tmp],
                           capture_output=True, text=True, timeout=6)
        out = (r.stdout or "") + (r.stderr or "")
    except subprocess.TimeoutExpired as e:
        out = (e.stdout or b"").decode("utf-8", "replace") + (e.stderr or b"").decode("utf-8", "replace")
    errs = [l for l in out.splitlines()
            if re.search(r"error:|Parsing failed|cannot compile|Unexpected untyped", l, re.I)]
    if errs:
        print(f"✗ {path}")
        for l in errs[:20]:
            print("   ", l.strip())
        return 1
    print(f"✓ {path}")
    return 0


if __name__ == "__main__":
    sys.exit(max(main(p) for p in sys.argv[1:]))
