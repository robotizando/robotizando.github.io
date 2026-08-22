#!/usr/bin/env bash
#
# Captures the project thumbnails by screenshotting each project's site.
#
# Reads scripts/project-images.tsv — one line per project:
#
#     slug<TAB>url[<TAB>flags]
#
# and writes assets/images/projects/<slug>.webp as an 800x600 card thumbnail,
# matching the format used by assets/images/events/*.webp.
# Lines starting with # and blank lines are ignored.
#
# `flags` is a comma-separated list:
#   insecure    pass --ignore-certificate-errors — for hosts whose TLS cert has
#               expired or is self-signed. The shot still gets taken; the site's
#               certificate problem is not this script's to fix.
#   delay=N     how many seconds to give the page (default 3). Raise it for
#               dashboards that paint only once their data arrives.
#   stream      the page holds a connection open (SSE, websocket) and so never
#               goes network-idle. Shoot on a wall clock instead of waiting for
#               idle, which would hang forever.
#
# The viewport is 1440x1080 — 4:3, so the downscale to 800x600 never crops.
#
# Usage:
#   scripts/capture-project-shots.sh [mapping.tsv]
#   scripts/capture-project-shots.sh --only jopoia      # re-shoot a single slug
#
# Requires: Google Chrome (`google-chrome`) and ImageMagick (`convert`).

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$REPO/assets/images/projects"
CHROME="${CHROME:-google-chrome}"

ONLY=""
if [[ "${1:-}" == "--only" ]]; then
  ONLY="${2:-}"
  shift 2
fi
MAP="${1:-$REPO/scripts/project-images.tsv}"

[[ -f "$MAP" ]] || { echo "Mapping file not found: $MAP" >&2; exit 1; }
command -v "$CHROME" >/dev/null || { echo "Chrome not found: $CHROME" >&2; exit 1; }
command -v convert >/dev/null || { echo "ImageMagick 'convert' not found" >&2; exit 1; }

mkdir -p "$DEST"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

captured=0
failed=0
while IFS=$'\t' read -r slug url flags; do
  [[ -z "${slug// }" || "${slug:0:1}" == "#" ]] && continue
  [[ -n "$ONLY" && "$slug" != "$ONLY" ]] && continue

  delay=3
  extra=()
  case "${flags:-}" in
    *insecure*) extra+=(--ignore-certificate-errors) ;;
  esac
  if [[ "${flags:-}" =~ delay=([0-9]+) ]]; then
    delay="${BASH_REMATCH[1]}"
  fi

  # How long to wait is the whole game here, and the two flags are not
  # interchangeable:
  #   --virtual-time-budget waits for the network to go idle, so it captures
  #     dashboards that fetch their data after load. But a page holding an open
  #     connection never goes idle, and Chrome waits forever.
  #   --timeout shoots at the load event, capping the wait. Safe for streaming
  #     pages, but too early for anything that paints from a later fetch.
  # Default to the first; the `stream` flag opts into the second.
  if [[ "${flags:-}" == *stream* ]]; then
    wait_flag=(--timeout=$((delay * 1000)))
  else
    wait_flag=(--virtual-time-budget=$((delay * 1000)))
  fi

  # Belt to those suspenders, since --virtual-time-budget can still hang.
  shot="$TMP/$slug.png"
  if ! timeout $((delay + 25)) \
       "$CHROME" --headless --disable-gpu --hide-scrollbars \
                 --no-sandbox --disable-dev-shm-usage \
                 --window-size=1440,1080 \
                 "${wait_flag[@]}" \
                 --screenshot="$shot" "${extra[@]}" "$url" >/dev/null 2>&1 \
     || [[ ! -s "$shot" ]]; then
    echo "  FAILED   $slug — $url" >&2
    failed=$((failed+1))
    continue
  fi

  convert "$shot" -resize 800x600^ -gravity north -extent 800x600 \
          -quality 82 "$DEST/$slug.webp"
  echo "  ok       $slug.webp"
  captured=$((captured+1))
done < "$MAP"

echo "Captured $captured thumbnail(s) into assets/images/projects/"
[[ $failed -gt 0 ]] && echo "$failed failed — those projects keep an empty 'image:' in _projects/" >&2
echo "Remember to set 'image: /assets/images/projects/<slug>.webp' in the matching _projects/ file."
