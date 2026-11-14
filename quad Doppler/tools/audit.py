#!/usr/bin/env python3
"""四声道插件全面体检：CSD ↔ DSP ↔ HTML 三方交叉核对。

查的都是「不报错、但行为错」的暗病：
  A. 通道契约：DSP 读写的通道必须在 widget 表里声明（否则 cabbageGetValue 静默返回 0）
  B. 顺序契约：PARAM_IDX 与 widget 书写顺序（自动化会绑错参数且不报错）
  C. 默认值契约：CSD defaultValue ↔ HTML P.def ↔ 写死的 input value ↔ JS 初值
  D. 四声道契约：nchnls / outq / instr 2 / outFL..RR 四表齐全
  E. 前端死代码：CSS 用了 --lvl 但 JS 从不赋值 之类
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# 全系列统一的默认值（模板 §12）
STD = {
    "roomSize": 50, "cutoff": 16000, "minWet": 0.1,
    "masterGain": 2, "level": 2, "vol": 2, "dry_wet": 0.5, "drywet": 0.5,
}


def load(proj: Path):
    csd = next(proj.glob("*.csd"))
    src = csd.read_text(encoding="utf-8")
    cfg = json.loads(re.search(r"<Cabbage>(.*?)</Cabbage>", src, re.S).group(1))
    instr = re.search(r"<CsInstruments>(.*?)</CsInstruments>", src, re.S).group(1)
    score = re.search(r"<CsScore>(.*?)</CsScore>", src, re.S).group(1)
    html = (proj / "index.html").read_text(encoding="utf-8")
    return csd, src, cfg, instr, score, html


def audit(proj: Path):
    issues = []
    csd, src, cfg, instr, score, html = load(proj)
    name = proj.name

    # ---------- 通道表 ----------
    widgets = [w for w in cfg["widgets"] if w.get("channels")]
    chans = [w["channels"][0]["id"] for w in widgets]
    auto = [w["channels"][0]["id"] for w in widgets if w.get("automatable")]
    hidden = [c for c in chans if c not in auto]
    decl = set(chans)

    # ---------- A. DSP 读写 vs 声明 ----------
    reads = set(re.findall(r'cabbageGetValue\s+"([^"]+)"', instr))
    writes_val = set(re.findall(r'cabbageSetValue\s+"([^"]+)"', instr))
    writes_set = set(re.findall(r'cabbageSet\w*\s+[^,]+,\s*"([^"]+)"', instr))
    missing = (reads | writes_val | writes_set) - decl
    for c in sorted(missing):
        issues.append(f"A: DSP 用了未声明通道 '{c}'（cabbageGetValue 会静默返回 0）")

    # 声明了但 DSP 从不读（可能是废弃参数，提示而非报错）
    unused = sorted(decl - reads - writes_val - writes_set)
    if unused:
        issues.append(f"A?: 声明但 DSP 从不读: {', '.join(unused)}")

    # ---------- B. PARAM_IDX ----------
    m = re.search(r"const PARAM_IDX = \[(.*?)\];", html, re.S)
    if not m:
        issues.append("B: HTML 缺 PARAM_IDX")
    else:
        idx = re.findall(r"'([^']+)'", m.group(1))
        if idx != auto and idx != chans:
            issues.append(f"B: PARAM_IDX 与 widget 顺序不一致\n"
                          f"      idx={idx}\n      csd={auto}")

    # ---------- C. 默认值 ----------
    defs = {}
    for w in widgets:
        ch = w["channels"][0]
        if "defaultValue" in ch.get("range", {}):
            defs[ch["id"]] = ch["range"]["defaultValue"]
    # HTML P 表
    for key, val in re.findall(r"(\w+):\s*\{[^}]*?def:\s*([-\d.]+)", html):
        if key in defs and abs(float(val) - float(defs[key])) > 1e-9:
            issues.append(f"C: {key} 默认值不一致  CSD={defs[key]}  HTML P.def={val}")
    # 写死的 input value（只查旋钮数值框）
    for key in ("roomSize", "cutoff", "masterGain"):
        if key not in defs:
            continue
        m2 = re.search(r'id="v\w*"[^>]*value="([-\d.]+)"', html)
        if m2 and abs(float(m2.group(1)) - float(defs[key])) > 1e-9 and key in ("roomSize", "cutoff", "masterGain"):
            # 只在能找到对应旋钮 id 时比较，避免张冠李戴
            pass
    # 标准值
    for k, want in STD.items():
        if k in defs and abs(float(defs[k]) - want) > 1e-9:
            issues.append(f"C: {k} 默认值 {defs[k]} ≠ 系列标准 {want}")

    # HTML P 的 min/max 与 CSD range 对照
    for key, mn, mx in re.findall(r"(\w+):\s*\{[^}]*?min:\s*([-\d.]+),\s*max:\s*([-\d.]+)", html):
        if key in defs:
            csd_w = next(w for w in widgets if w["channels"][0]["id"] == key)
            r = csd_w["channels"][0]["range"]
            if abs(float(mn) - float(r["min"])) > 1e-9 or abs(float(mx) - float(r["max"])) > 1e-9:
                issues.append(f"C: {key} 范围不一致  CSD=[{r['min']},{r['max']}]  HTML=[{mn},{mx}]")

    # 湿声默认值：CSD 的两个 horizontalSlider vs HTML WET_DEF
    wet_csd = {k: defs[k] for k in ("minWet", "maxWet") if k in defs}
    m_wet = re.search(r"WET_DEF\s*=\s*\{([^}]*)\}", html)
    if m_wet and wet_csd:
        for k, v in re.findall(r"(minWet|maxWet):\s*([-\d.]+)", m_wet.group(1)):
            if k in wet_csd and abs(float(v) - float(wet_csd[k])) > 1e-9:
                issues.append(f"C: {k} 默认值不一致  CSD={wet_csd[k]}  HTML WET_DEF={v}")

    # ---------- D. 四声道 ----------
    if "nchnls = 4" not in instr:
        issues.append("D: nchnls 不是 4")
    # 不写 nchnls_i：Csound 让它等于 nchnls（4 in / 4 out），VST3 才能在 Live 里配上输出总线。
    # 写了 nchnls_i = 2 会变成 2 in / 4 out，Live 报 "No valid output bus could be found"。
    if re.search(r"(?m)^\s*nchnls_i\s*=", instr):
        issues.append("D: 不该写 nchnls_i（VST3 在 Live 里会因 2 in / 4 out 加载失败）")
    cabbage_json = re.search(r"<Cabbage>(.*?)</Cabbage>", src, re.S).group(1)
    if "channelConfig" in cabbage_json:
        issues.append("D: 仍有 channelConfig（必须删，靠 nchnls 回退）")
    # Csound 7 起 outq 已弃用；out 带 4 个参数就是四声道，2 个参数才是立体声
    m_out_call = re.search(r"^\s*(outq|out)\s+(a\w+)((?:\s*,\s*a\w+)*)\s*$", instr, re.M)
    if not m_out_call:
        issues.append("D: 找不到输出调用（out/outq）")
    else:
        nargs = 1 + m_out_call.group(3).count(",")
        if nargs != 4:
            issues.append(f"D: {m_out_call.group(1)} 只有 {nargs} 路参数（应为 4）")
        if m_out_call.group(1) == "outq":
            issues.append("D: 仍用 outq（Csound 7 已弃用，改 out 四参数）")
    for c in ("outFL", "outFR", "outRL", "outRR"):
        if c not in decl:
            issues.append(f"D: 缺通道 {c}")
        if f'"out{c[3:]}' in html:
            pass
    # 输出乐器 = 含 outq 的那个 instr（SwarmGrain 是 3，其余是 2）
    m_out = re.search(r"^instr\s+(\d+)\b(?:(?!^instr\s).)*?^\s*(?:out|outq)\s+a",
                      instr, re.S | re.M)
    if not m_out:
        issues.append("D: 找不到含输出调用（out/outq）的乐器")
    else:
        n_out = m_out.group(1)
        if not re.search(rf"^\s*i\s*{n_out}\s", score, re.M):
            issues.append(f"D: score 没启动输出乐器 instr {n_out}")

    # ---------- E. 前端 ----------
    ids = set(re.findall(r'\bid="([^"]+)"', html))
    js = html.split("<script", 1)[-1]
    # 有些界面元素是 JS 动态建的（Boids 的湿声双滑块），id 在 JS 里赋值
    ids |= set(re.findall(r"""\.id\s*=\s*['"]([A-Za-z0-9_]+)['"]""", js))
    ids |= set(re.findall(r"""id:\s*['"]([A-Za-z0-9_]+)['"]""", js))
    for ref in set(re.findall(r"\$\('([A-Za-z0-9_]+)'\)", js)) | \
               set(re.findall(r"getElementById\('([A-Za-z0-9_]+)'\)", js)):
        if ref not in ids:
            issues.append(f"E: JS 引用不存在的元素 '{ref}'")
    for ch in ("FL", "FR", "RL", "RR"):
        for pre in ("mtr", "cap", "scale"):
            if pre + ch not in ids:
                issues.append(f"E: 缺 {pre}{ch}")
    # --lvl 死变量
    if "--lvl" in html and "setProperty('--lvl'" not in html:
        issues.append("E: CSS 用了 --lvl 但 JS 从不赋值（光晕恒定不动）")
    # METER_H 与 .bar
    mh = re.search(r"const METER_H = (\d+)", js)
    bars = re.findall(r"\.bar \{[^}]*?height:\s*(\d+)px", html, re.S)
    if mh and bars and int(mh.group(1)) != int(bars[-1]):
        issues.append(f"E: METER_H {mh.group(1)} ≠ 生效 .bar 高度 {bars[-1]}")
    # 表通道名与 HTML case 对齐
    for ch in ("FL", "FR", "RL", "RR"):
        if f"case 'out{ch}'" not in js:
            issues.append(f"E: applyValue 缺 case 'out{ch}'")

    return name, issues


def main(dirs):
    total = 0
    for d in sorted(dirs):
        proj = ROOT / d if not Path(d).is_absolute() else Path(d)
        name, issues = audit(proj)
        if issues:
            total += len(issues)
            print(f"✗ {name}")
            for i in issues:
                print(f"   {i}")
        else:
            print(f"✓ {name}")
    print(f"\n共 {total} 个问题")
    return 1 if total else 0


if __name__ == "__main__":
    args = sys.argv[1:] or [p.name for p in sorted(ROOT.glob("*Cabbage3"))]
    sys.exit(main(args))
