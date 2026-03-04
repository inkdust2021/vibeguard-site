#!/usr/bin/env bash
set -euo pipefail

# 兼容入口：curl -fsSL https://vibeguard.top/uninstall.sh | bash
exec "$(dirname "${BASH_SOURCE[0]}")/uninstall" "$@"

