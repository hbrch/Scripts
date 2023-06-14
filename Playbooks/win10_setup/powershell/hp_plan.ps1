# hp_plan.ps1
$powerPlan = Get-WmiObject -Namespace "root\cimv2\power" -Class Win32_PowerPlan | Where-Object { $_.ElementName -eq "High performance" }

if ($powerPlan -ne $null) {
    $powerPlan.SetActive()
    Write-Host "Power plan set to High performance"
} else {
    Write-Host "High performance power plan not found"
}
