#!/usr/bin/env bash
set -euo pipefail

if [[ $# -gt 0 ]]; then
  app_path="$1"
else
  app_path="$(find release -path '*/CheckupMap.app' -type d | head -n 1)"
fi

if [[ -z "${app_path}" || ! -d "${app_path}" ]]; then
  echo "No CheckupMap.app found to verify." >&2
  exit 1
fi

echo "Verifying ${app_path}"
codesign --verify --deep --strict --verbose=4 "${app_path}"
spctl --assess --type execute --verbose=4 "${app_path}"
xcrun stapler validate "${app_path}"
echo "Mac signing, Gatekeeper assessment, and stapled notarization ticket are valid."
