<#
.SYNOPSIS
    Automatically stages and commits EACH changed/new/deleted file as its own
    separate commit, then syncs with the remote and pushes — all in one run.

.USAGE
    Place this file at the root of your git repo, then run:
        .\AutoCommit.ps1

    Optional parameters:
        .\AutoCommit.ps1 -Branch main -Remote origin
        .\AutoCommit.ps1 -Extensions ".cpp",".h",".hpp"   # only commit these file types individually
                                                            # (everything else is skipped)

.NOTES
    - Fixes the "cannot pull with rebase: uncommitted changes" / "rejected (fetch first)"
      errors from your screenshot by committing FIRST, then pulling --rebase, then pushing.
#>

param(
    [string]$Branch = "main",
    [string]$Remote = "origin",
    [string[]]$Extensions = @()   # empty = commit every changed file, one commit each
)

# 1. Make sure we're inside a git repo
git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Not inside a git repository. Run this from your repo root." -ForegroundColor Red
    exit 1
}

Write-Host "Checking for changes..." -ForegroundColor Cyan

# Use -z (NUL-separated, unquoted paths) so filenames with spaces/special
# characters parse correctly. Format per entry: "XY PATH", NUL-terminated.
# Rename/copy entries are followed by an extra NUL-terminated ORIG_PATH entry.
$raw = git status --porcelain -z

if (-not $raw) {
    Write-Host "Nothing to commit. Working tree clean." -ForegroundColor Green
}
else {
    $entries = $raw -split "`0" | Where-Object { $_ -ne "" }
    $i = 0
    while ($i -lt $entries.Count) {
        $entry      = $entries[$i]
        $statusCode = $entry.Substring(0, 2)
        $filePath   = $entry.Substring(3)
        $i++

        # Rename/copy entries have an extra ORIG_PATH entry right after - skip it
        if ($statusCode[0] -eq 'R' -or $statusCode[0] -eq 'C') {
            $i++
        }

        # Don't let the script commit itself every run
        if ($filePath -eq "AutoCommit.ps1") { continue }

        # If -Extensions was given, skip files that don't match
        if ($Extensions.Count -gt 0) {
            $ext = [System.IO.Path]::GetExtension($filePath)
            if ($Extensions -notcontains $ext) { continue }
        }

        $verb = switch -Regex ($statusCode.Trim()) {
            "^\?\?" { "Add" }
            "^A"    { "Add" }
            "^D"    { "Delete" }
            "^R"    { "Rename" }
            default { "Update" }
        }

        Write-Host "Staging: $filePath" -ForegroundColor Yellow
        git add -- "$filePath"

        $commitMsg = "$verb $filePath"
        git commit -m "$commitMsg" | Out-Null

        if ($LASTEXITCODE -eq 0) {
            Write-Host "Committed: $commitMsg" -ForegroundColor Green
        }
        else {
            Write-Host "Nothing staged for $filePath, skipping." -ForegroundColor DarkYellow
        }
    }
}

# Safety net: if anything was still missed above for any reason, catch it
# here so the rebase step below never fails with "unstaged changes".
$leftover = git status --porcelain
if ($leftover) {
    Write-Host "Catching leftover changes..." -ForegroundColor Yellow
    git add -A
    git commit -m "Update remaining files" | Out-Null
}

Write-Host "`nSyncing with $Remote/$Branch..." -ForegroundColor Cyan
git pull --rebase $Remote $Branch

if ($LASTEXITCODE -ne 0) {
    Write-Host "Rebase hit a conflict. Resolve it, then run:" -ForegroundColor Red
    Write-Host "   git rebase --continue" -ForegroundColor Red
    Write-Host "   git push $Remote $Branch" -ForegroundColor Red
    exit 1
}

Write-Host "Pushing to $Remote/$Branch..." -ForegroundColor Cyan
git push $Remote $Branch

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nDone! Every changed file is now its own commit, and it's pushed." -ForegroundColor Green
}
else {
    Write-Host "Push failed. See the error above." -ForegroundColor Red
}
