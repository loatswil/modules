Function Get-UserInfo {
    Param(
    [Parameter(Mandatory=$false)]
    [string] $FirstName,
    [Parameter(Mandatory=$false)]
    [string] $LastName,
    [Parameter(Mandatory=$false)]
    [switch] $Groups,
    [Parameter(Mandatory=$false)]
    [string] $OnlineID
    )

if($OnlineID){
    try {$ADUser = Get-ADUser $OnlineID -Properties *}
    catch {Throw "No such user: $OnlineID."}
    } else {
    try {$ADUser = Get-ADUser -Filter {surname -like $LastName -and givenname -like $FirstName} -Properties *}
    catch {Throw "No such user."}
    }

$Global:User = $ADUser

Write-Host ""
Write-Host "Get-ADUser -Identity $OnlineID -Properties *" -ForegroundColor Cyan

$ADUser | Format-List DisplayName, 
        Enabled, 
        LockedOut, 
        extensionAttribute*, 
        kuPersonEmailAliases, 
        EmailAddress, 
        samaccountname, 
        Password*, 
        UserPrincipalName, 
        msRTCSIP*, 
        ProxyAddresses, 
        TargetAddress,
        MemberOf,
        officePhone,
        TelephoneNumber

$UPN = $ADUser.UserPrincipalName
$SAM = $ADUser.samaccountname
$SIPLINE = $ADUser.'msRTCSIP-Line'

try {$CSOnlineUser = Get-CsOnlineUser $SAM}
catch {Throw "Can't find user in Teams: $SAM"}

Write-Host "Get-CsOnlineUser $SAM" -ForegroundColor Cyan

$CSOnlineUser | Format-List DisplayName,
        AccountEnabled,
        AccountType,
        Alias,
        Department,
        EnterpriseVoiceEnabled,
        HideFromAddressLists,
        HostingProvider,
        Identity,
        LastSyncTimeStamp,
        LineUri,
        OnPremEnterpriseVoiceEnabled,
        OnPremHostingProvider,
        OnPremSipAddress,
        ProxyAddresses,
        ShadowProxyAddresses,
        SipAddress,
        SipProxyAddress,
        UserDirSyncEnabled,
        UserPrincipalName,
        WhenChanged,
        LastProvisionTimeStamps,
        LastPublishTimeStamps

try {$MGUser = Get-MGUser -UserId $UPN}
catch {Throw "Can't find user in Entra: $UPN"}

Write-Host "Get-MgUser -UserId $UPN" -ForegroundColor Cyan

$MGUser | Format-List DisplayName,
        GivenName,
        Surname,
        Id,
        BusinessPhones,
        JobTitle,
        Mail,
        UserPrincipalName

if ($Groups){
        Write-Host "Group Membership:" -ForegroundColor Cyan
        Write-Host ""
        $ADStatus.MemberOf 
}

Write-Host ""
Write-Host "Anywhere365 Agent Info" -ForegroundColor Cyan
if (($ADStatus.MemberOf -like "*student*")) {
       Write-Host "*** Possible student ***" -ForegroundColor Yellow -BackgroundColor Red 
}

$Agent = New-Object psobject
$Agent | Add-Member Agent $CSOnlineUser.SipAddress
$Agent | Add-Member Order "1"
$Agent | Add-Member Formal  "Yes"
$Agent | Add-Member Hours  ""
$Agent | Add-Member CallerID  ""
$Agent | Add-Member SS  ""
$Agent | Add-Member SIPLINE $SIPLINE
$Agent | Add-Member Lineuri $CSOnlineUser.LineUri
$Agent | Add-Member UPN  $ADStatus.UserPrincipalName 
$Agent | Format-Table
Write-Host ""
Write-Host ""
}
