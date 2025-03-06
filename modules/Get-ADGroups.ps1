<#
.SYNOPSIS
    Get-ADGroups.ps1 - Get AD Groups for a user
.DESCRIPTION
    This function will return the AD Groups for a user.
.PARAMETER User
    The user to get the AD Groups for.
.EXAMPLE
    Get-ADGroups -User "JohnDoe"
    This will return the AD Groups for the user "JohnDoe".
.NOTES
    Name: Get-ADGroups
#>
Function Get-ADGroups {
    Param(
            [Parameter(Mandatory=$true)]
            [string] $User
    )

try{ $ADUser = Get-ADUser -Identity $User -Properties * }
catch { throw }
$SAM = $ADUser.samaccountname
$DN = $ADUser.DisplayName
$Groups = $ADUser.memberof

$Obj = New-Object psobject
$Obj | Add-Member samaccountname $ADUser.samaccountname
$Obj | Add-Member DisplayName $ADUser.DisplayName
$Obj | Format-List

if (($ADUser.MemberOf -like "*student*")) {
        $StudGroups = ($ADUser.MemberOf -like "*student*")
        Write-Host "*** Possible student ***" -ForegroundColor Yellow -BackgroundColor Red
        $StudGroups
	Write-Host ""
}
if (($ADUser.MemberOf -like "*-lic*")) {
        $LicGroups = ($ADUser.MemberOf -like "*-lic*")
	Write-Host ""
        Write-Host "*** License Group(s) ***" -ForegroundColor Yellow -BackgroundColor Red
        Write-Host "*** License Group(s) ***"
        $LicGroups
	Write-Host ""
}

$ADUser.memberof
Write-Host ""
}
