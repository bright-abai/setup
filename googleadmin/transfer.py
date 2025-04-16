# translate from edupage list of students by statistics in grades tab

from transliterate import translit
import argparse

parser = argparse.ArgumentParser(description="Specify name of input and output files")
parser.add_argument("input", help="Path to the edupage list of students")
parser.add_argument("output", help="Path to the output csv file of students for google admin")
parser.add_argument("orgunit", help="Organization unit to put into, grade 1 in 2024 2025 is 2024")
args = parser.parse_args()

with open(args.input, 'r', encoding='utf8') as infile, open(args.output, 'w', encoding='utf8') as outfile:
    header_line = "First Name [Required],Last Name [Required],Email Address [Required],Password [Required],Org Unit Path [Required]\n"
    outfile.write(header_line)
    for line in infile:
        last_name, first_name = line.strip().split(',')
        last_name = translit(last_name, "ru", reversed = True)
        last_name = last_name.replace('j', 'i').replace("'", "")
        first_name = translit(first_name, "ru", reversed = True)
        first_name = first_name.replace('j', 'i').replace("'", "")
        email = f"{last_name.lower()}_{first_name.lower()}@bright.kg"
        username = f"{first_name.lower()}_bright"
        output_line = f"{first_name}, {last_name}, {email}, {username}, /Students/{args.orgunit}\n"
        outfile.write(output_line)

print("Done! Output written to", args.output)