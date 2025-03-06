Function Reload-Module {
    Param(
            [Parameter(Mandatory=$true)]
            [string] $Module
    )

    try {
        Remove-Module $Module
    }
    catch {
        Throw
    }
    try {
        Import-Module C:\Users\wal\Onedrive\Scripts\PowerShell\modules\$Module.ps1
        Write-Host "$Module reloaded."
    }
    catch {
        Throw
    }
}