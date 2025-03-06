function Get-Garbage {
    Param(
        [Parameter(Mandatory=$false)]
        [string] $amount
    )
    $garbage = @(1,2,3,4,5,6,7,8,9,0,'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z')
    if ($amount) {
        while ($i -lt $amount) {
            write-host ($garbage | get-random) -nonewline    
            $i++
        }
        Write-Host ''
    }
    else {
        while ($true) {write-host ($garbage | get-random) -nonewline}
    }
}
