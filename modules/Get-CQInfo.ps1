<#
.SYNOPSIS
    Get-CQInfo is a function that will search for a Call Queue and 
    return the Call Queue name, extension, and the number of the
    application instance that is associated with the Auto Attendant.
.DESCRIPTION
    This function will search for a Call Queue in the Voice Application
    database by the Call Queue name. It will return the Call Queue's
    name, extension, and the number of the application instance that is 
    associated with the Call Queue. 
.PARAMETER CQName   
    The name of the Call Queue to search for.
.EXAMPLE
    Get-CCQInfo -CQName "Main Call Queue"
    This will return the name, extension, and application instance number of
    the Call Queue with the name "Main Call Queue".
.NOTES
    Name: Get-CQInfo

#>

Function Get-CQInfo {
    Param(
    [Parameter(Mandatory=$false)]
    [string] $CQName,
    [Parameter(Mandatory=$false)]
    [switch] $ExportToFile
    )
    $FilePath = "C:\Users\wal\Desktop\"
    try {$CQInfo = Get-CsCallQueue -NameFilter $CQName -warningaction SilentlyContinue }
    catch {Throw "No such Call Queue."}
    Foreach ($CQ in $CQInfo){
        $Filename = $FilePath + $CQ.Name + ".txt"
        $Obj = New-Object psobject
        $Obj | Add-Member Name $CQ.Name
        $Obj | Add-Member Extension $CQ.Identity
        $Obj | Add-Member ApplicationInstances $CQ.ApplicationInstances
        $Obj | Add-Member AuthorizedUsers $CQ.AuthorizedUsers
        ""
        "Call Queue Name: " + $Obj.Name
        "***************************************"
        ""   
        if ($ExportToFile) {Set-Content -Path $Filename -Value "Call Queue Name: $($CQ.Name)" -Encoding Unicode}
        if ($ExportToFile) {Add-Content -Path $Filename -Value "***************************************"}
        foreach ($ID in $Obj.ApplicationInstances) {
            $AAID = Get-CsOnlineApplicationInstance -Identity $ID
            $IDObj = New-Object psobject
            $IDObj | Add-Member ResourceAccount $AAID.DisplayName
            $IDObj | Add-Member PhoneNumber $AAID.PhoneNumber
            "Resource Account Name: " + $IDObj.ResourceAccount
            "Resource Accont Number: " + $IDObj.PhoneNumber    
            ""
            if ($ExportToFile) {$IDObj | Out-File -FilePath $Filename -Append} 
        }
        foreach ($AuthUser in $Obj.AuthorizedUsers) {
            $AU = Get-CsOnlineUser -Identity $AuthUser
            $AuthObj = New-Object psobject
            $AuthObj | Add-Member AuthorizedUser $AU.DisplayName
            $AuthObj | Add-Member UserPrincipalName $AU.UserPrincipalName
            "Authorized User: " + $AuthObj.AuthorizedUser
            "Authorized User Extension: " + $AuthObj.UserPrincipalName
            ""
            if ($ExportToFile) {$AuthObj | Out-File -FilePath $Filename -Append}
        }
    }
}