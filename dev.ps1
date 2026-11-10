param([switch]$NoAgent)
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
$env:ALLOW_REMOTE_DB = "1"
$node = Split-Path (fnm exec --using=24 powershell -NoProfile -Command "(Get-Command node).Source")
$env:Path = "$node;$env:Path"
bunx turbo run dev:prepare --ui=stream
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
if ($NoAgent) {
	bunx turbo run dev --filter=!agent --only --ui=stream
	exit $LASTEXITCODE
}
bunx concurrently -n web,agent -c green,cyan `
	"bunx turbo run dev --filter=!agent --only --ui=stream" `
	"bunx turbo run dev:headless --filter=agent --only --ui=stream"
exit $LASTEXITCODE
