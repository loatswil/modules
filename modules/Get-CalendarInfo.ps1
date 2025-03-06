<#
.SYNOPSIS
    Get-CalendarInfo retrieves information about a user's calendar mailbox.
.DESCRIPTION
    This function will return information about a user's calendar mailbox.
.PARAMETER OnlineID
    The onlineid of the user.
.EXAMPLE
    Get-CalendarInfo -OnlineID "JohnDoe"
    This will return information about the user's calendar mailbox.
.NOTES
#>
function Get-CalendarInfo {
    Param(
    [Parameter(Mandatory=$True)]
    [string] $OnlineID
    )

try {$ADUser = Get-ADUser -Identity $OnlineID -Properties *}
catch {Write-Host "No such account." -ForegroundColor DarkRed}

$DN = $ADUser.DisplayName
$SAM = $ADUser.samaccountname
$UPN = $ADUser.UserPrincipalName

$MBFolders="";$MBPerm="";$MB="";$ADUser=""
$AccountCal = $SAM + ":\Calendar"
$AccountGroup = $SAM + "_smbx"

try {$MB = Get-Mailbox -Identity $UPN  | Select-Object grant*, *forward*, RecipientType*}
catch {Write-Host "No such Mailbox." -ForegroundColor DarkRed}

try {$MBFolders = Get-MailboxFolderStatistics $UPN -folderscope calendar}
catch {Write-Host "No Mailbox Folders." -ForegroundColor DarkRed}

try {$MBPerm = Get-MailboxFolderPermission -Identity $UPN}
catch {Write-Host "No such Mailbox." -ForegroundColor DarkRed}

try {$CalPerm = Get-MailboxFolderPermission -Identity $AccountCal}
catch {Write-Host "No Calendar Folders."}

try {$CalendarProcessing = Get-CalendarProcessing -Identity $UPN}
catch {Write-Host "No CalendarProcessing."}

try {$GroupMembers = Get-ADGroupMember $AccountGroup}
catch {}

Write-Host ""
Write-Host "Get-Mailbox -Identity $UPN | Select-Object grant*, *forward*" -ForegroundColor Cyan -NoNewline
$MB | Format-List

Write-Host "Get-MailboxFolderStatistics $UPN -folderscope calendar" -ForegroundColor Cyan
$MBFolders | Format-Table Name, Identity, folderpath, foldertype

Write-Host "Get-MailboxFolderPermission -Identity $UPN" -ForegroundColor Cyan
$MBPerm | Format-Table

Write-Host "Get-MailboxFolderPermission -Identity $AccountCal" -ForegroundColor Cyan
$CalPerm | Format-Table
foreach ($cal in $MBFolders) {
    if ($cal.Name -notlike "Calendar") {
        $Folder = $OnlineID + ":\Calendar\" + $cal.Name
        Get-MailboxFolderPermission -Identity $Folder
        Write-Host ""
        }
}

Write-Host "Get-CalendarProcessing -Identity $UPN" -ForegroundColor Cyan
Write-Host "Only affects 'RoomMailbox' Recipient Type Mailboxes (see above)." -ForegroundColor Cyan
Write-Host ""

$CalendarProcessing | Format-List

if ($GroupMembers) {
    Write-Host "Get-ADGroupMember $AccountGroup" -ForegroundColor Cyan
    Write-Host ""
    $GroupMembers.samaccountname
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "No shared mailbox group members for this account."
    Write-Host ""
    }

}
