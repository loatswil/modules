Function New-Agent {
    Param(
            [Parameter(Mandatory=$true)]
            [string] $User
    )

try {
    $ADStatus = Get-ADUser -Identity $User -Properties *

}
catch {
    Throw "Can't find user in AD: $User"
}

$SAM = $ADStatus.samaccountname

try {
        $CSOnlineUser = Get-CsOnlineUser $SAM
}
catch {
        Throw "Can't find user in Teams: $SAM"
}

$Agent = New-Object psobject
$Agent | Add-Member Agent $CSOnlineUser.SipAddress
$Agent | Add-Member TeamsAssignedPhoneNumber $CSOnlineUser.LineUri
$Agent | Add-Member TeamsUPN  $ADStatus.UserPrincipalName
$Agent | Format-Table
}
