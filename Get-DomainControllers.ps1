 import-module ActiveDirectory

$ADForestDomains = (get-adforest).domains
$ADInfo = Get-ADDomain
$ADDomainDNSRoot = $ADInfo.DNSRoot
$ADDomainInfrastructureMaster = $ADInfo.InfrastructureMaster
$ADDomainPDCEmulator = $ADInfo.PDCEmulator
$ADDomainReadOnlyReplicaDirectoryServers = $ADInfo.ReadOnlyReplicaDirectoryServers
$ADDomainReplicaDirectoryServers = $ADInfo.ReplicaDirectoryServers
$ADDomainRIDMaster = $ADInfo.RIDMaster


Write-host "Discovering Domain Controllers in the AD Forest $ADForestName `r "
ForEach ($Domain in $ADForestDomains)
 { ## OPEN ForEach Domain in ADForestDomains
   $DomainDCs = Get-ADDomainController -filter * -server $Domain
   ForEach ($DC in $DomainDCs)
    { ## OPEN ForEach DC in DomainDCs
      $DCName = $DC.HostName
      Write-host "Adding $DCName to ForestDC list `r "
      [array] $ForestDCs += $DC.HostName
     } ## CLOSE ForEach DC in DomainDCs
  } ## CLOSE ForEach Domain in ADForestDomains

$ForestDCsCount = $ForestDCs.count
Write-host "Initial discovery found $ForestDCsCount DCs `r "

 # Add all DC lists into $DomainControllers
$DomainControllers = $ForestDCs + $ADDomainReadOnlyReplicaDirectoryServers + $ADDomainReplicaDirectoryServers + $ADForestGlobalCatalogs
# Remove duplicate DCs from $DomainControllers
$DomainControllers = $DomainControllers | Select-Object -Unique
# Sort the $DomainControllers DC list
$DomainControllers = $DomainControllers | Sort-Object

$DomainControllersCount = $DomainControllers.Count
Write-Verbose “$DomainControllersCount Domain Controllers discovered in the $ADForestName Forest for processing. `r “
Write-Output ” `r “
$DomainControllers
foreach ($Controller in $DomainControllers)
{
$ip = Resolve-DNSName $Controller
$ip
}