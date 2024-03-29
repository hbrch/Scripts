# prompt for the user that will be removed
$user = Read-Host -Prompt "Enter unsername"

# if user exists
if (Get-ADUser -Filter {SamAccountName -eq $user}) {
    # remove user from all groups
    Get-ADUser $user | ForEach-Object {
        Get-ADPrincipalGroupMembership $_ | Remove-ADGroupMember -Members $_ -Confirm:$false
    }
    
    # remove user
    Remove-ADUser -Identity $user -Confirm:$false
    Write-Host "User '$user' has been deleted successfully." -ForegroundColor Green
    # specified user was not found
} else {
    Write-Host "User '$user' not found." -ForegroundColor Red
}
