
# Top function to display top 15 processes by CPU usage
function top {
	Get-Process | Sort-Object -des cpu | select -f 15 | ft -a
	write-Host "While(1) {ps | sort -des cpu | select -f 15 | ft -a; sleep 5; cls}"
	Write-Host ""
}

