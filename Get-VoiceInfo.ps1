Function Get-VoiceInfo {
    Param(
    [Parameter(Mandatory=$true)]
    [string] $OnlineID,
    [parameter(Mandatory=$False)][switch] $Details
    )

try {$ADUser = Get-ADUser -Identity $OnlineID -Properties *}
catch {Throw "Can't find user in AD: $OnlineID"}

$ADDN = $ADUser.DisplayName
$ADUPN = $ADUser.UserPrincipalName
$UPN = $ADUser.UserPrincipalName
$SAM = $ADUser.samaccountname
$SIPLINE = $ADUser.'msRTCSIP-Line'

try {$CSUser = Get-CsOnlineUser $SAM}
catch {Throw "Can't find user in Teams: $SAM"}

Write-Host ""
if ($ADUser.Enabled){Write-Host "AD Enabled" -ForegroundColor DarkGreen}
else {Write-Host "AD Disabled" -ForegroundColor Red}
if ($ADUser.LockedOut){Write-Host "AD Account Locked" -ForegroundColor Red}
else {Write-Host "AD Account Not Locked" -ForegroundColor DarkGreen}

if ($CSUser.AccountEnabled){Write-Host "Teams Enabled" -ForegroundColor DarkGreen}
else {Write-Host "Teams Disabled" -ForegroundColor Red}
if ($CSUser.EnterpriseVoiceEnabled){Write-Host "Enterprise Voice Enabled" -ForegroundColor DarkGreen}
else {Write-Host "Enterprise Voice Disabled" -ForegroundColor Red}

$CSUser | Format-List LineURI,
        HostingProvider,
        SIPAddress,
        SIPProxyAddress

Function CSUser {
    try {$CSUserCallingSettings = Get-CsUserCallingSettings -Identity $SAM}
    catch {Write-Host "No CSCallSettings."}
    Write-Host "Get-CsUserCallingSettings -Identity $SAM" -ForegroundColor Cyan -NoNewline
    $CSUserCallingSettings | Format-List
    }

Function CSOnlineVoicemail {
    try {$VoicemailSettings = Get-CsOnlineVoicemailUserSettings -Identity $SAM}
    catch {Write-Host "No CsOnlineVoicemailUserSettings."}
    Write-Host "Get-CsOnlineVoicemailUserSettings -Identity $SAM" -ForegroundColor Cyan -NoNewline
    $Voicemailsettings | Format-List
    }

Function Agent {
    $Agent = New-Object psobject
    $Agent | Add-Member Agent $CSUser.SipAddress
    $Agent | Add-Member Order "1"
    $Agent | Add-Member Formal  "Yes"
    $Agent | Add-Member Hours  ""
    $Agent | Add-Member CallerID  ""
    $Agent | Add-Member SS  ""
    $Agent | Add-Member Lineuri $CSUser.LineUri
    $Agent | Add-Member UPN  $ADUser.UserPrincipalName
    $Agent | Format-Table
    }

If ($Details) {
    (CSUser)
    (CSOnlineVoicemail)
    (Agent)
    }
}