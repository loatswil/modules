function Test-ADCreds {
	Start-Process -FilePath cmd.exe /c -Credential (Get-Credential)
}