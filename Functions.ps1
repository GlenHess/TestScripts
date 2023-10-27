<#
    Enter all functions here to be imported into the session.
    This script will be invoked with no new scope.
#>

Function RunElevated($ScriptBLock)
{
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell"
    $newProcess.Arguments = $ScriptBlock
    $newProcess.Verb = "runas"
    [void][System.Diagnostics.Process]::Start($newProcess)
}

Function Get-GeoId($Name='*')
{
    $cultures = [System.Globalization.CultureInfo]::GetCultures('InstalledWin32Cultures') #| Out-GridView
     foreach($culture in $cultures)
    {
       try{
           $region = [System.Globalization.RegionInfo]$culture.Name
           #Write-Host "00 :"$Name "|" $region.DisplayName "|" $region.Name "|" $region.GeoId "|" $region.EnglishName "|" $culture.LCID
           if($region.Name -like $Name)
           {
                $region.GeoId
           }
       }
       catch {}
    }
}
