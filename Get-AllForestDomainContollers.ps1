Import-Module ActiveDirectory
$Controllers =@()
$Count = 0
$Domains = (Get-ADforest).domains

foreach($Domain in $Domains)
{
$Controllers += Get-ADDomaincontroller -Filter * -Server $Domain | Select-Object Name, Domain, OperatingSystem, IPv4Address
}
foreach($Controller in $Controllers)
{
$Count = $Count+1
}

$Controllers | Out-GridView