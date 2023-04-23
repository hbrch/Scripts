# Created 23.04.2023
# Requirements: PyPDF2
# Usage: create a .txt file and write in it the PDF File Names you want to use, all of them need to be on an seperate line
import PyPDF2
import os

# Function to check if file exists
def file_existence_checker(file_path):
    if os.path.isfile(file_path):
        return True
    else:
        print("Wrong path.")
        return False

# Get input file containing paths to PDF files
input_file_path = input("Input file: ")

# Check if input file exists
if not file_existence_checker(input_file_path):
    exit()

# Open input file and read file paths of PDFs
with open(input_file_path, 'r') as input_file:
    pdf_file_paths = input_file.read().splitlines()

# Iterate through each PDF file and extract text to output file
for pdf_file_path in pdf_file_paths:
    # Check if PDF file exists
    if not file_existence_checker(pdf_file_path):
        continue
    
    # Create output file path
    output_file_path = os.path.splitext(pdf_file_path)[0] + ".txt"
    
    # Open PDF file and extract text to output file
    with open(pdf_file_path, 'rb') as pdf_file, open(output_file_path, 'w') as output_file:
        pdf_reader = PyPDF2.PdfFileReader(pdf_file)
        num_pages = pdf_reader.getNumPages()
        
        for page_num in range(num_pages):
            page = pdf_reader.getPage(page_num)
            text = page.extractText()
            output_file.write(text)
    
    print("PDF File {pdf_file_path} extracted to {output_file_path}")

