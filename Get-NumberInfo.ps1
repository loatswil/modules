Function Get-NumberInfo {
    Param(
    [Parameter(Mandatory=$true)]
    [string] $Number
    )

Try {$Status = Get-ADUser -Filter 'msRTCSIP-Line -like $Number' -Properties *}
Catch {Throw "No User found with number: $Number"}

Write-Host ""
Write-Host "Get-ADUser -Filter 'msRTCSIP-Line -like $Number'" -ForegroundColor Cyan -NoNewline

$Status | Format-List msRTCSIP-DeploymentLocator,
        DisplayName,
    	HostingProvider,
        msRTCSIP-Line,
        SID,
        samaccountname,
        UserPrincipalName,
        msRTCSIP-PrimaryUserAddress,
        DistinguishedName,
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
        msDS-ExternalDirectoryObjectId
}

