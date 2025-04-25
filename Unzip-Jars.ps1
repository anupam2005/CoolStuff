# Unzip-Jars.ps1
# Extracts all JAR files in current directory to individual folders

# Get all JAR files in current directory (limit to 4 as requested)
$jarFiles = Get-ChildItem -Path . -Filter *.jar | Select-Object -First 4

if ($jarFiles.Count -eq 0) {
    Write-Host "No JAR files found in current directory." -ForegroundColor Yellow
    exit
}

foreach ($jar in $jarFiles) {
    $folderName = [System.IO.Path]::GetFileNameWithoutExtension($jar.Name)
    $zipPath = "$($jar.FullName).zip"
    
    Write-Host "Processing $($jar.Name)..." -ForegroundColor Cyan
    
    try {
        # Temporarily rename to .zip
        Rename-Item -Path $jar.FullName -NewName $zipPath -ErrorAction Stop
        
        # Create output folder if it doesn't exist
        $outputPath = Join-Path -Path $PWD -ChildPath $folderName
        if (-not (Test-Path -Path $outputPath)) {
            New-Item -ItemType Directory -Path $outputPath | Out-Null
        }
        
        # Extract the archive
        Expand-Archive -Path $zipPath -DestinationPath $outputPath -Force
        
        # Rename back to .jar
        Rename-Item -Path $zipPath -NewName $jar.Name -ErrorAction Stop
        
        Write-Host "Successfully extracted to $outputPath" -ForegroundColor Green
    }
    catch {
        Write-Host "Error processing $($jar.Name): $_" -ForegroundColor Red
        # Try to rename back if something failed
        if (Test-Path $zipPath) { Rename-Item -Path $zipPath -NewName $jar.Name }
    }
}

Write-Host "`nExtraction complete for $($jarFiles.Count) JAR files." -ForegroundColor Green
