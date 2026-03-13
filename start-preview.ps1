param(
  [int]$Port = 4173
)

$scriptPath = $PSCommandPath
if ($scriptPath -like 'Microsoft.PowerShell.Core\FileSystem::*') {
  $scriptPath = $scriptPath -replace '^Microsoft\.PowerShell\.Core\\FileSystem::', ''
}
if ($scriptPath -like '\\?\*') {
  $scriptPath = $scriptPath.Substring(4)
}

$scriptDir = Split-Path -Parent $scriptPath
$log = Join-Path $scriptDir 'preview-server.log'
$deckPath = Join-Path $scriptDir 'magic_artist_deck_v3.html'
$url = "http://127.0.0.1:$Port/magic_artist_deck_v3.html"

function Resolve-Python {
  $direct = Get-Command python -ErrorAction SilentlyContinue
  if ($direct) {
    return @{
      File = $direct.Source
      PrefixArgs = @()
    }
  }

  $launcher = Get-Command py -ErrorAction SilentlyContinue
  if ($launcher) {
    return @{
      File = $launcher.Source
      PrefixArgs = @('-3')
    }
  }

  $fallback = 'C:\Users\laura\AppData\Local\Programs\Python\Python313\python.exe'
  if (Test-Path -LiteralPath $fallback) {
    return @{
      File = $fallback
      PrefixArgs = @()
    }
  }

  return $null
}

"START $(Get-Date -Format o)" | Out-File -FilePath $log -Append -Encoding utf8

try {
  Set-Location -LiteralPath $scriptDir

  if (-not (Test-Path -LiteralPath $deckPath)) {
    throw "Deck file not found: $deckPath"
  }

  $python = Resolve-Python
  if (-not $python) {
    throw 'Could not find Python. Install Python or make `python` available in PATH.'
  }

  "Serving $deckPath" | Tee-Object -FilePath $log -Append
  "Open $url" | Tee-Object -FilePath $log -Append

  & $python.File @($python.PrefixArgs + @('-m', 'http.server', $Port, '--bind', '127.0.0.1')) 2>&1 |
    Tee-Object -FilePath $log -Append
} catch {
  "ERROR: $($_.Exception.Message)" | Out-File -FilePath $log -Append -Encoding utf8
  throw
}
