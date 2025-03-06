Function Get-LicenseInfo {
Param(
    [Parameter(Mandatory=$true)]
    [string] $OnlineID
    )

try {$ADUser = Get-ADUser -Identity $OnlineID -Properties *}
catch {Throw "Can't find user in AD: $OnlineID"}

$DN = $ADUser.DisplayName
$UPN = $ADUser.UserPrincipalName

try {$MGUser = Get-MgUserLicenseDetail -UserId $UPN}
catch {Throw "Can't find user license in Microsoft Graph: $UPN"}

$MGLicenses = $MGUser.SKUPartNumber

Write-Host ""
Write-Host " Licenses Assigned to $DN" -ForegroundColor Cyan

Foreach ($MGLicense in $MGLicenses)
    {
    Write-Host " $MGLicense"
    }
    Write-Host ""
}