Function Get-RandomADUser {
    Param(
        [Parameter(Mandatory=$false)]
        [switch] $Full
    )

    $RanLetter = (97..122) | Get-Random -Count 1 | ForEach-Object {[char]$_}
    $RanNumber = (48..57) | Get-Random -Count 1 | ForEach-Object {[char]$_}
    $RanString = $RanLetter + $RanNumber + "*"
    $User = Get-ADUser -Filter 'UserPrincipalName -like $RanString' | Get-Random
    $FullUser = Get-ADUser $User.SamAccountName -Properties *

    if ($Full) {$FullUser}
    Else {$FullUser | select SamAccountName, GivenName, SurName}

}