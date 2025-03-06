<#
.SYNOPSIS
    Get-CsPhoneNumberAssignment and Get-CsOnlineApplicationInstance or Get-CsOnlineUser for a given phone number.
.DESCRIPTION
    This function will return information about a phone number assignment in Skype for Business Online.
.PARAMETER TelephoneNumber
    The phone number to look up.
.EXAMPLE
    Get-CSNumberInfo -TelephoneNumber "+1234567890"
    This will return information about the phone number "+1234567890".
.NOTES
#>
Function Get-CSNumberInfo {
    Param(
    [Parameter(Mandatory=$True)]
    [string] $TelephoneNumber
    )

try {$Status = Get-CsPhoneNumberAssignment -TelephoneNumber $TelephoneNumber}
catch {Write-Host "No such number assignment." -ForegroundColor DarkRed}

try {$Object = Get-CsOnlineApplicationInstance | Where-Object {$_.ObjectID -like $Status.AssignedPstnTargetId}}
catch {Write-Host "No such object." -ForegroundColor DarkRed}

if (!$Object) {$Object = Get-CsOnlineUser -Identity $Status.AssignedPstnTargetId}

Write-Host ""
Write-Host "Phone Number Assignment for $TelephoneNumber" -ForegroundColor Cyan -NoNewline

$Object | Format-List DisplayName,
            LineURI,
            OnPremSipAddress,
            HostingProvider,
            SipProxyAddress,
            UserPrincipalName

}
