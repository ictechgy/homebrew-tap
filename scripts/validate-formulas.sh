#!/usr/bin/env bash
set -euo pipefail

if (($# == 0)); then
  echo "usage: $0 FORMULA [FORMULA ...]" >&2
  exit 2
fi

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1

tap_owner="codex"
run_id="${GITHUB_RUN_ID:-local}"
attempt="${GITHUB_RUN_ATTEMPT:-$$}"
tap_repo="verified-release-${run_id}-${attempt}-${RANDOM}"
tap_ref="${tap_owner}/${tap_repo}"

brew tap-new --no-git "$tap_ref" >/dev/null
tap_path="$(brew --repository)/Library/Taps/${tap_owner}/homebrew-${tap_repo}"
test -d "$tap_path/Formula"

for formula in cartograph gartograph rustograph; do
  cp "Formula/${formula}.rb" "$tap_path/Formula/${formula}.rb"
done

for formula in "$@"; do
  case "$formula" in
    cartograph|gartograph|rustograph) ;;
    *) echo "unsupported formula: $formula" >&2; exit 2 ;;
  esac
  brew install --build-from-source "${tap_ref}/${formula}"
  brew test "${tap_ref}/${formula}"
done
