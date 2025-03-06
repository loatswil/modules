function Caper {
        Write-Host "You caper around merrily."
}
function Sigh {
        Write-Host "You sigh."
}
function Hmm {
        Write-Host "You go 'Hmm...'."
}
function Bonk {
        Write-Host "You bonk yourself on the head."
}
function check1 {
        Write-Host "You check everything and it looks fine."
}
function check {
        Clear-Host;1..(Get-Random 10) | foreach {work -noadverbs;write ""}
	write "Done."
}

