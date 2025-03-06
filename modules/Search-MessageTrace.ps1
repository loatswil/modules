Function Search-MessageTrace {

param (
    [parameter(Mandatory=$True)][string]$sender,
    [parameter(Mandatory=$True)][string]$days
    )

Get-MessageTrace -SenderAddress $sender -EndDate (get-date) -StartDate (get-date).AddDays(-$days) | ft Status, Subject, RecipientAddress, Received 

}