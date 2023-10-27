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


try {

} catch {$_ | Out-String}
