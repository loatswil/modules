Function Get-MailboxInfo {
Param(
    [Parameter(Mandatory=$false)]
    [string] $FirstName,
    [Parameter(Mandatory=$false)]
    [string] $LastName,
    [Parameter(Mandatory=$false)]
    [string] $OnlineID,
    [parameter(Mandatory=$False)]
    [switch] $Rules
    )

$Obj = @{}

if($OnlineID){
    $ADUser = Get-ADUser $OnlineID -Properties *
    } else {
    $ADUser = Get-ADUser -Filter {surname -like $LastName -and givenname -like $FirstName} -Properties *
}

$Global:User = $ADUser

$UPN = $ADUser.UserPrincipalName
$SAM = $ADUser.samaccountname
$DN = $ADUser.DisplayName

try {$Mailbox = Get-Mailbox -Identity $ADUser.samaccountname}
catch {Write-Host "Mailbox Not Found, please try again..."}

try {$MailConfig = Get-MailboxMessageConfiguration -Identity $ADUser.userprincipalname}
catch {Write-Host "Mailbox Not Found, please try again..."}

try {$MailboxFolderStats = Get-MailboxFolderStatistics -Identity $ADUser.userprincipalname  | Where-Object {$_.Name -like "Inbox"}}
catch {Write-Host "MailboxFolderStats Not Found, please try again..."}

$Inbox = $SAM + "@ku.edu:\inbox"

try {$MailboxFolderPermissions = Get-MailboxFolderPermission -Identity $Inbox}
catch {Write-Host "MailboxFolderPermissions Not Found, please try again..."}

Write-Host ""
Write-Host "AD Account Info" -ForegroundColor Cyan -NoNewline
$ADUser | Format-List DisplayName,
        EmailAddress,
        samaccountname,
        UserPrincipalName,
        TargetAddress

Write-Host "Mailbox Info" -ForegroundColor Cyan -NoNewline
$Mailbox | Format-List DisplayName,
            EmailAddresses,
            PrimarySmtpAddress,
            RecipientType,
            RecipientTypeDetails,
            DistinguishedName,
            GrantSendOnBehalfTo,
            ModeratedBy,
            ModerationEnabled,
            Mailtip,
            ArchiveStatus,
            ArchiveDatabase,
            ArchiveName,
            AccountDisabled,
            ResourceType,
            RemoteRecipientType,
            RecipientTypeDetails,
            MailboxLocations,
            IsMailboxEnabled,
            ForwardingAddress,
            ForwardingSMTPAddress,
            RecipientLimits,
            ServerName,
            MailboxPlan,
            WhenMailboxCreated,
            IsSoftDeletedByRemove,
            WhenSoftDeleted,
            OrganizationalUnit


Write-Host "MailboxMessageConfiguration" -ForegroundColor Cyan -NoNewline
$MailConfig | Format-List ReadReceiptResponse,
            DeliverToMailboxAndForward,
            ForwardingAddress,
            ForwardingSmtpAddress

Write-Host "MailboxFolderStatistics (Inbox only)" -ForegroundColor Cyan -NoNewline
$MailboxFolderStats | Format-List FolderAndSubfolderSize,
            FolderSize

Write-Host "MailboxFolderPermission (Inbox only)" -ForegroundColor Cyan -NoNewline
$MailboxFolderPermissions | Format-List 

if ($rules) {
    try {
        Write-Host ""
        Write-Host "Get-InboxRule" -ForegroundColor Cyan
        $MBRules = Get-InboxRule -Mailbox $SAM@ku.edu 
    }
    catch {
        Write-Host "Can't get inbox rules for account."
    }

    if ($MBRules) {
        $MBRules | Select-Object -Property MailboxOwnerID,Name,Enabled,From,Description,RedirectTo,ForwardTo
    } else {
        Write-Host ""
        Write-Host "No inbox rules for this account."
        Write-Host ""
        }

    }

}