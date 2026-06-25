#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# deploy-landing-page.sh
#
# Local one-shot deploy for the bear-adventure landing page.
#
# What it does:
#   1. Builds the Next.js static export in bear_adventure_landing_page/.
#   2. Uploads the build as a tarball to a tmp path on the server.
#   3. On the server: extracts into a fresh release dir
#         /var/www/bearappqr.lotus.hosted-temp.com/releases/<UTC-ts>-<sha7>/htdocs/
#      and atomically flips the `current` symlink.
#   4. Prunes old releases (keeping the most recent KEEP_RELEASES).
#
# Requires:
#   - VPN access (the host is only reachable over the iO VPN)
#   - SSH key at ~/.ssh/io_key_2 (or override via -i)
#   - Local node + npm + tar
#
# Usage:
#   scripts/deploy/deploy-landing-page.sh
#   scripts/deploy/deploy-landing-page.sh --skip-build   # use existing out/
#   scripts/deploy/deploy-landing-page.sh --dry-run      # build + show plan
# -----------------------------------------------------------------------------

set -euo pipefail

# -----------------------------------------------------------------------------
# Defaults (override via flags or env vars)
# -----------------------------------------------------------------------------
: "${SSH_HOST:=web.prod.lotus.cloud.intracto.com}"
: "${SSH_USER:=bearappqr}"
: "${SSH_KEY:=$HOME/.ssh/io_key_2}"
: "${REMOTE_ROOT:=/var/www/bearappqr.lotus.hosted-temp.com}"
: "${KEEP_RELEASES:=5}"

SKIP_BUILD=0
DRY_RUN=0

# -----------------------------------------------------------------------------
# Paths
# -----------------------------------------------------------------------------
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
APP_DIR="${REPO_ROOT}/bear_adventure_landing_page"
OUT_DIR="${APP_DIR}/out"

# -----------------------------------------------------------------------------
# Pretty logging
# -----------------------------------------------------------------------------
if [[ -t 1 ]]; then
    BOLD=$'\033[1m'; GREEN=$'\033[32m'; YELLOW=$'\033[33m'; RED=$'\033[31m'; RESET=$'\033[0m'
else
    BOLD=""; GREEN=""; YELLOW=""; RED=""; RESET=""
fi

log()  { printf '%s==>%s %s\n' "${BOLD}${GREEN}" "${RESET}" "$*"; }
warn() { printf '%s==> WARN:%s %s\n' "${BOLD}${YELLOW}" "${RESET}" "$*"; }
die()  { printf '%s==> ERROR:%s %s\n' "${BOLD}${RED}" "${RESET}" "$*" >&2; exit 1; }

# -----------------------------------------------------------------------------
# CLI parsing
# -----------------------------------------------------------------------------
usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Options:
  --skip-build      Skip 'npm ci' + 'npm run build' (use existing out/)
  --dry-run         Build + show plan, but do not touch the server
  -i KEY            SSH key (default: ${SSH_KEY})
  --host HOST       SSH host (default: ${SSH_HOST})
  --user USER       SSH user (default: ${SSH_USER})
  --keep N          How many releases to keep on server (default: ${KEEP_RELEASES})
  --help            Show this help
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --skip-build) SKIP_BUILD=1; shift ;;
        --dry-run)    DRY_RUN=1; shift ;;
        -i)           SSH_KEY="$2"; shift 2 ;;
        --host)       SSH_HOST="$2"; shift 2 ;;
        --user)       SSH_USER="$2"; shift 2 ;;
        --keep)       KEEP_RELEASES="$2"; shift 2 ;;
        --help|-h)    usage; exit 0 ;;
        *)            die "Unknown option: $1 (try --help)" ;;
    esac
done

[[ -d "${APP_DIR}" ]] || die "App dir not found: ${APP_DIR}"
[[ -r "${SSH_KEY}" ]] || die "SSH key not readable: ${SSH_KEY}"
command -v tar >/dev/null || die "tar not found"

SSH_OPTS=(-i "${SSH_KEY}" -o BatchMode=yes -o ServerAliveInterval=30)
SSH_TARGET="${SSH_USER}@${SSH_HOST}"

# -----------------------------------------------------------------------------
# Identify what we're deploying
# -----------------------------------------------------------------------------
cd "${REPO_ROOT}"
git_sha="$(git rev-parse --short=7 HEAD 2>/dev/null || echo nogit)"
git_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo nogit)"
git_dirty=""
if ! git diff --quiet HEAD -- "${APP_DIR}" 2>/dev/null; then
    git_dirty="-dirty"
fi
release_id="$(date -u '+%Y%m%d%H%M%S')-${git_sha}${git_dirty}"

log "Repo:     ${REPO_ROOT}"
log "App:      bear_adventure_landing_page (branch=${git_branch}, sha=${git_sha}${git_dirty})"
log "Release:  ${release_id}"
log "Target:   ${SSH_TARGET}:${REMOTE_ROOT}"
[[ "${git_dirty}" == "-dirty" ]] && warn "You have uncommitted changes in ${APP_DIR}"

# -----------------------------------------------------------------------------
# Build
# -----------------------------------------------------------------------------
if (( SKIP_BUILD )); then
    log "Skipping build (--skip-build)"
    [[ -d "${OUT_DIR}" ]] || die "out/ does not exist; cannot --skip-build"
else
    log "Installing dependencies (npm ci)"
    ( cd "${APP_DIR}" && npm ci )

    log "Building (npm run build)"
    ( cd "${APP_DIR}" && npm run build )
fi

[[ -d "${OUT_DIR}" ]]            || die "out/ not found after build: ${OUT_DIR}"
[[ -f "${OUT_DIR}/index.html" ]] || die "out/index.html not found — build looks empty"

out_size="$(du -sh "${OUT_DIR}" | awk '{print $1}')"
out_files="$(find "${OUT_DIR}" -type f | wc -l | awk '{print $1}')"
log "Built:    ${out_files} files (${out_size})"

# -----------------------------------------------------------------------------
# Pack tarball into a local tmp file
# -----------------------------------------------------------------------------
tmp_tarball="$(mktemp -t landing-page-deploy.XXXXXXXX).tar.gz"
trap 'rm -f "${tmp_tarball}"' EXIT

log "Packing build into tarball"
tar -czf "${tmp_tarball}" -C "${OUT_DIR}" .
tarball_size="$(du -sh "${tmp_tarball}" | awk '{print $1}')"
log "Tarball:  $(basename "${tmp_tarball}") (${tarball_size})"

# -----------------------------------------------------------------------------
# Dry run
# -----------------------------------------------------------------------------
release_dir="${REMOTE_ROOT}/releases/${release_id}"
release_htdocs="${release_dir}/htdocs"
current_link="${REMOTE_ROOT}/current"

if (( DRY_RUN )); then
    log "Dry run — would do on remote:"
    cat <<EOF
    1. upload tarball to ${SSH_TARGET}:/tmp/<tmp>.tar.gz
    2. mkdir -p ${release_htdocs}
    3. tar -xzf <tmp>.tar.gz -C ${release_htdocs}
    4. atomically flip ${current_link} -> ${release_dir}
    5. prune old releases in ${REMOTE_ROOT}/releases/, keeping ${KEEP_RELEASES}
EOF
    exit 0
fi

# -----------------------------------------------------------------------------
# Upload tarball
# -----------------------------------------------------------------------------
remote_tarball="/tmp/landing-page-deploy.${release_id}.$$.tar.gz"

log "Uploading tarball to ${SSH_TARGET}:${remote_tarball}"
scp -q "${SSH_OPTS[@]}" "${tmp_tarball}" "${SSH_TARGET}:${remote_tarball}"

# -----------------------------------------------------------------------------
# Run remote deploy
# -----------------------------------------------------------------------------
log "Activating release on remote"

# We pass these as env vars on the remote command line — easier to escape
# than embedding into the script body.
ssh "${SSH_OPTS[@]}" "${SSH_TARGET}" \
    REMOTE_ROOT="${REMOTE_ROOT}" \
    RELEASE_ID="${release_id}" \
    KEEP_RELEASES="${KEEP_RELEASES}" \
    REMOTE_TARBALL="${remote_tarball}" \
    'bash -s' <<'REMOTE'
set -euo pipefail

: "${REMOTE_ROOT:?}"
: "${RELEASE_ID:?}"
: "${KEEP_RELEASES:?}"
: "${REMOTE_TARBALL:?}"

RELEASE_DIR="${REMOTE_ROOT}/releases/${RELEASE_ID}"
RELEASE_HTDOCS="${RELEASE_DIR}/htdocs"
CURRENT_LINK="${REMOTE_ROOT}/current"

# Always clean up the uploaded tarball.
trap 'rm -f "${REMOTE_TARBALL}"' EXIT

# Refuse to overwrite an existing release dir.
if [[ -e "${RELEASE_DIR}" ]]; then
    echo "Release dir already exists: ${RELEASE_DIR}" >&2
    exit 1
fi

mkdir -p "${RELEASE_HTDOCS}"
tar -xzf "${REMOTE_TARBALL}" -C "${RELEASE_HTDOCS}"

if [[ ! -f "${RELEASE_HTDOCS}/index.html" ]]; then
    echo "Release looks empty: no index.html in ${RELEASE_HTDOCS}" >&2
    rm -rf "${RELEASE_DIR}"
    exit 1
fi

# Atomically flip the current symlink.
TMP_LINK="${CURRENT_LINK}.new.$$"
ln -sfn "${RELEASE_DIR}" "${TMP_LINK}"
mv -Tf "${TMP_LINK}" "${CURRENT_LINK}"

# Prune old releases: keep KEEP_RELEASES newest, never delete the one we
# just promoted.
mapfile -t releases < <(find "${REMOTE_ROOT}/releases" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
total=${#releases[@]}
if (( total > KEEP_RELEASES )); then
    prune=$((total - KEEP_RELEASES))
    current_target="$(readlink -f "${CURRENT_LINK}")"
    for rel in "${releases[@]:0:${prune}}"; do
        path="${REMOTE_ROOT}/releases/${rel}"
        if [[ "${path}" == "${current_target}" ]]; then
            continue
        fi
        echo "Pruning ${rel}"
        rm -rf "${path}"
    done
fi

echo "OK: ${CURRENT_LINK} -> $(readlink -f "${CURRENT_LINK}")"
REMOTE

log "Deploy OK"
log "Live: https://bearappqr.lotus.hosted-temp.com/"
