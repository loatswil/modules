<#
.SYNOPSIS
    Get-CsPhoneNumberAssignment retrieves information about a user's phone number assignment.
.DESCRIPTION
    This function will return information about a user's phone number assignment.
.PARAMETER TelephoneNumber
    The telephone number of the user.
.EXAMPLE
    Get-CsPhoneNumberAssignment -TelephoneNumber "555-555-5555"
    This will return information about the user's phone number assignment.
.NOTES
#>
Function Get-CSNumberInfo {
    Param(
            [Parameter(Mandatory=$true)]
            [string] $Number
    )
	$Status = Get-CsPhoneNumberAssignment -TelephoneNumber $TelephoneNumber
}

$Status | Format-Table DisplayName, ObjectID, UserPrincipalName
