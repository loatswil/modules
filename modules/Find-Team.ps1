<#
.SYNOPSIS
    Find a Team by DisplayName.
.DESCRIPTION
    This function will search for a Team in Microsoft Teams by DisplayName. 
    It will return the DisplayName and GroupID of the Team.
.PARAMETER DisplayName
    The DisplayName of the Team to search for.
.PARAMETER Members
    If this switch is present, the function will also return the members of the Team.
.EXAMPLE
    Find-Team -DisplayName "My Team"
    This will return the DisplayName and GroupID of the Team with the DisplayName "My Team".
.EXAMPLE
    Find-Team -DisplayName "My Team" -Members
    This will return the DisplayName, GroupID, and members of the Team with the DisplayName "My Team".
.NOTES
    Name: Find-Team
#>


Function Find-Team {
    Param(
            [Parameter(Mandatory=$true)]
            [string] $DisplayName,
            [Parameter(Mandatory=$false)]
            [switch] $Members
    )
    Write-Host ""
    Write-Host "----------------------------------------------------------"

    try {
    $TargetTeam = Get-Team -DisplayName "$DisplayName"
    $TargetTeam | Format-List DisplayName,
                    GroupID
    $Global:Team = $TargetTeam
    }
    catch {
        Throw
    }
}  