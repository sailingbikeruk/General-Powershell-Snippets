
Function LogWrite {
    Param ([string]$Logstring)

    Add-Content $Logfile -value $logstring -ErrorAction Stop 
    Write-Host $logstring
}