<#
.SYNOPSIS
	Uptime module for displaying the uptime of the system.	

#>

function uptime {
	(Get-Date) - (gcim Win32_OperatingSystem).LastBootUpTime
}