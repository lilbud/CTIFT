# CTIFT - Concert Tape Info File Trimmer
# Created by Lilbud

Clear-Host

# ENTER DESIRED SEGUE ARROW HERE
$segue_arrow = ">"

# IF YOU WANT TO OUTPUT A FILE WITH NO ARROWS, set to $true
$outputArrowless = $false

function File_Handling {
	param(
		$file
	)
	$content = Get-Content -LiteralPath $file
	$fileName = [System.IO.Path]::GetFileNameWithoutExtension($file)
	$folderName = [System.IO.Path]::GetDirectoryName($file)
	
	# attempt to guess leading characters before song names
	# lines usually start with either number, 'd', 't'

	# regex is hell
	$times = "(\(|\[)*\d{1,2}:\d{1,2}\.\d{0,2}(\)|\])*"

	# for any other patterns to remove
	$other = "(\(cut\)|.*(flac|---xx|files|khz|wav|AUD|@|missing|shn).*|\d{1,4}\.\d{1,2}\.\d{2,4}|\[\d{1,2}\])"

	# TODO - add case for "dusbourne? weird tracklisting"

	if ($folderName -match ".*dusborne.*") {
		$pattern = "^\d{3} - (gd)\d{2}-\d{2}-\d{2}[ds]\d{1,2}[t]\d{1,2} - "
		$trimmed = $content.trim() -match $pattern -notmatch "Source Matrix" -replace $pattern, "" -replace " *-*>", " $segue_arrow" -replace "tuning", "Tuning" -replace "intro", "Intro" -replace "\s+", " " -replace "(%|;|\*+|/)", ""
	} else {
		$pattern = "^[dts]*\d{1,3}.([dts]*\d{1,2}[ts]*\d{1,2})*(-\d{1,2})* *-* *"
		$trimmed = $content.trim() -match $pattern -replace "($pattern|$times|$other)", "" -replace " *-*>", " $segue_arrow" -replace "tuning", "Tuning" -replace "intro", "Intro" -replace "\s+", " " -replace "(%|;|\*+|/)", ""
	}

	#write-host $trimmed

	try {
		Write-Host $trimmed.trim()

		$trimmed.trim() | Out-File -FilePath "$($folderName)\$($fileName)_trimmed.txt"

		if ($outputArrowless -eq $true) {
			$trimmed.trim() | Out-File -FilePath "$($folderName)\$($fileName)_trimmed_noArrows.txt"
		}

		Set-Clipboard -value "$($folderName)\$($fileName)_trimmed.txt"
		Write-Host "Trimmed File Saved, Path Copied to Clipboard"
	}
	catch {
		Write-Host "ERROR: Processing Failed, closing program"
		exit
	}

}

do {
	if (-not($args[0])) {
		$path = Read-Host "`n> Enter Path to Info File (or 0 to exit)"
		if ($path -ne "0") {
			$file = $path -replace "`"", ""
			Write-Host $file
			File_Handling $file
		} else {
			exit
		}
	} else {
		Write-Host $args[0]
		File_Handling $args[0]
	}
} Until ($path -eq "0")