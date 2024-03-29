<# 
  .DESCRIPTION
    Sets the Windows 10 Power plan to High performance.
#>

$powerPlan = Get-WmiObject -Namespace "root\cimv2\power" -Class Win32_PowerPlan | Where-Object { $_.ElementName -eq "High performance" }

if ($powerPlan -ne $null) {
    $powerPlan.SetActive()
    Write-Host "High perfomance power plan was set."
} else {
    Write-Host "ERROR: the power plan was not found."
}
