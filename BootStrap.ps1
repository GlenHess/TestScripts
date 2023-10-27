$Account = "<Enter GitHub Account name>"
$Repo = "<Enter GitHub Repository name>"
$ScriptPath = "<Enter GitHub Script Path>"

$LanguageRegionCode = '@lab.LanguageRegionCode'

$Bootstrap_Params = @{
    Scripts = @{
        "0" = "Localization"
    }
    PostAction = {if ($Reboot) {shutdown -r -t 5}}
}

# Wait for Internet Connection
$MaxRetries = 10
$Retry = 0
while (
    -not (Test-Connection 'raw.githubusercontent.com' -count 1 -Quiet) -and
    $Retry++ -lt $MaxRetries
) {Start-Sleep -Seconds 3}

If (-not (Test-Connection 'raw.githubusercontent.com' -count 1 -Quiet))
{
    throw('No connection available in 30 seconds.')
}

$Content = Invoke-RestMethod `
    -Method Get `
    -Uri "https://raw.githubusercontent.com/${Account}/${Repo}/main/${ScriptPath}" `
    -UseBasicParsing

Invoke-Command -ScriptBlock $([scriptblock]::Create($Content)) -NoNewScope
