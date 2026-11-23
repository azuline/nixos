#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

# Use promoted channel revisions: arbitrary Hydra evaluations may still be
# building, and master can run ahead of the binary cache. Channel promotion
# provides cache coverage without relying on a fixed number of days of age.
# Keep nixpkgs-latest and the Rose compatibility pin unchanged by default.
# To explicitly refresh master too: ./update.sh nixpkgs-latest
channel_revision() {
  local channel="$1"
  local revision
  revision=$(curl --fail --silent --show-error --location --retry 3 \
    "https://channels.nixos.org/$channel/git-revision")
  if [[ ! "$revision" =~ ^[0-9a-f]{40}$ ]]; then
    echo "Invalid revision for channel $channel: $revision" >&2
    return 1
  fi
  printf '%s\n' "$revision"
}

unstable_revision=$(channel_revision nixpkgs-unstable)
stable_revision=$(channel_revision nixos-26.05)

nix flake update --flake "$repo_dir" nixpkgs nixpkgs-stable "$@" \
  --override-input nixpkgs "github:nixos/nixpkgs/$unstable_revision" \
  --override-input nixpkgs-stable "github:nixos/nixpkgs/$stable_revision"
