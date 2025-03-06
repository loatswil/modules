<#
.SYNOPSIS
    Show-User is a function that will display information about a user in Active Directory, Skype for Business, and Exchange Online.
.DESCRIPTION
    This function will display information about a user in Active Directory, Skype for Business, and Exchange Online.
    It will return the user's display name, SAM account name, title, department, language, level, aliases, weapon, boss, 
    address, hometown, state, phone number, communication status, stats, mailbox information, and licenses.
.PARAMETER OnlineID
    The OnlineID of the user to search for. 
.EXAMPLE
    Show-User -OnlineID "jdoe"
    This will return information about the user with the OnlineID "jdoe".
.NOTES
    Name: Show-User
#>
Function Show-User {
    Param(
        [Parameter(Mandatory=$true)]
        [string] $OnlineID
    )
    $ADUser = @{}
    $CSOnlineUser = @{}
    $Mailbox = @{}
    $MailConfig = @{}
    $MGUser = @{}
    
    $Bonuses = @('of greping','of editing','of application slaying','of Cloud slaying','of database monitoring',
        'of spreadsheet sorting','of log searching','of portal slaying','of Azure','of ticket closing','of event parsing')
    $Mods = @('deadly','magical','digital','electronic','binary',
        'caffeinated')
    $Mats = @('wooden','leather','golden','platinum','silver','iron','mithril','emerald','ruby','cloud based','high tech','digital',
        'diamond','steel','bronze','copper','saphire','laser','virtual','cyber')
    $Weapons = @('pen','pencil','pager','cell phone','USB stick','hard drive','CAT-5 cable','power cord','web cam','mouse pad',
        'mouse','compact disk','floppy disk','halberd','cutlass','axe','rock')
    $Alignments = @('Lawful Good','Neutral Good','Chaotic Good',
        'Lawful Neutral','True Neutral','Chaotic Neutral',
        'Lawful Evil','Neutral Evil','Chaotic Evil') 
    $Races = @()
    [bool] $Stud = $false
    [bool] $Fac = $false
    [bool] $Staff = $false

    function Get-RandomList {
        Param(
          [array]$InputList
        )
        return $InputList | Get-Random -Count 1
     }
    function d8 {
       Get-Random -Minimum 1 -Maximum 9
    }
    Function Get-Weapon {
        $ADUser.Weapon = @{}
        $Mod = Get-RandomList -InputList $Mods
        $Mod = $Mod.substring(0,1).toupper()+$Mod.substring(1).tolower()
        $Mat = Get-RandomList -InputList $Mats
        $Type = Get-RandomList -InputList $Weapons
        $Bonus = Get-RandomList -InputList $Bonuses
        $Roll = (Get-Random -Minimum 1 -Maximum 9)
        $Weapon = "$Mod +$Roll $Mat $Type $Bonus"
        $Weapon
    }
    Function Get-Align {
        Switch ($CSOnlineUser.'HostingProvider') {
        'sipfed.online.lync.com' {$Align = "Teams"}
        'SRV:' {$Align = "Skype"}
        default {$Align = "Neutral"}
        }
        $Align
    }
    Function Get-Lics {
        $MGLicenses = $MGUser.SKUPartNumber
        Write-Host "| Licenses"
        Write-Host "|---------"
        Foreach ($MGLicense in $MGLicenses)
        {
        Write-Host "| $MGLicense"
        }
        Write-Host "|"
    }
    
    try {$ADUser = Get-ADUser -Identity $OnlineID -Properties *}
    catch {
        write-host ""
        throw "Character Not Found, please try again..."
        Write-Host ""
    }
    
    try {$CSOnlineUser = Get-CSOnlineUser -Identity $OnlineID}
    catch {
        write-host ""
        throw "CSOnline Character Not Found, please try again..."
        Write-Host ""
    }
    try {$Mailbox = Get-Mailbox -Identity $ADUser.samaccountname}
    catch {
        write-host ""
        throw "Mailbox Not Found, please try again..."
        Write-Host ""
    }
    try {$MailConfig = Get-MailboxMessageConfiguration -Identity $ADUser.samaccountname}
    catch {
        write-host ""
        throw "Mailbox Not Found, please try again..."
        Write-Host ""
    }
    try {$MGUser = Get-MgUserLicenseDetail -UserId $ADUser.UserPrincipalName}
    catch {
        Throw "Can't find user license in Microsoft Graph: $ADUser.UserPrincipalName"
    }

    $Stud = $ADUser.MemberOf | ForEach-Object {$_ | sls student}
    $Fac = $ADUser.MemberOf | ForEach-Object {$_ | sls faculty}
    $Staff = $ADUser.MemberOf | ForEach-Object {$_ | sls staff}
    $Global:user = $ADUser
    $Global:ADUser = $ADUser
    $Global:CSUser = $CSOnlineUser
  
    if ($Stud) {$Races += "Student"}
    if ($Fac) {$Races += "Faculty"}
    if ($Staff) {$Races += "Staff"}

    try {$Boss = (($Aduser.manager).split(",")[0]).TrimStart("CN=") | get-aduser -Properties *}
    catch {}
        
    Function Show-MainMenu {
        Write-Host "================================================================="
        Write-Host "| Character" 
        Write-Host "|------------"
        Write-Host "| Name:         "$ADUser.DisplayName
        Write-Host "| AKA:          "$ADUser.SAMAccountName
        Write-Host "| Races:        "$Races
        Write-Host "| Class:        "$ADUser.Title
        Write-Host "| Clan:         "$ADUser.department
        Write-Host "| Language:     "(Get-Align)
        Write-Host "| Level:        "((Get-Date -UFormat %Y) - ($ADUser.whencreated.year))
        Write-Host "| Aliases:      "$ADUser.kupersonEmailAliases
        Write-Host "| Weapon:       "(Get-Weapon)
        Write-Host "| Boss:         "$Boss.DisplayName `(($Boss.SAMAccountName)`)
        Write-Host "|               "$Boss.SAMAccountName
        Write-Host "|"
        Write-Host "| Background" 
        Write-Host "|------------"
        Write-Host "| Address:      "$ADUser.streetaddress
        Write-Host "| Hometown:     "$ADUser.city
        Write-Host "| State:        "$ADUser.state
        Write-Host "| Phone:        "$ADUser.'msRTCSIP-Line'
        Write-Host "| Communication:"$CSOnlineUser.EnterpriseVoiceEnabled
        Write-Host "| (Voice enabled)"
        Write-Host "|"
        Write-Host "| Stats"  
        Write-Host "|-------"
        Write-Host "| Strength:     "((d8)+(d8)+(d8))
        Write-Host "| Dexterity:    "((d8)+(d8)+(d8))
        Write-Host "| Constitution: "((d8)+(d8)+(d8))
        Write-Host "| Intelligence: "((d8)+(d8)+(d8))
        Write-Host "| Wisdom:       "((d8)+(d8)+(d8))
        Write-Host "| Charisma:     "((d8)+(d8)+(d8))
        Write-Host "|"
        Write-Host "| Mailbox Information:"
        Write-Host "|---------------------"
        Write-Host "| Mailtip:              "$Mailbox.MailTip
        Write-Host "| Archive:              "$Mailbox.ArchiveStatus
        Write-Host "| Acct Disabled:        "$Mailbox.AccountDisabled
        Write-Host "| ReadReceipts:         "$MailConfig.ReadReceiptResponse
        Write-Host "| Forwarding:           "$MailConfig.DeliverToMailboxAndForward
        Write-Host "| Forward Address:      "$MailConfig.ForwardingAddress
        Write-Host "| Forward SMTP:         "$MailConfig.ForwardingSmtpAddress
        Write-Host "| ResourceType:         "$Mailbox.ResourceType
        Write-Host "| RemoteRecipientType:  "$Mailbox.RemoteRecipientType
        Write-Host "| RecipientTypeDetails: "$Mailbox.RecipientTypeDetails
        Write-Host "|"
        (Get-Lics)
        Write-Host "================================================================="
    }
Show-MainMenu
}