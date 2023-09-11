Clear-Host

$path = $args[0]

function File_Handling {
	param(
		$file
	)
	$content = Get-Content -LiteralPath $file
	$fileName = [System.IO.Path]::GetFileNameWithoutExtension($file)
	$folderName = [System.IO.Path]::GetDirectoryName($file)
	$prefix = Read-Host "`n> Enter Line Prefix (Any Characters Before Disc/Track Numbers - ex. d1t01)" # (\(|\[) 
	$firstTrim = $content -match "^$prefix\d" -replace "((\d{0,2}\:\d{0,2}.\d{0,2})|(\d{0,2}\:\d{0,2}))", "" -replace "\*", "" -replace ".*(flac|shn)", "" -replace "\($|\)$", "" -replace "\[$|\]$", "".TrimEnd()
        
	Write-Output "`n# File Preview (Including Any Lines with Segue Arrows):`n"
	Write-Output $firstTrim | Select-Object -First 3
	Write-Output ($firstTrim -match ">.*$") | Select-Object -First 3

	$charNum = Read-Host "`n> Enter Number of Characters to Trim off Beginning of Line"
	$trimmed = $firstTrim -replace "(^.{$charNum})", ""
        
	do {
		$arrowCheck = Read-Host "`n# Are There Segue Arrows (>, ->, -->, etc.) in the Tracklist?`n[1] Yes`n[2] No`n> Enter Choice"
	} until (($arrowCheck -eq "1") -or ($arrowCheck -eq "2"))
            
	switch ($arrowCheck) {
		1 {
			$arrowOrig = Read-Host "`n> Enter the Original Segue Arrow"
			$arrowReplace = Read-Host "`n# Do You Wish to Replace the Existing Segue Arrows?`n[1] Yes`n[2] No`n> Enter Choice"

			switch ($arrowReplace) {
				1 {
					#replace arrows
					$arrowNew = Read-Host "`nEnter the Desired Segue Arrow"
					$trimmed -replace "( *)$($arrowOrig)", " $($arrowNew)" | Out-File -FilePath "$($folderName)\$($fileName)_trim_arrows.txt"
					$trimmed -replace "( *)$($arrowOrig)( *)", "" | Out-File -FilePath "$($folderName)\$($fileName)_trim_noArrows.txt"
				}
				2 {
					#don't replace arrows   
					$trimmed.Trim() | Out-File -FilePath "$($folderName)\$($fileName)_trim_arrows.txt"
				}
			}
		} 
		2 {
			#no arrows
			$trimmed.Trim() | Out-File -FilePath "$($folderName)\$($fileName)_trim_noArrows.txt"
		}
	}  
}

if ($path -eq "") {
	$path = Read-Host "`n> Enter Path to Info File (Can Also Drag and Drop File on Top of Window)"
}
$file = $path -replace "`"", ""
File_Handling $file