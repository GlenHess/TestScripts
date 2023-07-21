{
    $Topic = "Skillable_2023_SC_CW"
    $Request = @{
        Method = "POST"
        URI = "https://ntfy.sh/${Topic}"
        Headers = @{
            Tags = "Newcomers"
        }
        Body = "Welcome!"
    }
    Invoke-RestMethod @Request
}

{
    $Token = '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'

    [System.Text.Encoding]::UTF8.GetString(
        [Convert]::FromBase64String(
            (
                Invoke-RestMethod `
                    -Method 'Get' `
                    -URI "https://api.github.com/repos/GlenHess/Markdown/contents/instructions/content.md" `
                    -Header @{
                        Accept = "application/vnd.github+json"
                        Authorization = "Bearer ${TOKEN}"
                        "X-GitHub-Api-Version" = "2022-11-28"
                    }
            ).Content
        )
    )
    
    Invoke-WebRequest -Uri (Invoke-RestMethod `
        -Method 'Get' `
        -URI "https://api.github.com/repos/GlenHess/Markdown/contents/instructions/content.md" `
        -Header @{
            Accept = "application/vnd.github+json"
            Authorization = "Bearer ${TOKEN}"
            "X-GitHub-Api-Version" = "2022-11-28"
        }).download_url -OutFile temp.md
    
    (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/GlenHess/Markdown/main/instructions/content.md" `
        -Header @{
            Accept = "application/vnd.github+json"
            Authorization = "Bearer ${TOKEN}"
            "X-GitHub-Api-Version" = "2022-11-28"
        } `
        -UseBasicParsing).Content
}

{
    Get-module -ListAvailable
    # 32bit - %SystemRoot%\syswow64\WindowsPowerShell\v1.0\powershell.exe
    [Environment]::Is64BitProcess
    Get-module -ListAvailable | Select-Object Name,PowerShellVersion,CompatiblePSEditions,Path
    # 64bit - %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe
    [Environment]::Is64BitProcess
    Get-module -ListAvailable | Select-Object Name,PowerShellVersion,CompatiblePSEditions,Path
}

{
    [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(""))
    [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(""))
}

{
#Script 1 - Custom
$(
$XML = @"
<Request>
    <Metadata>
        <Instructions>
            <Execute>
            <Transaction>
                <Type>PERSIST</Type>
                <Model>
                    <Name>TestPolicyInsured</Name>
                </Model>
            </Transaction>
        </Execute>
        <Return>
            <Model>
                <Name>TestPolicyInsured</Name>
            </Model>
        </Return>
        </Instructions>
    </Metadata>
    <Data>
        <TestPolicyInsured>		
            <PolicyNo>POLICY124</PolicyNo>		   		     
            <EffectiveDate>2014-06-01+05:30</EffectiveDate> 
            <ExpirationDate>2014-06-31+05:30</ExpirationDate>
            <DOB>2014-06-01+05:30</DOB>
            <InsuredName>Majemp1</InsuredName>
            <Country>IND</Country> 
            <State>MAH</State> 
            <City>PU</City>
            <ZipCode>411028</ZipCode>
        </TestPolicyInsured>
    </Data>
</Request>
"@

[System.Text.Encoding] $enc = [System.Text.Encoding]::UTF8
[byte[]] $encText = $enc.GetBytes($XML)
$XML_enc = [Convert]::ToBase64String($encText)

Set-LabVariable -Name XMLenc -Value $XML_enc
$true
)
# Script 2 - VM on VMware
$(
$ErrorActionPreference = "Stop"
$results = $false

try
{
Add-Type -AssemblyName System.Web

function Format-XML ([xml]$xml, $indent=2)
{
    $StringWriter = New-Object System.IO.StringWriter
    $XmlWriter = New-Object System.XMl.XmlTextWriter $StringWriter
    $xmlWriter.Formatting = "indented"
    $xmlWriter.Indentation = $Indent
    $xml.WriteContentTo($XmlWriter)
    $XmlWriter.Flush()
    $StringWriter.Flush()
    Write-Output $StringWriter.ToString()
}

$RefAttr = @"
PolicyID
PolicyNo
EffectiveDate
InsuredName
Country
State
City
ZipCode
DOB
"@.Split("`n")

$XML_enc = '@lab.Variable(XMLenc)'

[System.Text.Encoding] $enc = [System.Text.Encoding]::UTF8
$encText = [Convert]::FromBase64String($XML_enc)
$XML = $enc.GetString($encText)

$wadl = "http://localhost:13579/ICDService/services/ProcessManager?_wadl"

$response = Invoke-RestMethod -Uri $wadl
$REST_Uri = ""
$REST_Uri += $response.application.resources.base
$REST_Uri += $response.application.resources.resource.path
$REST_Uri += $response.application.resources.resource.resource.path

$Body_XML = $XML

$Rest_Params = @{
    URI = $REST_Uri
    Method = 'POST'
    ContentType = "application/octet-stream"
    Body = $Body_XML
}

$response = Invoke-RestMethod @Rest_Params

Set-LabVariable -Name o1A -Value $(
    [system.web.httputility]::HtmlEncode(
        $(
            (Format-XML -xml ($response.OuterXML)) -replace "`r`n","`n"
        )
    )
)

$CompareObj = (Get-Member -InputObject $response.Request.Data.TestPolicyInsured -MemberType Property).Name

If (
    $null -ne $response.Request.Data.TestPolicyInsured -and
    $null -eq $(Compare-Object -ReferenceObject $RefAttr -DifferenceObject $CompareObj)
)
{
    $results = $true
}
Else
{
    [system.web.httputility]::HtmlEncode(
        $(
            (Format-XML -xml ($response.OuterXML)) -replace "`r`n","`n"
        )
    )
}
#Format-XML -xml ($response.OuterXML)
}
catch
{
    #$_.Exception.Response | Out-String
}

$results
)
}

# https://www.powershellgallery.com/packages/Posh-SSH/3.0.8
# https://github.com/darkoperator/Posh-SSH
{
    Import-Module "${ENV:USERPROFILE}\Downloads\Posh-SSH\Posh-SSH.psd1"
        
    $Cred = [PSCredential]::new('root',(ConvertTo-SecureString -String 'Passw0rd!' -AsPlainText -Force))
    $ssh = $(
        New-SSHSession -ComputerName esxi01.hexelo.com `
        -Credential $Cred -AcceptKey -KeepAliveInterval 5
    )
    Start-Sleep -Seconds 1
    $SSHStream = New-SSHShellStream -SessionId $ssh.SessionId
    Start-Sleep -Seconds 1
    $SSHStream.WriteLine("du /vmfs/volumes/Local_VMFS/Desktop01/Desktop01-flat.vmdk")
    Start-Sleep -Seconds 1
    $output = $SSHStream.read()
    $File = $output.Split("`n")[-2] | ConvertFrom-String -PropertyNames "MB","Path" -Delimiter "`t"
    Remove-SSHSession -SessionId $ssh.SessionId | Out-Null
}

# Run PowerShell 5.1 in 64bit via command (BATCH)
{
@'
    @echo off
    setlocal EnableDelayedExpansion
    SET RESULT=false
    cd %USERPROFILE%
    set LF=^


    REM Two empty lines are required
    set SCRIPT_BLOCK=$result = $false!LF!^
    try!LF!^
    {!LF!^
        Import-Module VMware.VimAutomation.Core ^| Out-Null!LF!^
        $Creds = [PSCredential]::new('administrator@vsphere.local',(ConvertTo-SecureString -String 'Passw0rd^^!' -AsPlainText -Force))!LF!^
        Connect-VIServer -Server vcenter01.hexelo.com -Credential $Creds ^| Out-Null!LF!^
        $VM = Get-VM -Name "Desktop01"!LF!^
        If ($VM.UsedSpaceGB -gt 7) {$result = $true}!LF!^
    } catch {}!LF!^
    $result

    echo !SCRIPT_BLOCK! > tmpfile.ps1

    SET COMMAND=%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -file tmpfile.ps1
    %COMMAND% > tmpfile
    IF %ERRORLEVEL% EQU 0 (GOTO :GETOUTPUT) ELSE (GOTO :INCORRECT)

    :GETOUTPUT
    SET OUTPUT=
    SET /p OUTPUT= < tmpfile
    REM del tmpfile
    REM del tmpfile.ps1
    IF [%OUTPUT%] NEQ [False] (GOTO :CORRECT) ELSE (GOTO :INCORRECT)

    :CORRECT
    SET RESULT=true
    GOTO :GOTOEND

    :INCORRECT
    GOTO :GOTOEND

    :GOTOEND
    ECHO %RESULT%
'@
}

# Run POwerShell 7 in Linux (BASH)
{
@'
SCRIPT=$(cat << EOF
whoami
Get-ChildItem
\$PSVersionTable
EOF
)
pwsh -c "$SCRIPT"
echo true
'@
}

# Exporting a file to Lab Instance page
{
Add-Type -AssemblyName System.Web

function Get-CompressedByteArray {
	[CmdletBinding()]
    Param (
	[Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [byte[]] $byteArray = $(Throw("-byteArray is required"))
    )
	Process {
        Write-Verbose "Get-CompressedByteArray"
       	[System.IO.MemoryStream] $output = New-Object System.IO.MemoryStream
        $gzipStream = New-Object System.IO.Compression.GzipStream $output, ([IO.Compression.CompressionMode]::Compress)
      	$gzipStream.Write( $byteArray, 0, $byteArray.Length )
        $gzipStream.Close()
        $output.Close()
        $tmp = $output.ToArray()
        Write-Output $tmp
    }
}

Function Get-BlockString
{
    Param(
        [string]$String,
        [int]$LineLength
    )
    $BlockString = ""
    $Step = 0
    while ($Step -le $String.Length)
    {
        #"$Step $Length"
        If (($Step+$LineLength) -ge ($String.Length)) {$Length = ($String.Length) - $Step}
        else {$Length = $LineLength}
        $BlockString += $String.Substring($Step,$Length) | Out-String
        #$String.Substring($Step,$Length)
        $Step = $Step + $LineLength
    }
    return $BlockString
}

$File = Get-Item C:\Users\Admin\Desktop\ExamA-ENG.docx

$CompressedBase64 = [Convert]::ToBase64String((
Get-CompressedByteArray -byteArray (Get-Content -Path $File.FullName -Encoding Byte)
))

$ScriptBlock = ""
$ScriptBlock += {
function Get-DecompressedByteArray {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [byte[]] $byteArray = $(Throw("-byteArray is required"))
    )
    Process {
        Write-Verbose "Get-DecompressedByteArray"
        $input = New-Object System.IO.MemoryStream( , $byteArray )
        $output = New-Object System.IO.MemoryStream
        $gzipStream = New-Object System.IO.Compression.GzipStream $input, ([IO.Compression.CompressionMode]::Decompress)
        $gzipStream.CopyTo( $output )
        $gzipStream.Close()
        $input.Close()
        [byte[]] $byteOutArray = $output.ToArray()
        Write-Output $byteOutArray
    }
}
}
$ScriptBlock += {
$CompressedBase64 = '{0}'
} -f $CompressedBase64
$ScriptBlock += {
Set-Content -Path {0} `
-Value ([byte[]](Get-DecompressedByteArray -byteArray ([Convert]::FromBase64String($CompressedBase64)))) `
-Encoding Byte
} -f $File.Name

$encodedCommand = [Convert]::ToBase64String(
    ([System.Text.Encoding]::Unicode.GetBytes($ScriptBlock))
)

$ExecuteMe = {
Invoke-Command -ScriptBlock (
    [scriptblock]::Create(
        [System.Text.Encoding]::Unicode.GetString(
            (
                [Convert]::FromBase64String(
"
{0}"
                )
            )
        )
    )
)
} -f (Get-BlockString -String $encodedCommand -LineLength 80)

[system.web.httputility]::HtmlEncode(
    $(
        $ExecuteMe -replace "`r`n","`n"
    )
) -replace "&quot;",'"'

$true
}
