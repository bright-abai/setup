#!/usr/bin/env python3
"""
Read five gradebooks (quarters 1-4 and the year mark), exported from the school
system as SpreadsheetML (.xls that is really XML), take the "Итоговая оценка"
(final mark) of every subject, and write ONE Excel file with ONE SHEET PER
STUDENT:

    rows    = subjects
    columns = T1, T2, T3, T4, Y

The class type decides which sheets of each gradebook are read and which list of
subjects is used:
    -cambridge   sheets whose name starts with "Year"   (e.g. "Year 9")
    -russian     all other sheets                        (e.g. "9" and "9 2")
(override the sheet choice with --sheets, see below)

Usage:
    python extract_marks.py -cambridge T1.xls T2.xls T3.xls T4.xls YEAR.xls -o out.xlsx
    python extract_marks.py -russian   T1.xls T2.xls T3.xls T4.xls YEAR.xls -o out.xlsx

Use "-" in place of a file that doesn't exist yet (e.g. a quarter not finished).

Other options:
    --sheets "9,9 2"        read exactly these sheets (comma separated)
    --list-subjects FILE    print every sheet and subject code found in FILE

Use the ORIGINAL export from the school system. A file re-saved in LibreOffice /
Excel becomes a binary .xls and is not supported.

Requires: openpyxl   (pip install openpyxl)
"""
import argparse
import re
import sys
import xml.etree.ElementTree as ET

from openpyxl import Workbook
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter

NS = "{urn:schemas-microsoft-com:office:spreadsheet}"
FINAL_MARK_HEADER = "Итоговая оценка"
NAME_COLUMN = 2  # column (1-based) that holds the student name
PERIODS = ["T1", "T2", "T3", "T4", "Y"]  # order of the input files / output columns

# --------------------------------------------------------------------------- #
# SUBJECT MAPS
# Each entry: (label in the output file, [candidate subject names in gradebook]).
#   * The name is the text before the teacher's name in the gradebook's subject
#     title, e.g. "Русский язык (Дмитрий Викторович Рабзин)" -> Русский язык.
#     Case is ignored.
#   * With several names, the first one found in the file is used. (Older
#     exports used abbreviations such as MATH / Ря, newer ones use full names,
#     so both are listed.)
#   * None means "this subject is not in the gradebook" -> row stays blank.
#   * The names for one subject are only aliases of the SAME subject (old
#     abbreviation / new full name). A mark is never borrowed from a different
#     subject: if the subject is missing from the gradebook, or a student's
#     cell is empty, the output cell stays empty.
# Run with --list-subjects on a gradebook to see the real names.
# --------------------------------------------------------------------------- #
CAMBRIDGE_MAP = [
    ("Mathematics (0580)",         ["Mathematics", "MATH"]),
    ("Geometry (0580)",            ["Geometry"]),                  # only if the gradebook has a Geometry block
    ("Computer Science (0478)",    ["Computer Science", "CS"]),
    ("Biology (0610)",             ["Biology", "BIO"]),
    ("Chemistry (0620)",           ["Chemistry", "CHEM"]),
    ("Physics (0625)",             ["Physics", "PHYS"]),
    ("English (0511)",             ["English", "ENG"]),
    ("Russian Language",           ["Русский язык", "Ря"]),
    ("Russian Literature",         ["Русская литература", "Р-ЛИТ"]),
    ("Kyrgyz Language",            ["Kyrgyz", "Кыргыз тили", "Ky"]),
    ("Kyrgyz Literature",          ["Кыргыз адабияты", "К-АДА"]),
    ("Turkish",                    ["Turkish language", "Tr"]),
    ("Spanish",                    ["Spanish"]),               # grade 10 only
    ("History",                    ["History", "HIST"]),
    ("Global Perspectives (0457)", ["Global Perspective", "GP"]),
    ("Business Studies (0450)",    ["Business", "BUS"]),
    ("Geography (0460)",           ["Geography", "GEO"]),
    ("Physical Education",         ["Physical Education", "PE"]),
]

# Subject names below were checked against the original grade 9 and grade 10
# Russian-class gradebooks. Subjects missing from a grade just stay blank.
RUSSIAN_MAP = [
    ("Mathematics",                ["Mathematics"]),
    ("Geometry",                   ["Geometry"]),                  # only if the gradebook has a Geometry block
    ("Computer Science",           ["Computer Science"]),
    ("Biology",                    ["Biology"]),
    ("Chemistry",                  ["Chemistry"]),
    ("Physics",                    ["Physics"]),
    ("English",                    ["English"]),
    ("Russian Language",           ["Русский язык"]),
    ("Russian Literature",         ["Русская литература"]),
    ("Kyrgyz Language",            ["Кыргыз тили"]),
    ("Kyrgyz Literature",          ["Кыргыз адабияты"]),
    ("Spanish",                    ["Spanish", "Испанский язык"]),
    ("History",                    ["История"]),
    ("Geography",                  ["География"]),
    ("Economics",                  ["Economics"]),
    ("Business",                   ["Business"]),
    ("Human and society",          ["Человек и Общество"]),
    ("History of World Religions", ["История развития религий"]),
    ("Technology",                 ["Технология"]),
    ("Basic military training",    ["Допризывная подготовка", "Начальная военная подготовка", "НВП"]),
    ("Physical Education",         ["Физкультура"]),
]


# --------------------------------------------------------------------------- #
# Reading a SpreadsheetML file
# --------------------------------------------------------------------------- #
def read_grid(sheet):
    """Return the sheet as a list of {column_number: text} dicts (1-based cols).

    SpreadsheetML omits empty cells and uses MergeAcross for merged ranges, so
    the column counter must skip over merged cells to stay aligned.
    """
    grid = []
    for row in sheet.iter(NS + "Row"):
        cells, col = {}, 0
        for cell in row.findall(NS + "Cell"):
            index = cell.get(NS + "Index")
            col = int(index) if index else col + 1
            data = cell.find(NS + "Data")
            if data is not None and data.text is not None:
                cells[col] = data.text.strip()
            col += int(cell.get(NS + "MergeAcross") or 0)
        grid.append(cells)
    return grid


def load_sheets(path):
    """Return [(sheet_name, grid)] for every worksheet in the file."""
    with open(path, "rb") as f:
        head = f.read(8)
    if head.startswith(b"\xd0\xcf\x11\xe0"):
        raise ValueError(
            f"{path} is a binary Excel file (it was probably re-saved in Excel or "
            f"LibreOffice). Use the original XML export from the school system.")
    root = ET.parse(path).getroot()
    return [(ws.get(NS + "Name") or "Sheet", read_grid(ws))
            for ws in root.iter(NS + "Worksheet")]


def find_subject_blocks(grid, header_row_idx):
    """Find the row with subject titles (above the column-header row) and
    return {subject_name: (first_col, last_col)}."""
    pattern = re.compile(r"^(.+?)\s*\(.*\)\s*$")  # "Subject (Teacher name)"
    subject_row_idx = None
    for i in range(header_row_idx - 1, -1, -1):
        if sum(1 for v in grid[i].values() if pattern.match(v)) >= 3:
            subject_row_idx = i
            break
    if subject_row_idx is None:
        raise ValueError("Could not find the row with subject titles.")

    starts = sorted(
        (col, pattern.match(text).group(1).strip())
        for col, text in grid[subject_row_idx].items()
        if pattern.match(text)
    )
    last_col = max(max(r) for r in grid if r)
    blocks = {}
    for n, (start, code) in enumerate(starts):
        end = starts[n + 1][0] - 1 if n + 1 < len(starts) else last_col
        blocks[code] = (start, end)
    return blocks


def clean_name(raw):
    """', Авазбеков Деңиз| Avazbekov Deniz' -> 'Авазбеков Деңиз | Avazbekov Deniz'"""
    name = raw.strip().lstrip(",").strip()
    name = re.sub(r"\s*\|\s*", " | ", name)
    return re.sub(r"\s+", " ", name)


def name_key(name):
    """Key used to recognise the same student in different files."""
    return re.sub(r"[\s,|]+", " ", name).strip().casefold()


def code_key(code):
    """Subject names are compared ignoring case and surrounding spaces."""
    return code.strip().casefold()


def parse_mark(text):
    """'4' -> 4,  '4 (comment)' -> 4,  '' -> None.  Non-numeric text such as
    'Зачет' (pass) is kept as it is."""
    if text is None or not text.strip():
        return None
    m = re.match(r"^\s*(\d+(?:[.,]\d+)?)", text)
    if not m:
        return text.strip()
    num = float(m.group(1).replace(",", "."))
    return int(num) if num.is_integer() else num


def read_sheet(grid):
    """Read one gradebook sheet. Returns (students, marks, codes) or None if the
    sheet has no 'Итоговая оценка' columns.
    students = [display names in sheet order]
    marks    = {code_key: {display_name: mark}}
    codes    = {code_key: subject name as written in the file}"""
    header_idx = next(
        (i for i, r in enumerate(grid) if FINAL_MARK_HEADER in r.values()), None)
    if header_idx is None:
        return None
    blocks = find_subject_blocks(grid, header_idx)

    final_col, codes = {}, {}
    for code, (start, end) in blocks.items():
        cols = [c for c, v in grid[header_idx].items()
                if v == FINAL_MARK_HEADER and start <= c <= end]
        if cols:
            final_col[code] = cols[0]
            codes[code_key(code)] = code

    students, marks = [], {}
    for row in grid[header_idx + 1:]:
        if not row.get(NAME_COLUMN):
            continue
        name = clean_name(row[NAME_COLUMN])
        students.append(name)
        for code, col in final_col.items():
            marks.setdefault(code_key(code), {})[name] = parse_mark(row.get(col))
    return students, marks, codes


def default_sheet_filter(kind):
    """cambridge -> sheets named 'Year ...';  russian -> all the others."""
    is_year = lambda name: name.strip().casefold().startswith("year")
    return is_year if kind == "cambridge" else (lambda name: not is_year(name))


def extract(path, keep_sheet):
    """Read the sheets of `path` accepted by keep_sheet(name) and combine them.
    Returns (students, marks, codes, used_sheet_names)."""
    students, marks, codes, used = [], {}, {}, []
    for name, grid in load_sheets(path):
        if not keep_sheet(name):
            continue
        result = read_sheet(grid)
        if result is None:
            continue
        s, m, c = result
        students += s
        for code, per_student in m.items():
            marks.setdefault(code, {}).update(per_student)
        codes.update(c)
        used.append(name)
    if not students:
        available = ", ".join(repr(n) for n, _ in load_sheets(path))
        raise ValueError(
            f"No matching sheets with '{FINAL_MARK_HEADER}' columns in {path}. "
            f"Sheets in the file: {available}. Use --sheets to choose.")
    return students, marks, codes, used


# --------------------------------------------------------------------------- #
# Combining the five files
# --------------------------------------------------------------------------- #
def combine(files, subject_map, keep_sheet):
    """files: list of 5 paths (or None).  Returns
    (students, report, sheets_used) where
    students    = [(display name, {subject_label: {period: mark}})]
    report      = (labels_never_found, gradebook_subjects_not_used)
    sheets_used = {period: [sheet names]}"""
    display = {}   # name_key -> display name
    order = []     # name_keys in order of first appearance
    table = {}
    seen_codes = {}      # code_key -> name as written, over all files
    matched_labels = set()
    used_codes = set()
    sheets_used = {}

    for period, path in zip(PERIODS, files):
        if path is None:
            continue
        students, marks, codes, used = extract(path, keep_sheet)
        sheets_used[period] = used
        seen_codes.update(codes)
        for name in students:
            key = name_key(name)
            if key not in display:
                display[key] = name
                order.append(key)
                table[key] = {label: {} for label, _ in subject_map}
            for label, candidates in subject_map:
                if not candidates:
                    continue
                code = next((code_key(c) for c in candidates
                             if code_key(c) in marks), None)
                if code is None:
                    continue
                matched_labels.add(label)
                used_codes.add(code)
                table[key][label][period] = marks[code].get(name)

    never_found = [label for label, cands in subject_map
                   if cands and label not in matched_labels]
    unused = [seen_codes[c] for c in seen_codes if c not in used_codes]
    return [(display[k], table[k]) for k in order], (never_found, unused), sheets_used


# --------------------------------------------------------------------------- #
# Writing the output workbook
# --------------------------------------------------------------------------- #
def sheet_title(name, used):
    """Excel sheet name: <=31 chars, no []:*?/\\ , unique.
    Uses the part after '|' (Latin name) when there is one."""
    base = name.split("|")[-1].strip() or name
    base = re.sub(r"[\[\]:*?/\\]", "", base)[:31].strip() or "Student"
    title, n = base, 2
    while title.casefold() in used:
        suffix = f" ({n})"
        title = base[: 31 - len(suffix)] + suffix
        n += 1
    used.add(title.casefold())
    return title


def write_workbook(students, subject_map, out_path):
    wb = Workbook()
    wb.remove(wb.active)

    font_name = "Times New Roman"
    text_color = "3A3A3A"
    thin = Side(style="thin", color="CFCFCF")
    border = Border(left=thin, right=thin, top=thin, bottom=thin)
    head_fill = PatternFill("solid", start_color="D9E1F2")
    used = set()

    for name, subjects in students:
        ws = wb.create_sheet(sheet_title(name, used))

        # Row 1: student's full name; row 2: column headers; rows 3+: subjects
        ws.cell(1, 1, name)
        ws.merge_cells(start_row=1, start_column=1, end_row=1,
                       end_column=len(PERIODS) + 1)
        ws.cell(2, 1, "Subject")
        for j, period in enumerate(PERIODS, start=2):
            ws.cell(2, j, period)

        for i, (label, _) in enumerate(subject_map, start=3):
            ws.cell(i, 1, label)
            for j, period in enumerate(PERIODS, start=2):
                ws.cell(i, j, subjects[label].get(period))

        last_row = len(subject_map) + 2
        for r in range(1, last_row + 1):
            for c in range(1, len(PERIODS) + 2):
                cell = ws.cell(r, c)
                cell.font = Font(
                    name=font_name,
                    size=10,
                    bold=(r <= 2 or c == 1),
                    color=text_color,
                )
                if r >= 2:
                    cell.border = border
                if r == 2:
                    cell.fill = head_fill
                    cell.alignment = Alignment(horizontal="center", vertical="center")
                elif r > 2 and c > 1:
                    cell.alignment = Alignment(horizontal="center", vertical="center")
                else:
                    cell.alignment = Alignment(vertical="center")

        ws.column_dimensions["A"].width = 28
        for c in range(2, len(PERIODS) + 2):
            ws.column_dimensions[get_column_letter(c)].width = 9
        ws.freeze_panes = "B3"

    wb.save(out_path)


def list_subjects(paths):
    for path in paths:
        print(f"{path}:")
        for name, grid in load_sheets(path):
            result = read_sheet(grid)
            if result is None:
                print(f"  sheet {name!r}: no '{FINAL_MARK_HEADER}' columns")
                continue
            students, _, codes = result
            print(f"  sheet {name!r}: {len(students)} students, {len(codes)} subjects")
            for code in codes.values():
                print(f"      {code}")


def main():
    ap = argparse.ArgumentParser(
        allow_abbrev=False,
        description="Combine final marks from quarter and year gradebooks "
                    "into one workbook with a sheet per student.")
    ap.add_argument("files", nargs="+", metavar="FILE",
                    help="T1 T2 T3 T4 YEAR gradebooks, in this order "
                         "(use '-' to skip one)")
    kind = ap.add_mutually_exclusive_group()
    kind.add_argument("-cambridge", action="store_true",
                      help="Cambridge class: read 'Year ...' sheets, Cambridge subject list")
    kind.add_argument("-russian", action="store_true",
                      help="Russian-programme class: read the other sheets, Russian subject list")
    ap.add_argument("--sheets", metavar="NAMES",
                    help="comma-separated sheet names to read instead of the default")
    ap.add_argument("--list-subjects", action="store_true",
                    help="just print the sheets and subject names found in the given file(s)")
    ap.add_argument("-o", "--output", default="final_marks.xlsx")
    args = ap.parse_args()

    try:
        if args.list_subjects:
            list_subjects([f for f in args.files if f != "-"])
            return

        if not (args.cambridge or args.russian):
            ap.error("specify the class type: -cambridge or -russian")
        if len(args.files) != 5:
            ap.error(f"expected 5 files (T1 T2 T3 T4 YEAR), got {len(args.files)}")

        kind_name = "cambridge" if args.cambridge else "russian"
        subject_map = CAMBRIDGE_MAP if args.cambridge else RUSSIAN_MAP
        if args.sheets:
            wanted = {s.strip().casefold() for s in args.sheets.split(",")}
            keep_sheet = lambda name: name.strip().casefold() in wanted
        else:
            keep_sheet = default_sheet_filter(kind_name)

        files = [None if f == "-" else f for f in args.files]
        if all(f is None for f in files):
            sys.exit("No input files given.")

        students, (never_found, unused), sheets_used = combine(
            files, subject_map, keep_sheet)
    except ValueError as err:
        sys.exit(f"ERROR: {err}")

    write_workbook(students, subject_map, args.output)

    for period, f in zip(PERIODS, files):
        if f is None:
            print(f"{period}: skipped")
        else:
            print(f"{period}: {f}  (sheets: {', '.join(sheets_used[period])})")
    print(f"{len(students)} students -> {args.output}")
    if never_found:
        print("WARNING - no matching subject in any gradebook (rows left blank): "
              + ", ".join(never_found))
    if unused:
        print("NOTE - gradebook subjects not used by the mapping: "
              + ", ".join(unused))


if __name__ == "__main__":
    main()
