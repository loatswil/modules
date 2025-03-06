Function Get-TeamUsers {
    Param(
            [Parameter(Mandatory=$true)]
            [string] $Team
    )

    try {$TargetTeam = Get-Team -DisplayName "$Team" | select -First 1}
    catch {throw}

    Write-Host ""
    Write-Host "Team Name: " $TargetTeam.DisplayName
    Get-TeamUser -GroupId $TargetTeam.groupid
}
