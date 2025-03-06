Function Get-UserReport {
    Param(
    [Parameter(Mandatory=$false)]
    [string] $OnlineID
    )

    try {$ADUser = Get-ADUser $OnlineID -Properties * | select DisplayName, 
    Enabled, 
    LockedOut, 
    extensionAttribute*, 
    kuPersonEmailAliases, 
    EmailAddress, 
    samaccountname, 
    Password*, 
    UserPrincipalName, 
    msRTCSIP*, 
    TargetAddress,
    memberof,
    ProxyAddresses
    }
    catch {Throw "No such user: $OnlineID."}

$Global:User = $ADUser

$DN = $ADUser.DisplayName
$UPN = $ADUser.UserPrincipalName
$SAM = $ADUser.samaccountname
$SIPLINE = $ADUser.'msRTCSIP-Line'
$Filename = "c:\users\wal\Desktop\$SAM.txt"

try {$CSUser = Get-CsOnlineUser $SAM | select DisplayName,
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
    ShadowProxyAddresses,
    SipAddress,
    SipProxyAddress,
    UserDirSyncEnabled,
    UserPrincipalName,
    WhenChanged,
    LastProvisionTimeStamps,
    LastPublishTimeStamps,
    ProxyAddresses
    }
catch {Throw "Can't find user in Teams: $SAM"}

try {$MGUser = Get-MGUser -UserId $UPN | Select-Object DisplayName,
    GivenName,
    Surname,
    Id,
    BusinessPhones,
    JobTitle, 
    Mail, 
    UserPrincipalName
    }
catch {Throw "Can't find user in Entra: $UPN"}

try {$MGUserLic = Get-MgUserLicenseDetail -UserId $UPN}
catch {Throw "Can't find user license in Microsoft Graph: $UPN"}

Set-Content -Path $Filename -Value "Select Get-ADUser Properties for $SAM ($DN)" -Encoding Unicode
Add-Content -Path $Filename -Value "------------------------------------------------------"
$ADUser | Out-File -FilePath $Filename -Append
$ADUser.memberof | Out-File -FilePath $Filename -Append
Add-Content -Path $Filename -Value ""
$ADUser.proxyaddresses | Out-File -FilePath $Filename -Append
Add-Content -Path $Filename -Value ""
Add-Content -Path $Filename -Value "Select Get-CSOnlineUser properties for $SAM"
Add-Content -Path $Filename -Value "-------------------------------------"
$CSUser | Out-File -FilePath $Filename -Append
$CSUser.proxyaddresses | Out-File -FilePath $Filename -Append
Add-Content -Path $Filename -Value ""
Add-Content -Path $Filename -Value "Select Get-MGUser properties for $SAM"
Add-Content -Path $Filename -Value "-------------------------------------"
$MGUser | Out-File -FilePath $Filename -Append
Add-Content -Path $Filename -Value ""
Add-Content -Path $Filename -Value "Licenses assigned to $SAM"
Add-Content -Path $Filename -Value "-------------------------------------"
$MGUserLic.SKUPartNumber | Out-File -FilePath $Filename -Append
$filename

}