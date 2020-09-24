Import-Module ActiveDirectory
$ErrorActionPreference = "Stop"
$DCList = @()
$EventList = <put event here>
write-host "Getting Domains"
$domains = (get-adforest).domains

foreach ($domain in $domains) {
    write-host "Getting Domain Controllers from $domain" -ForegroundColor Blue
    $DCList = Get-ADDomainController -Filter * -Server $domain
    foreach ($EventID in $EventList) {
        "checking for $EventID"
        foreach ($dc in $DCList) {
            write-host $dc.name -NoNewline
            Try { Get-WinEvent -ComputerName $dc.hostname -FilterHashtable @{ LogName = 'Security'; Id = $EventID } }
            Catch { write-host " - Not Found" -ForegroundColor Red }
        }
    }
