# Created 02.06.2022
# Usage: change "container.zip" to the desired archive name.
# Move the .py file into the directory and run it 

import zipfile
import os

def main():
    # Create a ZipFile
    zip_file = zipfile.ZipFile("container.zip", "w")

    # List to store the names of the files
    files = []

    # Iterate through all files in the current directory
    for filename in os.listdir():
        # Check if the file has the wanted extension e.g '.txt'
        if filename.endswith(".txt"):
            # Add the file to the list "files"
            files.append(filename)
            # Add the file to the zip archive
            zip_file.write(filename)

    # Close the zip file
    zip_file.close()

    # Iterate through the list of files
    for filename in files:
        # Delete the original file
        os.remove(filename)

# main
if __name__ == "__main__":
    main()
