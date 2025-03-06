Function Search-QuarantineSender {

param (
    [parameter(Mandatory=$True)][string]$sender,
    [parameter(Mandatory=$True)][string]$days
    )

Get-QuarantineMessage -SenderAddress $sender -EndReceivedDate (get-date) -StartReceivedDate (get-date).AddDays(-$days) | ft ReceivedTime, Subject, RecipientAddress, Released

}
