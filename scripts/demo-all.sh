#!/usr/bin/env bash
# Runs pronto-rubycritic locally against every scenario in configs/
# and prints the output grouped by scenario.
#
#   Usage:  scripts/demo-all.sh [base-ref]
#   Default base-ref is 'origin/main'.
#
# Pre-requisites:
#   bundle install     # pulls pronto-rubycritic from GitHub
#   git fetch origin   # so origin/main is a valid ref locally
set -e
BASE="${1:-origin/main}"
cd "$(git rev-parse --show-toplevel)"

section() {
  echo ""
  echo "═══════════════════════════════════════════════════════════════════"
  echo " $1"
  echo "═══════════════════════════════════════════════════════════════════"
}

run_with_config() {
  local config="$1"
  local label="$2"
  local stash=/tmp/.rubycritic-pronto.yml.stash
  [ -f .rubycritic-pronto.yml ] && cp .rubycritic-pronto.yml "$stash"
  if [ -z "$config" ]; then
    rm -f .rubycritic-pronto.yml
  else
    cp "$config" .rubycritic-pronto.yml
  fi

  echo ""
  echo "--- $label ---"
  echo "config:"
  [ -f .rubycritic-pronto.yml ] && sed 's/^/  /' .rubycritic-pronto.yml || echo "  (no config file)"
  echo ""
  echo "output:"
  bundle exec pronto run -r rubycritic -c "$BASE" 2>&1 \
    | grep -v "retry middleware" \
    | grep -v "^running \|^\." \
    | head -40 || true

  [ -f "$stash" ] && mv "$stash" .rubycritic-pronto.yml || true
}

run_with_env() {
  local label="$1"
  shift
  echo ""
  echo "--- $label ---"
  env "$@" bundle exec pronto run -r rubycritic -c "$BASE" 2>&1 \
    | grep -v "retry middleware" \
    | grep -v "^running \|^\." \
    | head -30 || true
}

section 'SCENARIO 00 — no config (all smells visible)'
run_with_config configs/00-empty.yml 'empty config'

section 'SCENARIO 01 — filter by reek.smell_types'
run_with_config configs/01-filter-by-smell-types.yml 'smell_types allow-list'

section 'SCENARIO 02 — reek.max_smells cap'
run_with_config configs/02-max-smells.yml 'max_smells: 3'

section 'SCENARIO 03 — flay.max_score threshold'
run_with_config configs/03-flay-threshold.yml 'flay.max_score: 30'

section 'SCENARIO 04 — flog.max_score threshold'
run_with_config configs/04-flog-threshold.yml 'flog.max_score: 10'

section 'SCENARIO 05 — flay/flog exclude patterns'
run_with_config configs/05-exclude-patterns.yml 'flay/flog.exclude globs'

section 'SCENARIO 06 — complexity.max drops whole modules'
run_with_config configs/06-complexity-max.yml 'complexity.max: 10'

section 'SCENARIO 07 — churn.max drops churn-heavy modules'
run_with_config configs/07-churn-max.yml 'churn.max: 5'

section 'SCENARIO 08 — corrupt YAML degrades gracefully'
run_with_config configs/08-corrupt.yml 'invalid YAML'

section 'SCENARIO 09 — YAML that parses to a non-Hash'
run_with_config configs/09-non-hash.yml 'YAML Symbol at root'

section 'SCENARIO 10 — severity override via env var (info)'
run_with_env 'PRONTO_RUBYCRITIC_SEVERITY_LEVEL=info' \
  PRONTO_RUBYCRITIC_SEVERITY_LEVEL=info

section 'SCENARIO 11 — legacy env var emits deprecation warning'
run_with_env 'PRONTO_REEK_SEVERITY_LEVEL=info (deprecated)' \
  PRONTO_REEK_SEVERITY_LEVEL=info

section 'SCENARIO 12 — debug mode prints backtrace on error'
run_with_env 'PRONTO_RUBYCRITIC_DEBUG=1' PRONTO_RUBYCRITIC_DEBUG=1

section 'SCENARIO 13 — GitHub formatter (HTML details)'
run_with_env 'GITHUB_ACTIONS=1 (forces GitHub style)' GITHUB_ACTIONS=1

section 'SCENARIO 14 — GitLab formatter (plain markdown)'
run_with_env 'GITLAB_CI=1 (forces GitLab style)' GITLAB_CI=1

section 'DONE — 15 scenarios, all covered'
