<#
.SYNOPSIS
    Decompiles all .class files to .java using DJ Java Decompiler (DJD).
.DESCRIPTION
    This script requires DJ Java Decompiler to be installed.
    Download from: http://java-decompiler.github.io/
#>

# Configurations
$djdPath = "C:\Program Files\DJ Java Decompiler\dj.exe"  # Default DJD installation path
$extractedDirs = @("dir1", "dir2", "dir3", "dir4")       # Replace with your extracted directory names

# Verify DJ Decompiler exists
if (-not (Test-Path $djdPath)) {
    Write-Host "ERROR: DJ Java Decompiler not found at $djdPath" -ForegroundColor Red
    Write-Host "Please install DJ Java Decompiler or update the path in the script" -ForegroundColor Yellow
    exit 1
}

# Process each extracted directory
foreach ($dir in $extractedDirs) {
    if (-not (Test-Path $dir)) {
        Write-Host "WARNING: Directory $dir not found. Skipping..." -ForegroundColor Yellow
        continue
    }

    $javaOutputDir = Join-Path $dir "decompiled_java"
    New-Item -ItemType Directory -Path $javaOutputDir -Force | Out-Null

    Write-Host "`nProcessing directory: $dir" -ForegroundColor Cyan

    # Find all .class files recursively
    $classFiles = Get-ChildItem -Path $dir -Filter "*.class" -Recurse -File

    if ($classFiles.Count -eq 0) {
        Write-Host "No .class files found in $dir" -ForegroundColor Yellow
        continue
    }

    $totalFiles = $classFiles.Count
    $processed = 0

    foreach ($classFile in $classFiles) {
        $processed++
        $relativePath = $classFile.FullName.Substring((Get-Item $dir).FullName.Length + 1)
        $javaPath = $relativePath -replace '\.class$','.java'
        $fullJavaPath = Join-Path $javaOutputDir $javaPath

        # Create output directory if it doesn't exist
        $outputDir = [System.IO.Path]::GetDirectoryName($fullJavaPath)
        if (-not (Test-Path $outputDir)) {
            New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
        }

        # Display progress
        Write-Progress -Activity "Decompiling $dir" -Status "$processed/$totalFiles files" `
            -PercentComplete ($processed/$totalFiles*100) `
            -CurrentOperation $relativePath

        # Decompile using DJ Decompiler
        try {
            # DJ Decompiler command-line syntax: dj.exe -o output.java input.class
            & $djdPath -o $fullJavaPath $classFile.FullName
            
            if (Test-Path $fullJavaPath) {
                Write-Host "[SUCCESS] Decompiled: $relativePath" -ForegroundColor Green
            } else {
                Write-Host "[WARNING] DJD produced no output for: $relativePath" -ForegroundColor Yellow
            }
        }
        catch {
            Write-Host "[ERROR] Failed to decompile: $relativePath" -ForegroundColor Red
            Write-Host "Error: $_" -ForegroundColor Red
        }
    }

    Write-Host "`nDecompilation complete for $dir" -ForegroundColor Green
    Write-Host "Java sources saved to: $javaOutputDir" -ForegroundColor Green
}

Write-Host "`nAll decompilation tasks completed!" -ForegroundColor Green
