# Define variables
$repoZipUrl = "https://github.com/we-dcode/HeadlessMcAfeeNuker/releases/download/v1.0.0/mcafee_killer.zip"
$localZipPath = "C:\Temp\mcafee_killer.zip"
$repoUnzippedPath = "C:\Temp\mcafee_killer.zip"
$cleanupExe = "mccleanup.exe"

# Function to download a file
function Download-File {
    param (
        [string]$Url,
        [string]$Destination
    )
    Write-Host "Downloading $Url to $Destination..."
    Invoke-WebRequest -Uri $Url -OutFile $Destination -ErrorAction Stop
}

# Function to unzip a file
function Unzip-File {
    param (
        [string]$ZipFilePath,
        [string]$DestinationPath
    )
    Write-Host "Extracting $ZipFilePath to $DestinationPath..."
    Expand-Archive -Path $ZipFilePath -DestinationPath $DestinationPath -Force
}

# Step 1: Check if the zipped repository exists
if (-Not (Test-Path -Path $localZipPath)) {
    Write-Host "Zipped repository not found at $localZipPath."
    Download-File -Url $repoZipUrl -Destination $localZipPath
} else {
    Write-Host "Zipped repository already exists at $localZipPath."
}

# Step 2 & 3: Check if the repository is unzipped, and unzip if necessary
if (-Not (Test-Path -Path $repoUnzippedPath)) {
    Write-Host "Unzipped repository not found at $repoUnzippedPath."
    Unzip-File -ZipFilePath $localZipPath -DestinationPath $repoUnzippedPath
} else {
    Write-Host "Unzipped repository already exists at $repoUnzippedPath."
}

# Step 4: Change to the unzipped repository
Set-Location -Path $repoUnzippedPath

# Step 5: Run the McAfee cleanup tool
$cleanupToolPath = Join-Path -Path $repoUnzippedPath -ChildPath $cleanupExe

if (Test-Path -Path $cleanupToolPath) {
    Write-Host "Running McAfee cleanup tool..."
    Start-Process -FilePath $cleanupToolPath -ArgumentList "-p StopServices,MFSY,PEF,MXD,CSP,Sustainability,MOCP,MFP,APPSTATS,Auth,EMProxy,FWDriver,HW,MAS,MAT,MBK,MCPR,McProxy,McSvcHost,VUL,MHN,MNA,MOBK,MPF,MPFPCU,MPS,SHRED,MPSCU,MQC,MQCCU,MSAD,MSHR,MSK,MSKCU,MWL,NMC,RedirSvc,VS,Remediation,MSC,YAP,TrueKey,LAM,PCB,Symlink,SafeConnect,MGS,WMIRemover,RESIDUE -v -s" -NoNewWindow -Wait -Verb RunAs
    Write-Host "McAfee cleanup completed successfully."
} else {
    Write-Host "Cleanup tool not found at $cleanupToolPath."
}

# Cleanup
Write-Host "Script execution completed."
