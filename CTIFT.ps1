Clear-Host
function Menu-Driver() {
   
    Write-Host "######################################"
    Write-Host "#   Concert Tape Info File Trimmer   #"
    Write-Host "#             by: Lilbud             #"
    Write-Host "######################################"
    Write-Host "`nOptions:"
    Write-Host "`n[1] Trim a Text File`n[0] Exit Script"
}
function Open-File($initialDirectory = "") {

    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
 
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialdirectory
    $OpenFileDialog.filter = "TXT (*.txt)| *.txt"
    
    if ($OpenFileDialog.ShowDialog() -eq 'OK') {
        return $OpenFileDialog.FileName
    }
}
function Save-File {
    param(
        $output,
        $fname
    )     
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $SaveFileDialog.initialDirectory = $initialDirectory
    $SaveFileDialog.FileName = $fname
    $SaveFileDialog.filter = "TXT (*.txt)| *.txt"
    $SaveFileDialog.ShowDialog() | Out-Null
    $output.TrimEnd() > $SaveFileDialog.FileName
} 

do {
    Menu-Driver
    do {
        $menuAnswer = Read-Host "`nWhat Would You Like to Do?"
    } until ($menuAnswer -ne "")
    
    if ($menuAnswer -eq "0") {
        Exit
    } else {
        $file = Open-File
        $content = Get-Content -LiteralPath $file
        $filename = [System.IO.Path]::GetFileNameWithoutExtension($file)
        $foldername = [System.IO.Path]::GetDirectoryName($file)
        
        $prefix = Read-Host "`nEnter Line Prefix (Any Characters Before Disc/Track Numbers - ex. d1t01)" # (\(|\[)
        
        $firstTrim = $content -match "^$prefix[0-9]" -replace "(\(|\[)[0-9]{0,2}\:([0-9]{2}\.[0-9]{0,2}|[0-9]{2})(\)|\])","" -replace "\*","" -replace "(.*flac|.*shn)", "".TrimEnd()
        
        echo "`nFile Preview (Including Any Lines with Segue Arrows):`n"
        echo $firstTrim | select -First 3
        echo ($firstTrim -match ">.*$") | select -First 3
        
        $charNum = Read-Host "`nEnter Number of Characters to Trim off Beginning of Line"
        
        $trimmed = $firstTrim -replace "(^.{$charNum})", ""
        
        do {
            $arrowcheck = Read-Host "`nAre There Segue Arrows (>, ->, -->, etc.) in the Tracklist? (y or n)"
        } until (($arrowcheck -eq "y") -or ($arrowcheck -eq "n"))
            
        if ($arrowcheck -eq "y") {
            do {
                $orig_arrow = Read-Host "`nEnter the Type of Segue Arrow in the Original File"
            } until ($orig_arrow -ne "")
            
            do {
                $arrowreplace = Read-Host "`nDo You Wish to Replace the Existing Segue Arrows? (y or n)"
            } until (($arrowreplace -eq "y") -or ($arrowreplace -eq "n"))
        
            if ($arrowreplace -eq "y") {  
                $wanted_arrow = Read-Host "`nEnter the Desired Type of Segue Arrow"     
                $trimmed_Arrows = $trimmed -replace "( *)$orig_arrow", " $wanted_arrow"
                
                Save-File $trimmed_Arrows $filename"_trimmed"

                do {
                    $arrowremove = Read-Host "`nDo You Wish to Output a Copy With No Arrows? (y or n)"
                } until (($arrowremove -eq "y") -or ($arrowremove -eq "n"))
        
                if ($arrowremove -eq "y") {
                    $trimmed_NoArrows = $trimmed_Arrows -replace "$wanted_arrow", ""           
                } 
        
                Save-File $trimmed_NoArrows $filename"_trimmed_NoArrows"
                
            } else {             
                do {
                    $arrowremove1 = Read-Host "`nDo You Wish to Output a Copy With No Arrows? (y or n)"
                } until (($arrowremove1 -eq "y") -or ($arrowremove1 -eq "n"))
        
                if ($arrowremove1 -eq "y") {
                    $trimmed_NoArrows = $trimmed -replace "$orig_arrow", "" 
                }
        
                Save-File $trimmed_NoArrows $filename"_trimmed_NoArrows"
                Save-File $trimmed $filename"_trimmed_Arrows"
            }
        } else {
            Save-File $trimmed $filename"_trimmed"
        }
} 
}until ($menuAnswer -eq "0")