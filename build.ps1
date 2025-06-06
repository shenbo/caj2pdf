# build-win64-exe

Write-Host "==== 0. Create folders ===="
New-Item -Path "./build" -ItemType Directory -Force
New-Item -Path "./.cache" -ItemType Directory -Force

Write-Host "==== 1. Setup Python venv ===="
if (-not (Test-Path ".venv_caj")) {
    python -m venv .venv_caj
}
.venv_caj/Scripts/activate.ps1
python -V
pip install pypdf2

Write-Host "==== 1.1 Download Python embed version===="
$pythonUrl = "https://www.python.org/ftp/python/3.13.4/python-3.13.4-embed-amd64.zip"
if (-not (Test-Path "./.cache/python.zip")) {
    Invoke-WebRequest -Uri $pythonUrl -OutFile "./.cache/python.zip"
}
Expand-Archive -Path "./.cache/python.zip" -DestinationPath "./build/runtime" -Force

Write-Host "==== 2. Copy files to ./build/* ===="
Get-ChildItem -Path "./*.py" | Copy-Item -Destination "./build" -Recurse -Force
Get-ChildItem -Path "./lib" | Copy-Item -Destination "./build/lib" -Recurse -Force
Copy-Item -Path "./caj2pdf" -Destination "./build/caj2pdf.int" -Recurse -Force

Write-Host "==== 2.1  change .dll path ===="
$jbigdec_file = './build/jbigdec.py'
$old_cmd = '"./lib/bin/libjbigdec-w64.dll"'
$new_cmd = 'os.path.join(os.path.dirname(__file__), "lib/libjbigdec-w64.dll")'
(Get-Content $jbigdec_file).replace($old_cmd, $new_cmd) | Set-Content $jbigdec_file

Write-Host "==== 3. Download PyStand ===="
$pystandUrl = "https://github.com/skywind3000/PyStand/releases/download/1.1.5/PyStand-v1.1.5-exe.zip"
if (-not (Test-Path "./.cache/pystand.zip")) {
    Invoke-WebRequest -Uri $pystandUrl -OutFile "./.cache/pystand.zip"
}
Expand-Archive -Path "./.cache/pystand.zip" -DestinationPath "./.cache/pystand" -Force
Copy-Item -Path "./.cache/pystand/PyStand-x64-CLI/PyStand.exe" -Destination "./build/caj2pdf.exe" -Force

Write-Host "==== 4. Copy venv/Lib/site-packages to build/ ===="
Copy-Item -Path ".venv_caj/Lib/site-packages/PyPDF2" -Destination "./build/site-packages/PyPDF2" -Recurse -Force

# Remove-Item -Path "./.cache" -Recurse -Force

Write-Host "==== 5. Add to context ===="
$caj2pdf = Get-Location | Join-Path -ChildPath "build/caj2pdf.exe"
$regKey = "HKEY_CLASSES_ROOT\SystemFileAssociations\.caj\shell\caj2pdf\command"
$regCommand = $caj2pdf + ' convert \"%1\"'
Write-Host ('reg add "' + $regKey + '" /ve /d "' + $regCommand + '" /f')
reg add $regKey /ve /d $regCommand /f
