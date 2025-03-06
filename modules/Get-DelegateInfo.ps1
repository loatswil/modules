Function Get-DelegateInfo {
Param(
    [Parameter(Mandatory=$True)]
    [string] $OnlineID
    )

try {$CSUser = Get-CSUserCallingSettings -Identity $onlineid}
catch {Write-Host "No such user." -ForegroundColor DarkRed}

try {$Delegates = Get-CSUserCallingSettings -Identity $onlineid | select * -ExpandProperty delegates}
catch {Write-Host "No such user." -ForegroundColor DarkRed}

$CSUser | fl 	SipUri,
		IsForwardingEnabled,
		ForwardingType,
		ForwardingTarget,
		ForwardingTargetType,
		IsUnansweredEnabled,
		UnansweredTarget,
		UnansweredTargetType,
		UnansweredDelay,
		Delegators,
		CallGroupOrder,
		CallGroupTargets,
		GroupMembershipDetails,
		GroupNotificationOverride

Write-Host "Delegates:"
Write-Host "------------------------"
$Delegates | fl

}

