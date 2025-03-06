<#
.SYNOPSIS
    Get-CsUserInfo retrieves information about a user in Skype for Business Online.
.DESCRIPTION
    This function will return information about a user in Skype for Business Online.
.PARAMETER OnlineID
    The onlineid of the user.
.EXAMPLE
    Get-CSUserInfo -OnlineID "JohnDoe"
    This will return information about the user "John Doe".
.NOTES
#>

Function Get-CSUserInfo {
    Param(
    [Parameter(Mandatory=$False)]
    [string] $OnlineID
    )

try {$CSUser = Get-CSOnlineUser -Identity $OnlineID}
catch {Write-Host "No such User." -ForegroundColor DarkRed}

$Global:user = $CSUser

Write-Host ""
Write-Host "Get-CSOnlineUser -Identity $OnlineID" -ForegroundColor Cyan -NoNewline
$CSUser | fl DisplayName,
    GivenName,
	SurName,
    AccountEnabled,
	EnterpriseVoiceEnabled,
	LineURI,
	SipAddress,
    UserPrincipalName,
	Identity,
	alias,
    ShadowProxyAddresses
}
