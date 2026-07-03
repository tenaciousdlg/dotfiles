#!/usr/bin/env bash
# Downloads and installs the Teleport Enterprise package for macOS.
# Requires TF_VAR_teleport_version to be set (e.g. export TF_VAR_teleport_version=15.4.2).
set -euo pipefail

if [[ -z "${TF_VAR_teleport_version:-}" ]]; then
  echo "Error: TF_VAR_teleport_version is not set." >&2
  exit 1
fi

pkg="teleport-ent-${TF_VAR_teleport_version}.pkg"

curl -O "https://cdn.teleport.dev/${pkg}"
sudo installer -pkg "${pkg}" -target /
which teleport
