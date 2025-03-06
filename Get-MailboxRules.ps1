Function Get-MailboxRules {
    param (
    [parameter(Mandatory=$True)]
    [string] $OnlineID,
    [parameter(Mandatory=$False)]
    [switch] $Details
    )

try {$ADUser = Get-ADUser -Identity $OnlineID}
catch {Write-Host "User Not Found, please try again." -ForegroundColor DarkRed}

$SAM = $ADUser.samaccountname

try {$Rules = Get-InboxRule -Mailbox $SAM@ku.edu}
catch {Write-Host "No Rules for $ADUser.DisplayName." -ForegroundColor DarkRed}

Write-Host ""
Write-Host "Mailbox Rules for $SAM." -ForegroundColor Cyan

$Rules

if ($Details) {
    $Rules | Format-List MailboxOwnerID,
    Name,
    Enabled,
    From,
    Description,
    RedirectTo,
    ForwardTo
    }
}
