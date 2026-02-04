# python -m venv venv
# venv/bin/pip install pypdf
# venv/bin/python file_name.py

from pypdf import PdfReader, PdfWriter
import os

classes = os.listdir("input")
for class_file in classes:
    print(class_file)
    class_name = class_file.split('.')[0]
    if os.path.exists(class_name):
        continue
    print(class_name)
    os.mkdir(class_name)
    reader = PdfReader("input/%s" % class_file)

    student_pages = []
    student_name = ""
    completed_page = True

    number_of_pages = len(reader.pages)
    for page_index in range(number_of_pages):
        text = reader.pages[page_index].extract_text().split()
        if not completed_page and text[0] != "Предмет":
            writer = PdfWriter()
            print("%s %s" % (student_name, student_pages))
            for i in student_pages:
                writer.add_page(reader.pages[i])
            student_pages.clear()
            writer.write("%s/%s.pdf" % (class_name, student_name))
            writer.close()
        student_pages.append(page_index)
        if (text[0] == "Предмет"):
            writer = PdfWriter()
            print("%s %s" % (student_name, student_pages))
            for i in student_pages:
                writer.add_page(reader.pages[i])
            student_pages.clear()
            writer.write("%s/%s.pdf" % (class_name, student_name))
            writer.close()
            completed_page = True
        else:
            student_name = text[1] + "_" + text[0]
            completed_page = False
