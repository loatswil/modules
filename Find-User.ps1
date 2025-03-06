<#
    .SYNOPSIS
        Find-User is a PowerShell module that searches for a user in Active Directory.  
    .DESCRIPTION
        This module will search for a user in Active Directory by first name and last name. 
        It will return the user's display name and SAM account name.
    .PARAMETER FirstName
        The first name of the user to search for.
    .PARAMETER LastName
        The last name of the user to search for.
    .EXAMPLE
        Find-User -FirstName "John" -LastName "Doe"
        This will return the display name and SAM account name of the user with the first name "John" and the last name "Doe".
    .NOTES
        Name: Find-User
        If no user is supplied, the function will take the given input, split it into first and last names, and search for the user in Active Directory 
        using a filter that matches the first and last names.

#>

Function Find-User {
    Param(
    [Parameter(Mandatory=$false)]
    [string] $FirstName,
    [Parameter(Mandatory=$false)]
    [string] $LastName
    )
    if ($FirstName -eq $null -and $LastName -eq $null) {
        $Name = Read-Host "Enter the user's first and last name"
        $Name = $Name -split " "
        $FirstName = $Name[0]
        $LastName = $Name[1]
    }
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