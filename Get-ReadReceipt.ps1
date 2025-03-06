Function Get-ReadReceipt {
    Param(
            [Parameter(Mandatory=$true)]
            [string] $OnlineID
    )
$MB = Get-MailboxMessageConfiguration -Identity $OnlineID
$MB | ft ReadReceiptResponse

}


