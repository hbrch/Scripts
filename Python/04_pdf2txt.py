# Created 23.04.2023
# Requirements: PyPDF2
# Usage: Enter the name of the PDF file first, after that the name of the .txt file you want to create
import PyPDF2

# Ask for input and output file names
input_file = input("Enter the name of the input PDF file: ")
output_file = input("Enter the name of the output text file: ")

# Open the PDF file and create a PDF reader object
with open(input_file, 'rb') as pdf_file:
    pdf_reader = PyPDF2.PdfFileReader(pdf_file)
    num_pages = pdf_reader.getNumPages()
    
    # Iterate through each page of the PDF and extract text
    with open(output_file, 'w') as text_file:
        for page_num in range(num_pages):
            page = pdf_reader.getPage(page_num)
            text = page.extractText()
            text_file.write(text)
            
# Print a message indicating success
print(f"Text extracted from '{input_file}' and saved to '{output_file}'")
