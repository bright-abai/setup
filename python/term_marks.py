#!/usr/bin/env python3
"""Combine final marks ("Итоговая оценка") from up to 15 SpreadsheetML gradebooks
(T1-T4 + Y for G9-G11, files like "T1 G9.xls") into one xlsx, one sheet per student.
Usage: term_marks.py -cambridge|-russian [--input-dir DIR] [-o OUT] [--sheets "9,9 2"]
       term_marks.py --list-subjects FILE...
Cambridge: G11 has its own AS-level subject column, in AS order with no gaps.
Each grade block is Hr,T1-T4,Y; cells with no mark get '–' (grades a subject isn't taught in: whole block).
Needs the original XML export (not a re-saved binary .xls) and openpyxl."""
import argparse, os, re, sys
import xml.etree.ElementTree as ET
from openpyxl import Workbook
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter as L
 
NS = "{urn:schemas-microsoft-com:office:spreadsheet}"
FM = "Итоговая оценка"
GR = ["G9", "G10", "G11"]
TM = ["T1", "T2", "T3", "T4", "Y"]
PERIODS = [(g, t) for g in GR for t in TM]
THIN, THICK = Side(style="thin", color="CFCFCF"), Side(style="medium", color="9EB3D8")
 
def mp(s):  # "label=name|name=Hr9 Hr10 Hr11" lines -> ([(label, [gradebook names])], {label: [Hr per grade]})
    rows = [l.split("=") for l in s.strip().split("\n")]
    return [(a, b.split("|")) for a, b, _ in rows], {a: [int(x) if x.isdigit() else None for x in h.split()] for a, _, h in rows}
 
 
CAMBRIDGE = mp("""Mathematics (0580)=Mathematics|MATH=170 102 170
Geometry (0580)=Geometry=- 68 -
Computer Science (0478)=Computer Science|CS=68 68 68
Biology (0610)=Biology|BIO=68 68 68
Chemistry (0620)=Chemistry|CHEM=68 68 68
Physics (0625)=Physics|PHYS=68 68 68
English (0511)=English|ENG=170 170 136
Russian Language=Русский язык|Ря=34 102 68
Russian Literature=Русская литература|Р-ЛИТ=34 34 34
Kyrgyz Language=Kyrgyz|Кыргыз тили|Ky=34 102 102
Kyrgyz Literature=Кыргыз адабияты|К-АДА=34 34 34
Turkish=Turkish language|Tr=68 - -
Spanish=Spanish=- 34 -
History=History|HIST=102 68 68
Global Perspectives (0457)=Global Perspective|GP=102 68 -
Business Studies (0450)=Business|BUS=102 68 68
Geography (0460)=Geography|GEO=34 68 -
Physical Education=Physical Education|PE=68 68 68""")
 
RUSSIAN = mp("""Mathematics=Mathematics=170 102 102
Geometry=Geometry=- 34 68
Computer Science=Computer Science=68 68 68
Biology=Biology=34 68 68
Chemistry=Chemistry=68 34 68
Physics=Physics=68 68 68
English=English=170 136 136
English as a Second Language=English as a Second Language=- - -
Russian Language=Русский язык=68 102 102
Russian Literature=Русская литература=68 34 34
Kyrgyz Language=Кыргыз тили=102 102 102
Kyrgyz Literature=Кыргыз адабияты=34 34 34
Spanish=Spanish|Испанский язык=- - 68
History=История=68 34 68
Geography=География=34 68 68
Economics=Economics=34 - -
Business=Business=68 - -
Human and society=Человек и Общество=34 68 -
History of World Religions=История развития религий=34 - -
Technology=Технология=34 - -
Basic military training=Допризывная подготовка|Начальная военная подготовка|НВП=- 34 34
Physical Education=Физкультура=68 68 68""")
 
# Cambridge G11 rows: (IGCSE label used in the maps, AS-level label), in the required G11 order
AS = dict(zip("0580 0478 0610 0620 0625 0511 0450".split(), "9709 9618 9700 9701 9702 9093 9609".split()))
G11 = [(b, re.sub(r"\d{4}", lambda m: AS[m[0]], b)) for b in (
    "Mathematics (0580),Computer Science (0478),Biology (0610),Chemistry (0620),Physics (0625),English (0511),"
    "Russian Language,Russian Literature,Kyrgyz Language,Kyrgyz Literature,History,Business Studies (0450),"
    "Physical Education").split(",")]
 
 
# ------------------------------- reading ---------------------------------- #
def read_grid(sheet):
    """Sheet -> list of {col: text}; MergeAcross skips columns to stay aligned."""
    grid = []
    for row in sheet.iter(NS + "Row"):
        cells, col = {}, 0
        for c in row.findall(NS + "Cell"):
            i = c.get(NS + "Index")
            col = int(i) if i else col + 1
            t = c.findtext(NS + "Data")
            if t:
                cells[col] = t.strip()
            col += int(c.get(NS + "MergeAcross") or 0)
        grid.append(cells)
    return grid
 
 
def load_sheets(path):
    with open(path, "rb") as f:
        if f.read(4) == b"\xd0\xcf\x11\xe0":
            raise ValueError(f"{path} is a binary Excel file (re-saved in Excel/LibreOffice). "
                             "Use the original XML export from the school system.")
    return [(w.get(NS + "Name") or "Sheet", read_grid(w)) for w in ET.parse(path).getroot().iter(NS + "Worksheet")]
 
 
P = re.compile(r"^(.+?)\s*\(.*\)\s*$")  # "Subject (Teacher name)"
 
 
def find_subject_blocks(grid, h):
    """{subject: (first_col, last_col)} from the title row above header row h."""
    i = next((i for i in range(h - 1, -1, -1) if sum(bool(P.match(v)) for v in grid[i].values()) >= 3), None)
    if i is None:
        raise ValueError("Could not find the row with subject titles.")
    starts = sorted((c, P.match(t)[1].strip()) for c, t in grid[i].items() if P.match(t))
    last = max(max(r) for r in grid if r)
    return {code: (s, starts[n + 1][0] - 1 if n + 1 < len(starts) else last) for n, (s, code) in enumerate(starts)}
 
 
def clean_name(raw):
    return re.sub(r"\s+", " ", re.sub(r"\s*\|\s*", " | ", raw.strip().lstrip(",").strip()))
 
 
def name_key(n):
    return re.sub(r"[\s,|]+", " ", n).strip().casefold()
 
 
def ck(c):
    return c.strip().casefold()
 
 
def parse_mark(t):
    """'4' -> 4, '4 (comment)' -> 4, '' -> None; other text (e.g. 'Зачет') kept."""
    t = (t or "").strip()
    if not t:
        return None
    m = re.match(r"\d+(?:[.,]\d+)?", t)
    if not m:
        return t
    n = float(m[0].replace(",", "."))
    return int(n) if n.is_integer() else n
 
 
def read_sheet(grid):
    """-> (students, {code_key: {student: mark}}, {code_key: subject name}) or None."""
    h = next((i for i, r in enumerate(grid) if FM in r.values()), None)
    if h is None:
        return None
    fc, codes = {}, {}
    for code, (s, e) in find_subject_blocks(grid, h).items():
        c = next((c for c, v in grid[h].items() if v == FM and s <= c <= e), None)
        if c:
            fc[code], codes[ck(code)] = c, code
    students, marks = [], {}
    for row in grid[h + 1:]:
        if not row.get(2):
            continue
        n = clean_name(row[2])
        students.append(n)
        for code, c in fc.items():
            marks.setdefault(ck(code), {})[n] = parse_mark(row.get(c))
    return students, marks, codes
 
 
def is_cam(name, grid=None):
    """Cambridge sheets: 'Year 9', 'Year 10', '11-P' (also checked in the sheet title)."""
    t = [name] + ([grid[1][1]] if grid and len(grid) > 1 and grid[1].get(1) else [])
    return any(re.search(r"^year|year |11-?p", x.strip().casefold()) for x in t)
 
 
def sheet_filter(kind):
    return lambda n, g=None: is_cam(n, g) == (kind == "cambridge")
 
 
def extract(path, keep):
    students, marks, codes, used = [], {}, {}, []
    for name, grid in load_sheets(path):
        r = keep(name, grid) and read_sheet(grid)
        if not r:
            continue
        students += r[0]
        for k, v in r[1].items():
            marks.setdefault(k, {}).update(v)
        codes.update(r[2])
        used.append(name)
    if not students:
        raise ValueError(f"No matching sheets with '{FM}' columns in {path}. Sheets in the file: "
                         f"{', '.join(repr(n) for n, _ in load_sheets(path))}. Use --sheets to choose.")
    return students, marks, codes, used
 
 
FRE = re.compile(r"^(?:\d{4}\s+)?(T[1-4]|Y)\s+(G(?:9|10|11))\.xls$", re.I)
 
 
def discover(d):
    """Files named '<YYMM> <T1..T4|Y> <G9..G11>.xls' -> {(grade, term): path or None}."""
    if not os.path.isdir(d):
        raise ValueError(f"Input folder '{d}' does not exist.")
    found = {}
    for e in sorted(os.listdir(d)):
        m = FRE.match(e.strip())
        if m:
            k = m[2].upper(), m[1].upper()
            if k in found:
                raise ValueError(f"Duplicate input files for {k[0]} {k[1]}: {os.path.basename(found[k])} and {e}")
            found[k] = os.path.join(d, e)
    return {p: found.get(p) for p in PERIODS}
 
 
def combine(files, smap, keep):
    """-> ([(name, {label: {(grade, term): mark}})], (labels never found, unused gradebook subjects), {period: sheets})"""
    disp, table, seen, matched, used_codes, sheets = {}, {}, {}, set(), set(), {}
    for p in PERIODS:
        if not files[p]:
            continue
        students, marks, codes, sheets[p] = extract(files[p], keep)
        seen.update(codes)
        for n in students:
            k = name_key(n)
            if k not in disp:
                disp[k], table[k] = n, {l: {} for l, _ in smap}
            for l, cands in smap:
                c = next((ck(x) for x in cands if ck(x) in marks), None)
                if c is not None:
                    matched.add(l)
                    used_codes.add(c)
                    table[k][l][p] = marks[c].get(n)
    return ([(disp[k], table[k]) for k in disp],
            ([l for l, _ in smap if l not in matched], [v for c, v in seen.items() if c not in used_codes]), sheets)
 
 
# ------------------------------- writing ---------------------------------- #
def sheet_title(name, used):
    """Excel sheet name: <=31 chars, unique; uses the part after '|' when there is one."""
    base = re.sub(r"[\[\]:*?/\\]", "", name.split("|")[-1].strip() or name)[:31].strip() or "Student"
    t, n = base, 2
    while t.casefold() in used:
        s = f" ({n})"
        t, n = base[:31 - len(s)] + s, n + 1
    used.add(t.casefold())
    return t
 
 
def sty(c, bold=False, fl=None, h="center", nf=None, left=THIN):
    c.font = Font(name="Times New Roman", size=10, bold=bold, color="3A3A3A")
    c.border = Border(left=left, right=THIN, top=THIN, bottom=THIN)
    c.alignment = Alignment(horizontal=h, vertical="center")
    if fl:
        c.fill = fl
    if nf:
        c.number_format = nf
 
 
def avg_exprs(subj, smap, g, y, h, end):
    """(simple, hours-weighted) AVERAGE/SUMPRODUCT formulas for grade g's Y column, or (None, None).
    Blank and '–' marks are ignored, never counted as 0."""
    if not any(isinstance(subj[l].get((g, "Y")), (int, float)) for l, _ in smap):
        return None, None
    s, y, h = f"AVERAGE({y}4:{y}{end})", f"{y}4:{y}{end}", f"{h}4:{h}{end}"
    return s, f'IFERROR(SUMPRODUCT({h},{y})/SUMIF({y},">=0",{h}),{s})'
 
 
def combo(xs):
    xs = [x for x in xs if x]
    return f"AVERAGE({','.join(xs)})" if len(xs) > 1 else xs[0] if xs else '""'
 
 
def write_workbook(students, smap, hr, out, kind, have):
    """have = periods whose gradebook was found; empty cells there (or whole grades a subject isn't taught in) get '–'."""
    wb = Workbook()
    wb.remove(wb.active)
    fill = lambda c: PatternFill("solid", start_color=c)
    grp, head, yfill, g11f, summ = map(fill, ("B4C6E7", "D9E1F2", "FFF9E3", "E8EEF8", "FFF6D6"))
    cam = kind == "cambridge"
    hc = {"G9": 2, "G10": 8, "G11": 14 + cam}  # Hr column per grade; T1..Y follow it (Cambridge G11 subject column = 14)
    pc = {(g, t): hc[g] + 1 + j for g in GR for j, t in enumerate(TM)}
    tot, last, hcs = hc["G11"] + 5, len(smap) + 3, set(hc.values())
    R = {g: [l for l, _ in smap] for g in GR}  # subject labels per row, per grade
    if cam:
        R["G11"] = [b for b, _ in G11]  # Cambridge G11: own order, no gaps
    used = set()
 
    for name, subj in students:
        ws = wb.create_sheet(sheet_title(name, used))
        ws.cell(1, 1, name)
        ws.merge_cells(start_row=1, start_column=1, end_row=1, end_column=tot)
        for g in GR:
            ws.cell(2, hc[g], "Grade " + g[1:])
            ws.merge_cells(start_row=2, start_column=hc[g], end_row=2, end_column=hc[g] + 5)
            ws.cell(3, hc[g], "Hr")
        ws.cell(3, 1, "Subject")
        if cam:
            ws.cell(3, 14, "Subject")
        for (g, t), c in pc.items():
            ws.cell(3, c, t)
        for i, (l, _) in enumerate(smap, 4):
            ws.cell(i, 1, l)
        for i, (_, a) in enumerate(G11 if cam else [], 4):
            ws.cell(i, 14, a)
        for gi, g in enumerate(GR):
            ps = [(g, t) for t in TM]
            for i, l in enumerate(R[g], 4):
                v = subj[l]
                no = any(p in have for p in ps) and all(v.get(p) is None for p in ps)  # subject not taught in this grade
                ws.cell(i, hc[g], "–" if no else hr[l][gi])
                for p in ps:
                    x = v.get(p)
                    ws.cell(i, pc[p], x if x is not None else "–" if no or p in have else None)
 
        for r in range(1, last + 1):
            for c in range(1, tot + 1):
                yc, sub = c in (7, 13, tot), cam and c == 14
                fl = None
                if r == 2:
                    fl = head if c == 1 or sub else grp
                elif r == 3:
                    fl = head
                elif r > 3:
                    fl = g11f if sub else yfill if yc else None
                sty(ws.cell(r, c), r <= 3 or c == 1 or sub or yc or c in hcs, fl,
                    "left" if (c == 1 or sub) and r not in (2, 3) else "center", left=THICK if r >= 2 and c in (2, 8, 14) else THIN)
 
        ex = [avg_exprs(subj, smap, g, L(pc[g, "Y"]), L(hc[g]), 3 + len(R[g])) for g in GR]
        for r, lab, f in ((last + 2, "Average, simple", 0), (last + 3, "Average, weighted", 1)):
            ws.cell(r, 1, lab)
            ws.cell(r, 2, "=" + combo([e[f] for e in ex]))
            for c in range(1, tot + 1):
                sty(ws.cell(r, c), True, summ if c < 3 else None, "left" if c == 1 else "center",
                    "0.00" if c == 2 else None, THICK if c in (2, 8, 14) else THIN)
 
        ws.column_dimensions["A"].width = 30
        for c in range(2, tot + 1):
            ws.column_dimensions[L(c)].width = 28 if cam and c == 14 else 7.5
        ws.freeze_panes = "B4"
    wb.save(out)
 
 
def list_subjects(paths):
    for p in paths:
        print(f"{p}:")
        for name, grid in load_sheets(p):
            r = read_sheet(grid)
            if r is None:
                print(f"  sheet {name!r}: no '{FM}' columns")
                continue
            print(f"  sheet {name!r}: {len(r[0])} students, {len(r[2])} subjects")
            for c in r[2].values():
                print(f"      {c}")
 
 
def main():
    ap = argparse.ArgumentParser(allow_abbrev=False, description="Combine final marks from up to 15 quarter/year "
                                 "gradebooks (Grades 9-11) in a folder into one workbook with a sheet per student.")
    ap.add_argument("--input-dir", default="term_marks_input", help="folder with the gradebook .xls files (default: %(default)s)")
    k = ap.add_mutually_exclusive_group()
    k.add_argument("-cambridge", action="store_true", help="Cambridge class: 'Year ...' / '11-P' sheets, Cambridge subject list")
    k.add_argument("-russian", action="store_true", help="Russian-programme class: the other sheets, Russian subject list")
    ap.add_argument("--sheets", metavar="NAMES", help="comma-separated sheet names to read instead of the default")
    ap.add_argument("--list-subjects", nargs="+", metavar="FILE", help="print the sheets and subject names found in FILE(s)")
    ap.add_argument("-o", "--output", help="output path (default: final_marks_<cambridge|russian>.xlsx)")
    a = ap.parse_args()
    try:
        if a.list_subjects:
            return list_subjects(a.list_subjects)
        if not (a.cambridge or a.russian):
            ap.error("specify the class type: -cambridge or -russian")
        kind = "cambridge" if a.cambridge else "russian"
        smap, hr = CAMBRIDGE if a.cambridge else RUSSIAN
        out = a.output or f"final_marks_{kind}.xlsx"
        if a.sheets:
            want = {s.strip().casefold() for s in a.sheets.split(",")}
            keep = lambda n, g=None: n.strip().casefold() in want
        else:
            keep = sheet_filter(kind)
        files = discover(a.input_dir)
        if not any(files.values()):
            sys.exit(f"No matching gradebook files found in '{a.input_dir}'.")
        students, (never, unused), used = combine(files, smap, keep)
    except ValueError as e:
        sys.exit(f"ERROR: {e}")
 
    write_workbook(students, smap, hr, out, kind, set(used))
    for p in PERIODS:
        print(f"{p[0] + ' ' + p[1]:<7}: " + (f"{os.path.basename(files[p])}  (sheets: {', '.join(used[p])})"
              if files[p] else "missing (columns left empty)"))
    print(f"\n{len(students)} students -> {out}")
    if never:
        print("WARNING - no matching subject in any gradebook (rows left blank): " + ", ".join(never))
    if unused:
        print("NOTE - gradebook subjects not used by the mapping: " + ", ".join(unused))
 
 
if __name__ == "__main__":
    main()
 
