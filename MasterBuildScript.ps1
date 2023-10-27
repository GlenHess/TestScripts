<#
   This script is the first to be pulled down.
#>

# Required variables
#   $Bootstrap_Params = @{
#      Scripts = @{
#         "0" = "Scriptname"
#      }
#      PostAction = {shutdown -r -t 5}
#   }

if (-not (Get-Variable -name Bootstrap_Params -ErrorAction Ignore))
{
  Write-Error "Required Variable missing: 'Bootstrap_Params'"
}

# Import functions
$Account = 'GlenHess'
$Repo = 'TestScripts'
$ScriptPath = 'Functions.ps1'
$content = Invoke-RestMethod `
              -Method Get `
              -URI ([System.Web.HttpUtility]::UrlPathEncode("https://raw.githubusercontent.com/${Account}/${Repo}/main/${ScriptPath}")) `
              -UseBasicParsing
Invoke-Command -ScriptBlock $([scriptblock]::Create($content)) -NoNewScope

# Get Script list
$Scripts_List = Get-GitHubContents "GlenHess" "TestScripts" "Scripts.json"

try {

} catch {$_ | Out-String}
