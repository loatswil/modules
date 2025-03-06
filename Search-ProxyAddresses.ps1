Function Search-ProxyAddresses {
    Param(
            [Parameter(Mandatory=$true)]
            [string] $Alias
    )

Write-Host ""
Write-Host "Possible OnlineIDs:" -ForegroundColor DarkGreen
Write-Host "Get-ADUser -Filter `"proxyaddresses -like `'*$Alias*`'" -Properties * `" -ForegroundColor DarkGreen 
Write-Host "---------------------------" -ForegroundColor DarkGreen
Write-Host ""

try { $Users = Get-ADUser -Filter "proxyaddresses -like '*$Alias*'" -Properties * }
catch { Throw }
if (!($Users)){ 
try { $Users = Get-ADGroup -Filter "proxyaddresses -like '*$Alias*'" -Properties * }
catch { Throw }
}

foreach ($User in $Users) {
        $Obj = New-Object psobject
        $Obj | Add-Member DisplayName $User.DisplayName
        $Obj | Add-Member UserPrincipalName $User.UserPrincipalName
        $Obj | Add-Member samaccountname $User.samaccountname
        $Obj | Add-Member ProxyAddresses $User.proxyaddresses
        $Obj.DisplayName
        $Obj.samaccountname
        $Obj.UserPrincipalName
        $Obj.proxyaddresses
        Write-Host ""
    }
    if ($User.count = 1){
    $Global:user = $User
    }
}

<# 
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

#>
