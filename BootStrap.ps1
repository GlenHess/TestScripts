$Account = "<Enter GitHub Account name>"
$Repo = "<Enter GitHub Repository name>"
$ScriptPath = "<Enter GitHub Script Path>"
$GitHubAuthToken = "<Enter GitHub Auth Token>"

$LanguageRegionCode = '@lab.LanguageRegionCode'

$Bootstrap_Params = @{
    Scripts = @{
        "0" = "Localization"
    }
    PostAction = {if ($Reboot) {shutdown -r -t 5}}
}

# Wait for Internet Connection
$MaxRetries = 20
$Retry = 0
while (
    -not (Test-Connection 'raw.githubusercontent.com' -count 1 -Quiet) -and
    $Retry++ -lt $MaxRetries
) {Start-Sleep -Seconds 3}

If (-not (Test-Connection 'raw.githubusercontent.com' -count 1 -Quiet))
{
    throw('No connection available in 60 seconds.')
}

[System.Text.Encoding] $enc = [System.Text.Encoding]::UTF8

$Content_Parameters = {
    Param
    (
        [Parameter(Position=0)]$Account,
        [Parameter(Position=1)]$repo,
        [Parameter(Position=2)]$file
    )
    Add-Type -AssemblyName System.Web
    @{
        Method = 'Get'
        URI = [System.Web.HttpUtility]::UrlPathEncode("https://api.github.com/repos/${Account}/${repo}/contents/${file}")
        Header = @{
            Accept = "application/vnd.github+json"
            Authorization = "Bearer ${GitHubAuthToken}"
            "X-GitHub-Api-Version" = "2022-11-28"
        }
    }
}

$parameters = &$Content_Parameters $Account $Repo $ScriptPath
$Content = [scriptblock]::Create(($enc.GetString([Convert]::FromBase64String((Invoke-RestMethod @parameters).content))))

<# Public Repo
$Content = Invoke-RestMethod `
    -Method Get `
    -Uri "https://raw.githubusercontent.com/${Account}/${Repo}/main/${ScriptPath}" `
    -UseBasicParsing
#>

Invoke-Command -ScriptBlock $([scriptblock]::Create($Content)) -NoNewScope
