# VibeGuard 官网卸载入口（PowerShell）
# 用法：
#   powershell -NoProfile -ExecutionPolicy Bypass -Command "& ([ScriptBlock]::Create((irm https://vibeguard.top/uninstall.ps1)))"
#   powershell -NoProfile -ExecutionPolicy Bypass -Command "& ([ScriptBlock]::Create((irm https://vibeguard.top/uninstall.ps1))) -Purge"
#
# 说明：本脚本仅做“引导”，真实卸载逻辑在代码仓库根目录 uninstall.ps1
#
# 可通过环境变量覆盖（便于 fork 或固定版本）：
#   VG_UNINSTALL_REPO=owner/repo   (默认：inkdust2021/VibeGuard)
#   VG_UNINSTALL_REF=ref          (默认：main；可设为 v1.2.3 或 commit SHA)
#   VG_UNINSTALL_PATH=path        (默认：uninstall.ps1)

param(
  [switch]$Purge,
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

$repo = $env:VG_UNINSTALL_REPO
if ([string]::IsNullOrWhiteSpace($repo)) { $repo = "inkdust2021/VibeGuard" }
$ref = $env:VG_UNINSTALL_REF
if ([string]::IsNullOrWhiteSpace($ref)) { $ref = "main" }
$path = $env:VG_UNINSTALL_PATH
if ([string]::IsNullOrWhiteSpace($path)) { $path = "uninstall.ps1" }
$url = "https://raw.githubusercontent.com/$repo/$ref/$path"

$headers = @{ "User-Agent" = "VibeGuard-Uninstaller" }
try {
  $content = Invoke-RestMethod -Headers $headers -Uri "$url"
} catch {
  $resp = Invoke-WebRequest -UseBasicParsing -Headers $headers -Uri "$url"
  $content = $resp.Content
}

& ([ScriptBlock]::Create([string]$content)) @PSBoundParameters

