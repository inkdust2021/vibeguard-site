#!/usr/bin/env bash
set -euo pipefail

# VibeGuard 一行安装入口（官网域名）
# 用法：curl -fsSL https://vibeguard.top/install | bash
# 说明：本脚本仅做“引导”，真实安装逻辑在代码仓库根目录 install.sh
#
# 可通过环境变量覆盖（便于 fork 或固定版本）：
#   VG_INSTALL_REPO=owner/repo   (默认：inkdust2021/VibeGuard)
#   VG_INSTALL_REF=ref          (默认：main；可设为 v1.2.3 或 commit SHA)
#   VG_INSTALL_PATH=path        (默认：install.sh)

have() { command -v "$1" >/dev/null 2>&1; }

VG_INSTALL_REPO="${VG_INSTALL_REPO:-inkdust2021/VibeGuard}"
VG_INSTALL_REF="${VG_INSTALL_REF:-main}"
VG_INSTALL_PATH="${VG_INSTALL_PATH:-install.sh}"

url="https://raw.githubusercontent.com/${VG_INSTALL_REPO}/${VG_INSTALL_REF}/${VG_INSTALL_PATH}"

if have curl; then
  curl -fsSL "$url" | bash -s -- "$@"
  exit 0
fi
if have wget; then
  wget -qO- "$url" | bash -s -- "$@"
  exit 0
fi

echo "错误：缺少依赖 curl 或 wget" >&2
exit 1
