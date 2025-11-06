# PDF Class Report Splitter

## Overview
This script automatically splits class-wide PDF reports into individual student PDF files. It processes PDF documents that contain multiple student reports and organizes them into separate folders by class.

## Functionality

### Input Requirements
- PDF files must be placed in an `input/` directory
- Each PDF should contain reports for multiple students from the same class
- Student reports are identified by a page starting with "Предмет" (Subject in Russian)
- Student names are expected in the format: `[FirstName] [LastName]` following the "Предмет" marker

### Processing Logic
1. **Iterates through PDF files** in the `input/` directory
2. **Creates class folders** named after each PDF file (without extension)
3. **Reads each PDF page** and identifies student boundaries
4. **Extracts student names** from pages (format: FirstName_LastName)
5. **Splits the PDF** into individual files, one per student
6. **Saves student PDFs** in their respective class folders

### Output Structure
```
project_root/
├── input/
│   ├── ClassA.pdf
│   └── ClassB.pdf
├── ClassA/
│   ├── Ivan_Petrov.pdf
│   ├── Maria_Ivanova.pdf
│   └── ...
└── ClassB/
    ├── Alexey_Sidorov.pdf
    └── ...
```

## Page Detection Logic

The script identifies student report boundaries by:
- **New student report**: Page starts with "Предмет" (subject header)
- **Continuation**: Pages without "Предмет" belong to the previous student
- **End of report**: When a new "Предмет" is found or PDF ends

## Dependencies
- `pypdf`: PDF reading and writing library
- `os`: File system operations

## Usage
```bash
python individual_reports.py
```

## Limitations & Known Issues
1. Assumes consistent PDF structure with "Предмет" markers
2. Skips already-processed classes (folders that exist)
3. Overwrites student PDFs if run multiple times on processed classes
4. Limited error handling for malformed PDFs
5. Student name extraction assumes specific text layout

## Potential Improvements
- Add error handling for corrupted PDFs
- Validate student name extraction
- Add command-line arguments for input/output directories
- Include logging instead of print statements
- Handle edge cases (empty pages, missing names)
