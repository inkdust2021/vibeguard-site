# VibeGuard 官网安装入口（PowerShell）
# 用法：powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://vibeguard.top/install.ps1 | iex"
# 说明：本脚本仅做“引导”，真实安装逻辑在代码仓库根目录 install.ps1
#
# 可通过环境变量覆盖（便于 fork 或固定版本）：
#   VG_INSTALL_REPO=owner/repo   (默认：inkdust2021/VibeGuard)
#   VG_INSTALL_REF=ref          (默认：main；可设为 v1.2.3 或 commit SHA)
#   VG_INSTALL_PATH=path        (默认：install.ps1)

param(
  [string]$InstallDir = (Join-Path $HOME ".local\\bin"),
  [ValidateSet("auto", "lite", "full")]
  [string]$Variant = "auto",
  [string]$Version = "latest",
  [ValidateSet("system", "user", "auto", "skip")]
  [string]$Trust = "system",
  [ValidateSet("auto", "user", "skip")]
  [string]$PathMode = "auto",
  [ValidateSet("auto", "add", "skip")]
  [string]$AutostartMode = "auto",
  [ValidateSet("auto", "zh", "en")]
  [string]$Language = "auto",
  [switch]$Export,
  [switch]$NonInteractive
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Windows PowerShell 常见问题：默认为 TLS1.0/1.1，访问 GitHub 可能失败
try {
  if ($PSVersionTable.PSVersion.Major -lt 6) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  }
} catch {
  # ignore
}

$repo = $env:VG_INSTALL_REPO
if ([string]::IsNullOrWhiteSpace($repo)) { $repo = "inkdust2021/VibeGuard" }
$ref = $env:VG_INSTALL_REF
if ([string]::IsNullOrWhiteSpace($ref)) { $ref = "main" }
$path = $env:VG_INSTALL_PATH
if ([string]::IsNullOrWhiteSpace($path)) { $path = "install.ps1" }
$url = "https://raw.githubusercontent.com/$repo/$ref/$path"

$headers = @{ "User-Agent" = "VibeGuard-Installer" }
try {
  $content = Invoke-RestMethod -Headers $headers -Uri "$url"
} catch {
  $resp = Invoke-WebRequest -UseBasicParsing -Headers $headers -Uri "$url"
  $content = $resp.Content
}

& ([ScriptBlock]::Create([string]$content)) @PSBoundParameters
