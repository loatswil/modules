Function Search-QuarantineRecipient {

param (
    [parameter(Mandatory=$True)][string]$recipient,
    [parameter(Mandatory=$True)][string]$days
    )

Get-QuarantineMessage -RecipientAddress $recipient -EndReceivedDate (get-date) -StartReceivedDate (get-date).AddDays(-$days) | ft ReceivedTime, Subject, SenderAddress, Released

}