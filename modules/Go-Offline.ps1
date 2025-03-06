Function Go-Offline {
	Write-Host "Disconnecting from Microsoft Teams..."
	DisConnect-MicrosoftTeams
	Write-Host "Disconnecting from Exchange Online..."
	DisConnect-ExchangeOnline -confirm:$false
	#Write-Host "Disconnecting from SharePoint..."
	#DisConnect-pnponline
	Write-Host "Disconnecting from MgGraph..."
	DisConnect-MgGraph
}
