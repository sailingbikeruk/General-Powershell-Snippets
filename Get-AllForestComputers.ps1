[CmdletBinding()]Param (    
    [parameter(Mandatory=$true,    
    HelpMessage="Please enter the FQDN to search, use a * for all")]    
    [System.String]    
    $FQDN      
    )

Import-Module ActiveDirectory
$List =@()
$Count = 0
$Count2 = 0
$Domains = (Get-ADforest).domains
$Filepath =""
$All = $Null

if ($FQDN -eq "*" ){
    foreach($Domain in $Domains)
    {
        $List = Get-ADComputer -Filter * -Server $Domain -Properties * | Select Name, DNSHostName, OperatingSystem, Enabled, LastLogonDate
        $List2 += $List
        $Count=$List.count
        $Count2=$list2.count
        write-host "$count computers were listed in $Domain Total Found now $Count2"
        $Count=0

    }
    $All = $True
}
Else
{        
    $List = Get-ADComputer -Filter * -Server $FQDN -Properties * | Select Name, DNSHostName, OperatingSystem, Enabled, LastLogonDate                
    $Count=$List.count               
    write-host "$count computers were listed in $FQDN"        
    $Count=0
    $All = $False
}

if($All)
{
    $Filepath="e:\scripts\ian\CSV\All_Forest_Computers.csv"
    $List2 | export-csv -Path -$Filepath -NoTypeInformation
    write-host "Details written to $Filepath"
}
else
{
    $Filepath="e:\scripts\ian\CSV\"+$fqdn+"-computers.csv"
    $List | export-csv -path $Filepath -NoTypeInformation
    write-host "Details written to $Filepath"
}
