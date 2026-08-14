# AutoCommit.ps1
# Automatically creates a separate Git commit for each changed/untracked file
# and pushes all commits to GitHub.

Set-Location $PSScriptRoot

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "      C++ GitHub Auto Commit & Push" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Make sure this is a Git repository
git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: This folder is not a Git repository." -ForegroundColor Red
    exit 1
}

# Get modified and untracked files.
# Excludes this script so it doesn't commit itself.
$files = @()

$modifiedFiles = git diff --name-only
$untrackedFiles = git ls-files --others --exclude-standard

$files = @($modifiedFiles) + @($untrackedFiles)
$files = $files |
    Where-Object { $_ -and $_ -ne "AutoCommit.ps1" } |
    Sort-Object -Unique

if ($files.Count -eq 0) {
    Write-Host "No new or modified files to commit." -ForegroundColor Yellow
    exit 0
}

Write-Host "Files found: $($files.Count)" -ForegroundColor Green
Write-Host ""

foreach ($file in $files) {
    Write-Host "----------------------------------------" -ForegroundColor DarkGray
    Write-Host "Processing: $file" -ForegroundColor Cyan

    # Stage only this file
    git add -- "$file"

    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Could not stage $file" -ForegroundColor Red
        exit 1
    }

    # Create a separate commit for this file
    $commitMessage = "Add $file"
    git commit -m "$commitMessage"

    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Could not commit $file" -ForegroundColor Red
        exit 1
    }

    Write-Host "Committed: $file" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Pushing all commits to GitHub..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

git push

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERROR: Push failed. Your commits are still saved locally." -ForegroundColor Red
    Write-Host "Run 'git push' after fixing the GitHub/authentication issue." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "SUCCESS! All separate commits were pushed to GitHub." -ForegroundColor Green
