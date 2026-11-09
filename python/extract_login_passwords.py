import re
import sys
import pandas as pd
from pypdf import PdfReader


def extract_edupage_logins(pdf_path, excel_path="student_logins.xlsx"):
    reader = PdfReader(pdf_path)
    full_text = ""

    # Combine all pages into a single string
    for page in reader.pages:
        text = page.extract_text()
        if text:
            full_text += text + "\n"

    # Split text into individual student blocks using the dotted line delimiter
    # This handles the long line of dots separating each student section
    student_blocks = re.split(r"\.{10,}", full_text)

    parsed_data = []

    for block in student_blocks:
        block = block.strip()
        if not block:
            continue

        # Look for the credentials block to ensure it's a valid student section
        if "Имя пользователя:" in block and "Пароль:" in block:
            lines = [line.strip() for line in block.split("\n") if line.strip()]

            # The very first line of a block contains the student name and class
            # e.g., "Айдин Абакиров 1/12-А"
            name_line = lines[0]
            # Clean up class codes at the end (e.g., matching "1/12-A" or digits)
            student_name = re.sub(r"\s+\d+/\d+-[А-Яа-яA-Za-z]+$", "", name_line)
            student_name = student_name.split('|', 1)[0]

            # Extract Username and Password using regex
            username_match = re.search(r"Имя пользователя:\s*(\S+)", block)
            password_match = re.search(r"Пароль:\s*(\S+)", block)


            username = username_match.group(1) if username_match else ""
            password = password_match.group(1) if password_match else ""

            parsed_data.append(
                {
                    "Student Name": student_name,
                    "Login Name": username,
                    "Password": password,
                }
            )

    # Convert to a DataFrame and save to Excel
    df = pd.DataFrame(parsed_data)
    df.to_excel(excel_path, index=False)
    print(f"Successfully exported {len(df)} students to '{excel_path}'")


# --- Execute the script ---
# Replace 'passwords.pdf' with your actual PDF filename
extract_edupage_logins(sys.argv[1])
