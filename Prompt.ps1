function Global:prompt {
	$mydate = get-date -UFormat %y-%m-%d' - '%R
	$SAM = $User.samaccountname
     	"$mydate, $Env:username, $PWD, ($SAM) `nPS>"
}
