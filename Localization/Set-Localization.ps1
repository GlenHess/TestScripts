<#
    Script takes the LanguageRegionCode lab variable and sets the Windows environment locale and language settings to match
#>

# Functions used:
#   RunElevated
#   Get-GeoId

# Required variables
$Req_Vars = @{
    LanguageRegionCode = '@lab.LanguageRegionCode'
}

# Test for Variables
Foreach ($Req_Var in $Req_Vars.Keys)
{
    if (-not (Get-Variable -name $Req_Var -ErrorAction Ignore))
    {
        Write-Error "Required Variable missing: '$Req_Var'"
    }
}

############################################

$currentLanguage = (Get-Culture).Name

if($LanguageRegionCode -ne $currentLanguage)
{
    $OSInfo = Get-WmiObject -Class Win32_OperatingSystem
    $languagePacks = $OSInfo.MUILanguages
    If($LanguageRegionCode)
    {
        If($languagePacks.ToLower() -contains $LanguageRegionCode.ToLower() -eq $False)
        {
            # Handle language pack not matching - Language not installed
            Write-Error "This language pack $LanguageRegionCode is not installed. Please install it first."
        }
        Else
        {
            # Language installed, set it.
            Set-Culture $LanguageRegionCode
            Set-WinSystemLocale $LanguageRegionCode
            Set-WinHomeLocation $(Get-GeoId($LanguageRegionCode))
            
            # Find all matching major language inputs
            $LanguageInput = $($LanguageRegionCode; $languagePacks | Where-Object {$PSItem -match ($LanguageRegionCode.Split('-')[0])})
            Set-WinUserLanguageList $LanguageInput -force
            RunElevated({New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft" -Name "Edge" -Force})
            RunElevated({New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "SpellcheckLanguage" -Force})
            New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Edge" -Force
            RunElevated($({New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "ApplicationLocaleValue" -Value {0}} -f $LanguageRegionCode))
            RunElevated($({New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\SpellcheckLanguage" -Name 1 -Value {0}} -f $LanguageRegionCode))
            New-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Edge" -Name "ApplicationLocaleValue" -Value $LanguageRegionCode
            New-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Edge" -Name "DefinePreferredLanguages" -Value $LanguageRegionCode
            
            # Remove deprecated scheduled task
            if (Get-ScheduledTask -TaskName "Localization" -ErrorAction Ignore)
            {
                Disable-ScheduledTask -TaskName "Localization" | Out-Null
            }
            # Reboot required
            $Reboot = $true
        }
    }
} 
