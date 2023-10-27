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

$Content = Invoke-RestMethod `
    -Method Get `
    -Uri "https://raw.githubusercontent.com/${Account}/${Repo}/main/${ScriptPath}" `
    -UseBasicParsing

Invoke-Command -ScriptBlock $([scriptblock]::Create($Content)) -NoNewScope
