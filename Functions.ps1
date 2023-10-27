<#
    Enter all functions here to be imported into the session.
    This script will be invoked with no new scope.
#>

Function RunElevated($ScriptBLock)
{
    <#
        This function attempts to create an elevated process to execute the provided script block.
    #>
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

Function Get-GitHubContents()
{
    Param(
        [Parameter(Position=0)]$Account,
        [Parameter(Position=1)]$Repo,
        [Parameter(Position=2)]$ScriptPath
    )
    <#
        This function returns the raw content from github
    #>
    Add-Type -AssemblyName System.Web
    Invoke-RestMethod `
        -Method Get `
        -URI ([System.Web.HttpUtility]::UrlPathEncode("https://raw.githubusercontent.com/${Account}/${Repo}/main/${ScriptPath}")) `
        -UseBasicParsing    
}
