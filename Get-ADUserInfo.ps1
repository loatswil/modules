<#
.SYNOPSIS
    Get-ADUserInfo retrieves information about a user in Active Directory.
.DESCRIPTION
    This function will return information about a user in Active Directory.
.PARAMETER FirstName
    The first name of the user.
.PARAMETER LastName
    The last name of the user.
.PARAMETER Groups    
    Include the groups the user is a member of.
.PARAMETER onlineid
    The onlineid of the user.
.EXAMPLE
    Get-ADUserInfo -FirstName "John" -LastName "Doe"
    This will return information about the user "John Doe".
.EXAMPLE
    Get-ADUserInfo -onlineid "JohnDoe"
    This will return information about the user "John Doe".
.NOTES
#>
Function Get-ADUserInfo {
Param(
    [Parameter(Mandatory=$false)]
    [string] $FirstName,
    [Parameter(Mandatory=$false)]
    [string] $LastName,
    [Parameter(Mandatory=$false)]
    [switch] $Groups,
    [Parameter(Mandatory=$false)]
    [string] $onlineid
)

if($onlineid){
    $user = Get-ADUser $onlineid -Properties *
    $Global:user = $user
    } else {
    $user = Get-ADUser -Filter {surname -like $LastName -and givenname -like $FirstName} -Properties *
    $Global:user = $user
}
$user | fl ku*,
	   DisplayName,
	   GivenName,
	   SurName,
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
           TargetAddress
if ($Groups){
	$user.memberof
	}
}