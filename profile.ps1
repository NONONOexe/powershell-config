#==========================================================================
# PowerShell profile script (Current User / All Hosts)
# Location: '~/OneDrive/documents/PowerShell/profile.ps1'
#
# Host-agnostic settings synced via OneDrive
#==========================================================================

#--------------------------------------------------------------------------
# Bootstrap / Profile Load Timer
#--------------------------------------------------------------------------
$ProfileStopwatch = [System.Diagnostics.Stopwatch]::StartNew()

#--------------------------------------------------------------------------
# Bootstrap / Integrations
#--------------------------------------------------------------------------

# zoxide (smart cd)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { zoxide init powershell | Out-String })
}

# oh-my-posh (prompt theming)
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    $OhMyPoshConfig = Join-Path $PSScriptRoot "oh-my-posh/myconfig.omp.json"
    oh-my-posh --init --shell pwsh --config $OhMyPoshConfig | Invoke-Expression
}

#--------------------------------------------------------------------------
# Functions
#--------------------------------------------------------------------------

function Open-GitPage {
    try {
        $remoteUrl = git remote get-url origin
        if ($remoteUrl) {
            Start-Process $remoteUrl
        } else {
            Write-Warning "Could not determine remote 'origin' URL. Are you in a Git repository with a remote configured?"
        }
    }
    catch {
        Write-Warning "Error executing 'git remote get-url origin'. Make sure Git is installed and you are in a Git repository."
    }
}

function Edit-Profile {
    code $PSScriptRoot
}

function Show-ProfileSummary {
    param (
        [System.Diagnostics.Stopwatch]$Stopwatch
    )

    $psVersion = $PSVersionTable.PSVersion.ToString()
    $os = [System.Runtime.InteropServices.RuntimeInformation]::OSDescription
    $elapsedMs = $Stopwatch.ElapsedMilliseconds

    Write-Host "`u{f0a0a} PowerShell $psVersion | `u{e62a} $os" -ForegroundColor Blue
    Write-Host "`u{f252} Profile load: ${elapsedMs} ms" -ForegroundColor Green
}

#--------------------------------------------------------------------------
# Aliases
#--------------------------------------------------------------------------

Set-Alias ep   Edit-Profile  -Description "Edit PowerShell profile"  -Option AllScope
Set-Alias grep Select-String -Description "grep-like search"         -Option AllScope
Set-Alias ogp  Open-GitPage  -Description "Open Git repository page" -Option AllScope

#--------------------------------------------------------------------------
# Finalize
#--------------------------------------------------------------------------
$ProfileStopwatch.Stop()
Show-ProfileSummary -Stopwatch $ProfileStopwatch
