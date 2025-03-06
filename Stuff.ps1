if ($env:username -eq "wal_a"){Remove-Variable -force HOME; $HOME = "C:\Users\wal"}
if ($env:username -eq "SYSTEM"){Remove-Variable -force HOME; $HOME = "C:\Users\wal"}
if ($env:username -eq "loats"){Remove-Variable -force HOME; $HOME = "C:\Users\loats"}
Set-Alias vi 'C:\Program Files (x86)\Vim\vim82\vim.exe'
Set-Alias sh Search-Hints
Set-Alias du Directory-Usage
$hints = "$HOME\Onedrive\_hints\"
$modules = "$HOME\Onedrive\Scripts\PowerShell\modules\"
$desktop = "$HOME\Desktop\"
$downloads = "$HOME\Downloads\"
