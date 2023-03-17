#Usage: creates subdirectories and automatically moves all files into their respective directories
# e.g. "DATA.xlsx" -> creates folder "EXCEL" -> moves file "DATA.xlsx" into "EXCEL"

import os
from pathlib import Path

#List for all wanted subdirectories and the file types, that should be moved into them
directories = {
    "PDF": ['.pdf'],
    "MARKDOWN": ['.md'],
    "WORD": ['.docx'],
    "EXCEL": ['.xlsx'],
    "BILDER": ['.png']
}

#Function to pick the Directory
def pickDir(value):
    for category, suffixes in directories.items():
        for suffix in suffixes:
            if suffix == value:
                return category
    return category

#Function to organize the Directory
def orgDir():
    for item in os.scandir():
        if item.is_dir():
            continue
        filePath = Path(item)
        filetype = filePath.suffix.lower()
        directory = pickDir(filetype)
        directoryPath = Path(directory)
        if directoryPath.is_dir() != True:
            directoryPath.mkdir()
        filePath.rename(directoryPath.joinpath(filePath))
        print ("moved file:", filePath, "to:", directoryPath)
        
#Running the Script
orgDir()



