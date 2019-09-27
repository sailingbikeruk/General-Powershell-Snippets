# Show an Open Folder Dialog and return the directory selected by the user.
function Get-Folder([string]$Message, [string]$InitialDirectory)
{    
    $app = New-Object -ComObject Shell.Application    
    $folder = $app.BrowseForFolder(0, $Message, 0, $InitialDirectory)    
    if ($folder) 
    { 
        return $folder.Self.Path } 
        else { return '' 
    }
}

$a = Get-Folder
write-host $a