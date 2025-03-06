Function Search-Transcripts {
    param (
    [parameter(Mandatory=$True)][string]$term
    )
    $transcripts = "C:\Users\wal_a\Documents\"
    foreach ($file in (Get-ChildItem -Path $transcripts | Sort-Object -Property LastWriteTime | select -Last 5)) {
        if (($file.Name.StartsWith('Power')) -and ($file.Name.EndsWith('.txt'))) { 
            if ($string = (Get-Content -Path $file.FullName | Select-String $term -Context 1, 3)){
                $file.FullName
                $string
            }
        }
    }
}
