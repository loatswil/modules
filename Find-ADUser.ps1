<#
.SYNOPSIS
    Find-ADUser is a function that searches for a user in Active Directory by first name and last name. 
.DESCRIPTION
    This function will search for a user in Active Directory by first name and last name. 
    It will return the user's display name and SAM account name.
.PARAMETER FirstName
    The first name of the user to search for.
.PARAMETER LastName
    The last name of the user to search for.
.EXAMPLE
    Find-ADUser -FirstName "John" -LastName "Doe"
    This will return the display name and SAM account name of the user with the first name "John" and the last name "Doe".
.NOTES
    Name: Find-ADUser
#>
Function Find-ADUser {
    Param(
    [Parameter(Mandatory=$false)]
    [string] $FirstName,
    [Parameter(Mandatory=$false)]
    [string] $LastName
    )
    try {$ADUser = Get-ADUser -Filter {surname -like $LastName -and givenname -like $FirstName} -Properties samaccountname, Displayname}
    catch {Throw "No such user."}
    Foreach ($User in $ADUser){
    $Obj = New-Object psobject
    $Obj | Add-Member Name $User.DisplayName
    $Obj | Add-Member SAM $User.samaccountname
    $Obj 
    $Global:User = $ADUser
    }
}