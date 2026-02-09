<#
.SYNOPSIS
    This PowerShell script enables Windows 11 Kernel (Direct Memory Access) DMA Protection.
.NOTES
    Author          : Symone-Marie Priester
    LinkedIn        : linkedin.com/in/symone-mariepriester
    GitHub          : github.com/Symone-Marie
    Date Created    : 2025-02-09
    Last Modified   : 2025-02-09
    Version         : Microsoft Windows [Version 10.0.26200.7623]
    CVEs            : N/A
    Vuln-ID         : V-253426
    STIG-ID         : WN11-EP-000310
.TESTED ON
    Date(s) Tested  : 2025-02-09
    Tested By       : Symone-Marie Priester
    Systems Tested  : Windows 11 Pro OS
    PowerShell Ver. : 5.1
    Manual Test     : Yes, remediated via Local Group Policy Editor (gpedit.msc) with screenshot documentation
.USAGE
    Enables Kernel DMA Protection to prevent DMA attacks from external devices.
    Example syntax:
    PS C:\> .\remediation_WN11-EP-000310.ps1 
#>

# Define registry path and values
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Kernel DMA Protection"
$regName = "DeviceEnumerationPolicy"
$regValue = 0  # 0 = Block All

Write-Host "Configuring Kernel DMA Protection - Blocking external devices incompatible with Kernel DMA Protection..."

# Create registry path if it doesn't exist
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
    Write-Host "Created registry path: $regPath"
}

# Set the registry value
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord
Write-Host "Set $regName to $regValue (Block All)"

# Verify the change
Write-Host "`nVerifying configuration..."
$currentValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue

if ($currentValue.$regName -eq $regValue) {
    Write-Host "SUCCESS: WN11-EP-000310 remediated - Kernel DMA Protection is enabled with 'Block All' policy" -ForegroundColor Green
    Write-Host "`nCurrent registry value:"
    Get-ItemProperty -Path $regPath -Name $regName | Select-Object DeviceEnumerationPolicy
} else {
    Write-Host "ERROR: Failed to set registry value" -ForegroundColor Red
}
