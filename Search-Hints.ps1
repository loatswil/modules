Function Search-Hints {
    param (
    [parameter(Mandatory=$True)][string]$term
    )
    $hints = "$HOME\OneDrive\_hints\"
        foreach ($file in (Get-ChildItem -Path $hints)) {
            if ($file.FullName.EndsWith(".txt")) { 
                if ($string = (Get-Content -Path $file.FullName | Select-String $term -Context 0, 8)){
		    Write-Host ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
                    $file.FullName
		    Write-Host ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
                    $string
                }
            }
	}
}
