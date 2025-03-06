<#
  .SYNOPSIS
    Check SSL Certificate of a website. 
  .DESCRIPTION
    Check SSL Certificate of a website.
  .PARAMETER site
    The website to check.
  .EXAMPLE
    Check-Cert -site www.google.com
#>

Function Check-Cert {

param (
    [parameter(Mandatory=$True)][string]$site
  )

Write-Host ""

$request = [System.Net.Sockets.TcpClient]::new($site, '443')
$stream = [System.Net.Security.SslStream]::new($request.GetStream())
$stream.AuthenticateAsClient($site)
#$stream.RemoteCertificate | gm
Write-Host "Site:" $site
Write-Host "Subject:" $stream.RemoteCertificate.Subject
Write-Host "Issuer:" $stream.RemoteCertificate.Issuer
Write-Host "Expires:" $stream.RemoteCertificate.GetExpirationDateString()
Write-Host ""

}