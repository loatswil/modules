Function Get-TeamInfo {
    Param(
            [Parameter(Mandatory=$true)]
            [string] $GID,
            [Parameter(Mandatory=$false)]
            [switch] $Members
    )
    Write-Host ""
    Write-Host "----------------------------------------------------------"

    try {
    $TargetTeam = Get-Team -GroupID "$GID" | Select-Object *
    } catch {
    Throw
    }
    
    try {
    $TargetGroup = Get-UnifiedGroup -Identity $TargetTeam.GroupID
    } catch {
    throw
    }
    try {
    $Channels = Get-TeamChannel -GroupId $TargetTeam.GroupId
    } catch {
    throw
    }

    $DN = $TargetTeam.DisplayName
    
    Write-Host "Getting Team Info for $DN"
    Write-Host "----------------------------------------------------------"
    Write-Host ""
    Write-Host "Team Users:"
    Write-Host "----------------------------------------------------------"
    Get-TeamUser -GroupID $TargetTeam.GroupID | fl

    Write-Host "Channels..."
    Write-Host "----------------------------------------------------------"
    
    ForEach ($Channel in $Channels) {
        $Channel.DisplayName
        if ($Members) {
            ForEach ($Channel in $Channels) {
                $ChannelUsers = Get-TeamChannelUser -GroupId $TargetTeam.GroupId -DisplayName $Channel.DisplayName
            }
            $ChannelUsers | Format-List User, Name, Role
        }

    }
    Write-Host ""
    Write-Host "Team Details..."
    Write-Host "----------------------------------------------------------"
    $TargetTeam | Format-List
    Write-Host ""
    Write-Host "Group Details..."
    Write-Host "----------------------------------------------------------"
    $TargetGroup | Format-List DisplayName, PrimarySMTPAddress, AutoSubscribeNewMembers, *hidden*, Always*
}