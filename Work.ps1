<#
.SYNOPSIS
    Work module for generating random work tasks.
#>

$Adverbs = @('quickly','painstakingly','randomly','slowly','literally','boldly','bravely','brightly',
    'cheerfully','deftly','devotedly','eagerly','elegantly','faithfully','gleefully','gracefully',
    'happily','honestly','innocently','kindly','merrily','obediently','perfectly','politely','powerfully',
    'safely','victoriously','warmly','vivaciously','achingly','angrily','annoyingly','anxiously','badly',
    'boastfully','dejectedly','enviously','foolishly','hopelessly','irritably','jealously','joylessly',
    'lazily','miserably','morosely','obnoxiously','painfully','poorly','rudely','sadly','selfishly','terribly',
    'unhappily','wearily','finally','frequently','generally','nightly','normally','occasionally','regularly',
    'still','briskly','casually','expeditiously','fleetingly','gradually','haltingly','hastily','hurriedly',
    'immediately','instantly','languidly','lazily','leisurely','promptly','quickly','rapidly','slowly','speedily',
    'swiftly','tediously','audibly','deafeningly','ear-splittingly','emphatically','faintly','inaudibly','loudly',
    'noiselessly','noisily','quietly','resonantly','resoundingly','shrilly','silently','softly','soundlessly',
    'thunderously','uproariously','vociferously','weakly','accidentally','awkwardly','blindly','coyly','crazily',
    'cruelly','defiantly','deliberately','doubtfully','dramatically','dutifully','enormously','excitedly','hungrily',
    'madly','mortally','mysteriously','nervously','seriously','shakily','restlessly','solemnly','sternly',
    'unexpectedly','wildly')
$Actions = @('compacting','extracting','hacking','defragging','extending','requesting','updating','upgrading',
    'packaging','researching','preparing','disabling','searching','calculating','managing','formatting','deploying',
    'deleting','restoring','correlating','patching')
$Objects = @('the database','directories','servers','websites','folders','email','users','phone numbers','hard drives',
    'floppy disks','IP Addresses','software','firmware','memory','firewall rules','routing tables','fiber optics','NIC cards',
    'CAT5 cables','spreadsheets')

function Get-RandomList {
   Param(
     [array]$InputList
   )
   return $InputList | Get-Random -Count 1
}

function Do-Work {
    param (
        [string]$text,
        [int]$count
        ) 
    Write-Host $text -nonewline
    for($i=1;$i -le $count;$i++) {
        Write-Host "." -NoNewline
        Start-Sleep -Milliseconds 500
        }
}

function Get-Task {
    $Adverb = Get-RandomList -InputList $Adverbs
    $Action = Get-RandomList -InputList $Actions
    $Object = Get-RandomList -InputList $Objects
    $Adverb = $Adverb.substring(0,1).toupper()+$Adverb.substring(1).tolower()
    "$Adverb $Action $Object"
}

function Get-BoringTask {
    $Action = Get-RandomList -InputList $Actions
    $Object = Get-RandomList -InputList $Objects
    $Action = $Action.substring(0,1).toupper()+$Action.substring(1).tolower()
    "$Action $Object"
}

function work {
	Param(
    	[Parameter(Mandatory=$false)]
    	[switch] $NoAdverbs
	)		
	if ($NoAdverbs) {
		Do-Work (Get-BoringTask) (Get-Random -Minimum 3 -Maximum 4)
	} else {
		Do-Work (Get-Task) (Get-Random -Minimum 3 -Maximum 4)
	}
}
