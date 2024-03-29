#
    .DESCRIPTION
        Deletes the content of a folder.
        
    .PARAMETER folderPath
        The desired folder path.
    #>

# Define the folder path
$folderPath = "folderpath"

# Check if the folder exists
if (Test-Path $folderPath) {
    try {
        # Get all items within the folder
        $items = Get-ChildItem -Path $folderPath -Force

        # foreach item
        foreach ($item in $items) {
            # if item is a directory
            if ($item.PSIsContainer) {
                # delete the directory and its contents
                Remove-Item -Path $item.FullName -Recurse -Force
            } else {
                # delete file
                Remove-Item -Path $item.FullName -Force
            }
        }

        Write-Output "All items in $folderPath have been deleted."
    }
    # catch if a error occurs
    catch {
        Write-Error "Error occurred while deleting items: $_"
    }
}
# else if the specified folder in $folderPath does not exist
else {
    Write-Error "Folder $folderPath does not exist."
}
