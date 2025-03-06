Function Show-a365Owners {
    param (
    [parameter(Mandatory=$False)][string]$Owner
    )
    $Owners = Import-CSV \\kucfs.home.ku.edu\ITES_Apps\anywhere365\exported_ucc_owners.csv
    if (!($Owner)) {
	    $Owners
        }
    else {
	    $Owners | sls $Owner
    }
}
