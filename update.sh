#!/usr/bin/env bash
set -euo pipefail

# Update nixpkgs and nixpkgs-stable flake inputs to stable, Hydra-built commits.
#
# This script queries Hydra evaluations to find commits that:
#   1. Have been built by Hydra (so binary caches are available)
#   2. Are at least DAYS old (default: 7 days) to ensure stability
#
# Usage:
#   ./update.sh           # Use default 7-day age
#   DAYS=14 ./update.sh   # Use custom age threshold
#
# The script updates two flake inputs:
#   - nixpkgs: from nixpkgs-unstable channel (Hydra jobset: trunk-combined)
#   - nixpkgs-stable: from nixos-25.05 channel (Hydra jobset: release-25.05)

# Configuration
DAYS="${DAYS:-7}"

# Map channel names to Hydra jobset names
get_hydra_jobset() {
  local channel="$1"
  case "$channel" in
    nixpkgs-unstable)
      echo "trunk-combined"
      ;;
    nixos-25.05)
      echo "release-25.05"
      ;;
    nixos-24.11)
      echo "release-24.11"
      ;;
    *)
      echo "$channel"
      ;;
  esac
}

# Function to find and select a stable commit for a given channel using Hydra
find_stable_commit() {
  local channel="$1"
  local input_name="$2"

  echo "" >&2
  echo "=== Processing $input_name ($channel) ===" >&2
  echo "Finding a stable Hydra-built commit that is at least $DAYS days old..." >&2

  # Calculate cutoff timestamp (Unix epoch)
  local cutoff_timestamp=$(date -d "$DAYS days ago" +%s)
  local cutoff_date=$(date -d "$DAYS days ago" +%Y-%m-%d)
  echo "Cutoff date: $cutoff_date (timestamp: $cutoff_timestamp)" >&2

  # Get Hydra jobset name
  local jobset=$(get_hydra_jobset "$channel")
  echo "Using Hydra jobset: nixos/$jobset" >&2

  # Fetch evaluations from Hydra
  # We'll paginate through multiple pages to find an old enough evaluation
  local page=1
  local max_pages=10
  local selected_commit=""
  local selected_date=""

  while [[ $page -le $max_pages ]] && [[ -z "$selected_commit" ]]; do
    echo "  Fetching page $page of Hydra evaluations..." >&2
    local html=$(curl -fsSL "https://hydra.nixos.org/jobset/nixos/${jobset}/evals?page=${page}" 2>/dev/null || echo "")

    if [[ -z "$html" ]]; then
      echo "  Failed to fetch Hydra evaluations" >&2
      break
    fi

    # Extract commits and timestamps from the HTML table
    # Format: data-timestamp="1761284781" ... <tt>7def831</tt>
    local evals=$(echo "$html" | grep -oP 'data-timestamp="\K\d+|<tt>\K[^<]+' | paste -d, - -)

    if [[ -z "$evals" ]]; then
      echo "  No more evaluations found" >&2
      break
    fi

    # Parse each evaluation and check if it's old enough
    while IFS=, read -r timestamp commit; do
      if [[ "$timestamp" =~ ^[0-9]+$ ]] && [[ -n "$commit" ]] && [[ ! "$commit" =~ ^[0-9]+$ ]]; then
        if [[ "$timestamp" -lt "$cutoff_timestamp" ]]; then
          selected_commit="$commit"
          selected_date=$(date -d "@$timestamp" '+%Y-%m-%d %H:%M:%S')
          echo "  Found suitable commit: $commit from $selected_date" >&2
          break 2
        fi
      fi
    done <<< "$evals"

    page=$((page + 1))
  done

  if [[ -z "$selected_commit" ]]; then
    echo "Warning: Could not find a Hydra evaluation older than $DAYS days." >&2
    echo "  Falling back to current channel commit..." >&2
    local channel_url="https://channels.nixos.org/${channel}"
    selected_commit=$(curl -fsSL "${channel_url}/git-revision" 2>/dev/null || echo "")
    if [[ -z "$selected_commit" ]]; then
      echo "Error: Could not fetch current commit from $channel_url" >&2
      return 1
    fi
    selected_date="current"
  fi

  echo "Selected commit: $selected_commit" >&2
  echo "Commit date: $selected_date" >&2

  # Return the selected commit (to stdout)
  echo "$selected_commit"
}

echo "Updating nixpkgs inputs..."
echo "================================"

# Find stable commits for both channels
unstable_commit=$(find_stable_commit "nixpkgs-unstable" "nixpkgs")
stable_commit=$(find_stable_commit "nixos-25.05" "nixpkgs-stable")

# Update the flake with both commits
echo ""
echo "=== Updating flake.lock ==="
echo "Updating nixpkgs to: $unstable_commit"
echo "Updating nixpkgs-stable to: $stable_commit"

nix flake lock \
  --override-input nixpkgs "github:nixos/nixpkgs/${unstable_commit}" \
  --override-input nixpkgs-stable "github:nixos/nixpkgs/${stable_commit}"

echo ""
echo "Successfully updated flake.lock!"
echo "You can now rebuild your system with: sudo nixos-rebuild switch --flake .#<hostname>"

