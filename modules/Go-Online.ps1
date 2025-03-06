Function Go-Online {
	Write-Host "Connecting to Microsoft Teams..."
	Connect-MicrosoftTeams
	Write-Host "Connecting to Exchange Online..."
	Connect-ExchangeOnline
	#Write-Host "Connection to SharePoint PnPOnline"
	#Connect-PnPOnline -Url https://kansas.sharepoint.com/ -Interactive
	Write-Host "Connecting to MgGraph/Entra..."
	Connect-MgGraph -NoWelcome
}
