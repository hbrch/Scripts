# enter user details
$firstName = Read-Host -Prompt "Enter first name"
$lastName = Read-Host -Prompt "Enter last name"
$username = Read-Host -Prompt "Enter username"
$password = Read-Host -Prompt "Enter password" -AsSecureString

# User Principal name (UPN)
# "domain.com" should be changed to the ad domain
$upn = "$username@domain.com"  

# Distinguished Name (DN)
# "domain.com" should be changed to the ad domain
$ou = "OU=Users,DC=domain,DC=com"
$dn = "CN=$firstName $lastName,$ou"

# creates the new user with the prompted vars
New-ADUser -SamAccountName $username -UserPrincipalName $upn -Name "$firstName $lastName" -GivenName $firstName -Surname $lastName -EmailAddress $email -AccountPassword $password -Enabled $true -PassThru
