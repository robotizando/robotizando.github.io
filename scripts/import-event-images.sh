#!/usr/bin/env bash
#
# Imports the chosen event thumbnails from the local archive into the repo.
#
# Reads scripts/event-images.tsv — one line per event:
#
#     slug<TAB>path relative to the archive root[<TAB>fit]
#
# and writes assets/images/events/<slug>.webp as an 800x600 card thumbnail.
# Lines starting with # and blank lines are ignored.
#
# `fit` controls how the source is made to fit 4:3:
#   cover   (default) fill the frame and centre-crop the overflow — right for photos
#   contain             letterbox the whole image over a blurred copy of itself —
#                       right for logos, posters and banners, whose artwork must not
#                       be cropped. The blurred backdrop reads correctly against both
#                       the light and dark card backgrounds of the theme.
#
# Pair with scripts/build-event-contactsheet.sh, which produces the candidate
# list to choose from.
#
# Usage:
#   scripts/import-event-images.sh [mapping.tsv]
#
# Requires: ImageMagick (`convert`).

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="${EVENTS_ARCHIVE:-/media/phantor/VeeFilesRepo/Eventos Daniel}"
MAP="${1:-$REPO/scripts/event-images.tsv}"
DEST="$REPO/assets/images/events"

[[ -f "$MAP" ]] || { echo "Mapping file not found: $MAP" >&2; exit 1; }
[[ -d "$SRC" ]] || { echo "Archive not found: $SRC" >&2; exit 1; }

mkdir -p "$DEST"

imported=0
while IFS=$'\t' read -r slug path fit; do
  [[ -z "${slug// }" || "${slug:0:1}" == "#" ]] && continue
  src="$SRC/$path"
  if [[ ! -f "$src" ]]; then
    echo "  MISSING  $slug — $path" >&2
    continue
  fi
  case "${fit:-cover}" in
    contain)
      convert "$src" -auto-orient \
              \( -clone 0 -resize 800x600^ -gravity center -extent 800x600 \
                 -blur 0x20 -modulate 100,55 \) \
              \( -clone 0 -resize 800x600 \) \
              -delete 0 -gravity center -composite \
              -quality 82 "$DEST/$slug.webp"
      echo "  ok       $slug.webp (contain)"
      ;;
    *)
      convert "$src" -auto-orient -resize 800x600^ -gravity center -extent 800x600 \
              -quality 82 "$DEST/$slug.webp"
      echo "  ok       $slug.webp"
      ;;
  esac
  imported=$((imported+1))
done < "$MAP"

echo "Imported $imported image(s) into assets/images/events/"
echo "Remember to set 'image: /assets/images/events/<slug>.webp' in the matching _events/ file."
