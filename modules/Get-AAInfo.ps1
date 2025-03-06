<#
.SYNOPSIS
    Get-AAInfo is a function that will search for an Auto Attendant and 
    return the Auto Attendant's name, extension, and the number of the
    application instance that is associated with the Auto Attendant.
.DESCRIPTION
    This function will search for an Auto Attendant in the Voice Application
    database by the Auto Attendant's name. It will return the Auto Attendant's
    name, extension, and the number of the application instance that is 
    associated with the Auto Attendant. 
.PARAMETER AAName   
    The name of the Auto Attendant to search for.
.EXAMPLE
    Get-AAInfo -AAName "Main Auto Attendant"
    This will return the name, extension, and application instance number of
    the Auto Attendant with the name "Main Auto Attendant".
.NOTES
    Name: Get-AAInfo

#>

Function Get-AAInfo {
    Param(
    [Parameter(Mandatory=$false)]
    [string] $AAName,
    [Parameter(Mandatory=$false)]
    [switch] $ExportToFile
    )
    $FilePath = "C:\Users\wal\Desktop\"
    try {$AAInfo = Get-CsAutoAttendant -NameFilter $AAName }
    catch {Throw "No such Auto Attendant."}
    Foreach ($AA in $AAInfo){
        $Filename = $FilePath + $AA.Name + ".txt"
        $Filename
        $Obj = New-Object psobject
        $Obj | Add-Member Name $AA.Name
        $Obj | Add-Member Extension $AA.Identity
        $Obj | Add-Member ApplicationInstances $AA.ApplicationInstances
        $Obj | Add-Member AuthorizedUsers $AA.AuthorizedUsers
        ""
        "Auto Attendant Name: " + $Obj.Name
        "***************************************"
        ""   
        if ($ExportToFile) {Set-Content -Path $Filename -Value "Auto Attendant Name: $($AA.Name)" -Encoding Unicode}
        if ($ExportToFile) {Add-Content -Path $Filename -Value "***************************************"}
        foreach ($ID in $Obj.ApplicationInstances) {
            $AAID = Get-CsOnlineApplicationInstance -Identity $ID
            $IDObj = New-Object psobject
            $IDObj | Add-Member ResourceAccount $AAID.DisplayName
            $IDObj | Add-Member PhoneNumber $AAID.PhoneNumber
            "Resource Account Name: " + $IDObj.ResourceAccount
            "Resource Account Number: " + $IDObj.PhoneNumber    
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