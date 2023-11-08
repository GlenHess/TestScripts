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

$Base64 = "
DQogICAgW0NtZGxldEJpbmRpbmcoRGVmYXVsdFBhcmFtZXRlclNldE5hbWUgPSAnUHVibGljJyldDQogIC
AgUGFyYW0gKA0KICAgICAgICBbUGFyYW1ldGVyKE1hbmRhdG9yeSwgUGFyYW1ldGVyU2V0TmFtZSA9ICdQ
dWJsaWMnLCBQb3NpdGlvbiA9IDApXQ0KICAgICAgICBbUGFyYW1ldGVyKE1hbmRhdG9yeSwgUGFyYW1ldG
VyU2V0TmFtZSA9ICdQcml2YXRlJywgUG9zaXRpb24gPSAwKV0NCiAgICAgICAgW3N0cmluZ10kQWNjb3Vu
dCwNCg0KICAgICAgICBbUGFyYW1ldGVyKE1hbmRhdG9yeSwgUGFyYW1ldGVyU2V0TmFtZSA9ICdQdWJsaW
MnLCBQb3NpdGlvbiA9IDEpXQ0KICAgICAgICBbUGFyYW1ldGVyKE1hbmRhdG9yeSwgUGFyYW1ldGVyU2V0
TmFtZSA9ICdQcml2YXRlJywgUG9zaXRpb24gPSAxKV0NCiAgICAgICAgW3N0cmluZ10kUmVwbywNCg0KIC
AgICAgICBbUGFyYW1ldGVyKE1hbmRhdG9yeSwgUGFyYW1ldGVyU2V0TmFtZSA9ICdQdWJsaWMnLCBQb3Np
dGlvbiA9IDIpXQ0KICAgICAgICBbUGFyYW1ldGVyKE1hbmRhdG9yeSwgUGFyYW1ldGVyU2V0TmFtZSA9IC
dQcml2YXRlJywgUG9zaXRpb24gPSAyKV0NCiAgICAgICAgW3N0cmluZ10kRmlsZVBhdGgsDQoNCiAgICAg
ICAgW1BhcmFtZXRlcihQYXJhbWV0ZXJTZXROYW1lID0gJ1ByaXZhdGUnLCBQb3NpdGlvbiA9IDMpXQ0KIC
AgICAgICBbc3RyaW5nXSRBdXRoVG9rZW4NCiAgICApDQogICAgSWYgKFtzdHJpbmddOjpJc051bGxPcldo
aXRlU3BhY2UoJEF1dGhUb2tlbikpIHsNCiAgICAgICAgV3JpdGUtVmVyYm9zZSAiUGFyYW1ldGVyIFNldD
ogUHVibGljIg0KICAgICAgICAkUHVibGljID0gJHRydWUNCiAgICB9DQogICAgZWxzZQ0KICAgIHsNCiAg
ICAgICAgV3JpdGUtVmVyYm9zZSAiUGFyYW1ldGVyIFNldDogUHJpdmF0ZSINCiAgICB9DQogICAgQWRkLV
R5cGUgLUFzc2VtYmx5TmFtZSBTeXN0ZW0uV2ViDQogICAgJFJlc3RNZXRob2RfUGFyYW1ldGVycyA9IEB7
fQ0KICAgICRSZXN0TWV0aG9kX1BhcmFtZXRlcnMuQWRkKCdNZXRob2QnLCdHZXQnKQ0KICAgICRSZXN0TW
V0aG9kX1BhcmFtZXRlcnMuQWRkKCdVc2VCYXNpY1BhcnNpbmcnLCR0cnVlKQ0KICAgIElmICgkUHVibGlj
KQ0KICAgIHsNCiAgICAgICAgJFJlc3RNZXRob2RfUGFyYW1ldGVycy5BZGQoDQogICAgICAgICAgICAnVV
JJJywNCiAgICAgICAgICAgIFtTeXN0ZW0uV2ViLkh0dHBVdGlsaXR5XTo6VXJsUGF0aEVuY29kZSgiaHR0
cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tLyR7QWNjb3VudH0vJHtSZXBvfS9tYWluLyR7RmlsZV
BhdGh9IikNCiAgICAgICAgKQ0KICAgIH0NCiAgICBFbHNlICMgUHJpdmF0ZQ0KICAgIHsNCiAgICAgICAg
JFJlc3RNZXRob2RfUGFyYW1ldGVycy5BZGQoDQogICAgICAgICAgICAnVVJJJywNCiAgICAgICAgICAgIF
tTeXN0ZW0uV2ViLkh0dHBVdGlsaXR5XTo6VXJsUGF0aEVuY29kZSgiaHR0cHM6Ly9hcGkuZ2l0aHViLmNv
bS9yZXBvcy8ke0FjY291bnR9LyR7UmVwb30vY29udGVudHMvJHtGaWxlUGF0aH0iKQ0KICAgICAgICApDQ
ogICAgICAgICRSZXN0TWV0aG9kX1BhcmFtZXRlcnMuQWRkKA0KICAgICAgICAgICAgJ0hlYWRlcicsDQog
ICAgICAgICAgICBAew0KICAgICAgICAgICAgICAgIEFjY2VwdCA9ICJhcHBsaWNhdGlvbi92bmQuZ2l0aH
ViK2pzb24iDQogICAgICAgICAgICAgICAgQXV0aG9yaXphdGlvbiA9ICJCZWFyZXIgJHtBdXRoVG9rZW59
Ig0KICAgICAgICAgICAgICAgICJYLUdpdEh1Yi1BcGktVmVyc2lvbiIgPSAiMjAyMi0xMS0yOCINCiAgIC
AgICAgICAgIH0NCiAgICAgICAgKQ0KICAgIH0NCiAgICBXcml0ZS1WZXJib3NlICJSZXN0TWV0aG9kX1Bh
cmFtZXRlcnM6YG4kKCRSZXN0TWV0aG9kX1BhcmFtZXRlcnMgfCBDb252ZXJ0VG8tSnNvbiB8IE91dC1TdH
JpbmcpIg0KICAgICRDb250ZW50ID0gSW52b2tlLVJlc3RNZXRob2QgQFJlc3RNZXRob2RfUGFyYW1ldGVy
cw0KICAgIElmICgkUHVibGljKQ0KICAgIHsNCiAgICAgICAgcmV0dXJuICRDb250ZW50DQogICAgfQ0KIC
AgIEVsc2UNCiAgICB7DQogICAgICAgIHJldHVybiBbU3lzdGVtLlRleHQuRW5jb2RpbmddOjpVVEY4Lkdl
dFN0cmluZyhbQ29udmVydF06OkZyb21CYXNlNjRTdHJpbmcoKCRDb250ZW50LmNvbnRlbnQpKSkNCiAgIC
B9DQo=
"

$Function = $(
    "Function Get-GitHubContents"
    "{"
    [system.text.encoding]::utf8.GetString([Convert]::FromBase64String($Base64))
    "}"
)

Invoke-Command -ScriptBlock ([scriptblock]::Create($Function)) -NoNewScope

$Content = Get-GitHubContents $Account $Repo $ScriptPath $GitHubAuthToken

Invoke-Command -ScriptBlock $([scriptblock]::Create($Content)) -NoNewScope
