import os
import pandas as pd
from PIL import Image, ImageDraw, ImageFont


def create_mobile_student_cards(excel_path):
    output_dir = "student_cards_mobile"
    os.makedirs(output_dir, exist_ok=True)

    # Load the student data from Excel
    df = pd.read_excel(excel_path)

    # Square dimension settings optimized for mobile screens
    img_width = 1000
    img_height = 1000
    bg_color = (255, 255, 255)  # White
    text_color = (0, 0, 0)  # Black
    accent_color = (70, 80, 95)  # Dark gray/blue accent for structural lines

    # Define JetBrains Mono font filenames
    font_path_reg = "JetBrainsMono-Regular.ttf"
    font_path_bold = "JetBrainsMono-Bold.ttf"

    try:
        font_title = ImageFont.truetype(font_path_bold, 42)
        font_body = ImageFont.truetype(font_path_reg, 32)
        font_label = ImageFont.truetype(font_path_bold, 30)
        font_value = ImageFont.truetype(font_path_reg, 38)
    except IOError:
        print(
            "⚠️ JetBrainsMono font files not found. Falling back to default font."
        )
        font_title = font_body = font_label = font_value = (
            ImageFont.load_default()
        )

    for index, row in df.iterrows():
        # Safeguard and clean string conversions from Excel row columns
        name = str(row.iloc[0]).strip()
        login = str(row.iloc[1]).strip()
        password = str(row.iloc[2]).strip()

        if pd.isna(row.iloc[0]) or name == "":
            continue

        # Create a blank square layout template
        img = Image.new("RGB", (img_width, img_height), color=bg_color)
        draw = ImageDraw.Draw(img)

        # 1. Main Greeting Header Text
        draw.text((60, 70), "Уважаемый ученик/родитель!", font=font_title, fill=text_color)

        # 2. Body Explanatory Text Paragraph (Formatted with mobile line breaks)
        instructions = (
            "Международная Школа «Брайт»\n"
            "создала для вас аккаунт в системе\n"
            "Edupage. Для входа скачайте\n"
            "мобильное приложение Edupage."
        )
        draw.text((60, 160), instructions, font=font_body, fill=text_color, spacing=14)

        # 3. Horizontal Separator Line dividing instructions from data fields
        draw.line([(60, 390), (img_width - 60, 390)], fill=accent_color, width=3)

        # 4. Clean Stacked Data Field Matrix Blocks (Optimized for rapid thumb reading)
        # Student Name Block
        draw.text((60, 440), "Имя ученика:", font=font_label, fill=accent_color)
        draw.text((60, 485), name, font=font_value, fill=text_color)

        # Login Field Block
        draw.text((60, 580), "Логин:", font=font_label, fill=accent_color)
        draw.text((60, 625), login, font=font_value, fill=text_color)

        # Password Field Block
        draw.text((60, 720), "Пароль:", font=font_label, fill=accent_color)
        draw.text((60, 765), password, font=font_value, fill=text_color)

        # 5. Outer Frame Boundary Edge Outline
        draw.rectangle(
            [(25, 25), (img_width - 25, img_height - 25)],
            outline=(220, 225, 230),
            width=6,
        )

        # Format and save output file safely
        safe_name = "".join(
            c for c in name if c.isalnum() or c in (" ", "_", "-")
        ).rstrip()
        filename = f"{output_dir}/{safe_name}.png"
        img.save(filename, "PNG")

    print(
        f"🎉 Success! Generated mobile-friendly square cards inside the '{output_dir}/' folder."
    )


# Execute the script
create_mobile_student_cards("student_logins.xlsx")
