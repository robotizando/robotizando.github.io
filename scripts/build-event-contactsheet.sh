#!/usr/bin/env bash
#
# Builds a single self-contained HTML contact sheet of candidate thumbnail images
# for every event in _events/, so the images can be picked by eye.
#
# The source archive lives outside the repo (an external drive), so this is a
# one-off curation aid rather than part of the site build.
#
# Usage:
#   scripts/build-event-contactsheet.sh [output.html]
#
# Requires: ImageMagick (`convert`), base64.

set -euo pipefail

SRC="${EVENTS_ARCHIVE:-/media/phantor/VeeFilesRepo/Eventos Daniel}"
OUT="${1:-/tmp/event-contactsheet.html}"
MAX_PER_EVENT=6
THUMB_WIDTH=400

[[ -d "$SRC" ]] || { echo "Archive not found: $SRC" >&2; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# slug|Display name|source folder(s), colon-separated
# Folders match the archive layout; duplicates and (copy) folders are left out.
EVENTS=$(cat <<'LIST'
campus-party-brasil|Campus Party Brasil|Campus Party 2009:Campus Party 2011:Campus Party 2012:Campus Party 2014:Campus Party 2015:Campus Party 2017
latinoware|Latinoware|Latinoware 2011:Latinoware 2012:Latinoware 2013:Latinoware 2014:Latinoware 2015
fisl|FISL|FISL 13 - 2012:FISL 14 - 2013:FISL 15 - 2014:FISL 16 - 2015:FISL 17 -  2016
fgsl|FGSL|FGSL - 2014:FGSL - 2015:FGSL - 2016:FGSL - 2017
tdc|TDC|TDC2015 - São Paulo:TDC2016 - PoA:TDC2016 - São Paulo:TDC2017 - Floripa
mostratec|Mostratec|Mostratec 2012:Mostratec 2013:Mostratec 2014:Mostratec 2016
intel-iot-roadshow|Intel IoT Roadshow|Intel IoT Roadshow 2014:Intel IoT Roadshow 2015:Intel IoT novembro-2015:Intel IoT marco-2016
meditec|MEDITEC|Meditec 2014:Meditec 2015:MEDITEC 2016
h2hc|H2HC|H2Hc:H2HC_2017:H2HC 2018
flisol|FLISOL|FLISOL Guarulhos 2016:FLISOL 2018 - Espirito Santo
def-con|DEF CON|0 - DEFCON 2018
arduino-day|Arduino Day|Arduino Day 2016
imasters-7masters|iMasters 7Masters|iMaster 7masters 3DPrinting
inside-3d-printing|Inside 3D Printing|Inside 3d Printing
sesc-bauru-virada-nerd|SESC Bauru Virada Nerd|SESC Bauru Virada Nerd 2015
ufopa|UFOPA|UFOPA 2014
if-macae|IF Macaé|IF Macaé
oficina-para-inclusao-digital|Oficina para Inclusão Digital|11 Oficina para Inclusão Digital 2012
desafio-marista|Desafio Marista|5 Desafio Marista 2012
semana-de-engenharia-usp-sao-carlos|Semana de Engenharia USP São Carlos|18 Semana de Engenharia USP SC
winter-challenge|Winter Challenge|Winter Challenge 2007
sebrae-roraima|SEBRAE Roraima|Roraima SEBRAE
ifg-goiania|IFG Goiânia|Palestra Goiania:Oficina no IFG
renesas-synergy|Renesas Synergy|Renesas Synergy
upgrade-robotics|Upgrade Robotics|Upgrade Robotics
LIST
)

{
  cat <<'HEAD'
<title>Speaking Archive Contact Sheet</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,500;12..96,700&family=JetBrains+Mono:wght@400;500&family=Source+Sans+3:ital,wght@0,400;0,600;1,400&display=swap">
<style>
  /* Palette grounded in the subject: soldermask green on cool slate-green neutrals. */
  :root {
    --bg: #f6f8f6;
    --surface: #ffffff;
    --surface-2: #eef2ee;
    --line: #dae1db;
    --fg: #171d19;
    --muted: #5f6a63;
    --accent: #1f6f4a;
    --accent-ink: #ffffff;
    --accent-soft: #e2efe7;
  }
  @media (prefers-color-scheme: dark) {
    :root:not([data-theme="light"]) {
      --bg: #12160f;
      --surface: #1a1f1b;
      --surface-2: #212822;
      --line: #2e372f;
      --fg: #e5ebe6;
      --muted: #97a29a;
      --accent: #58c08b;
      --accent-ink: #10160f;
      --accent-soft: #1d2b23;
    }
  }
  :root[data-theme="dark"] {
    --bg: #12160f;
    --surface: #1a1f1b;
    --surface-2: #212822;
    --line: #2e372f;
    --fg: #e5ebe6;
    --muted: #97a29a;
    --accent: #58c08b;
    --accent-ink: #10160f;
    --accent-soft: #1d2b23;
  }

  * { box-sizing: border-box; }
  body {
    background: var(--bg);
    color: var(--fg);
    margin: 0;
    padding: 3rem 1.25rem 8rem;
    font-family: "Source Sans 3", ui-sans-serif, system-ui, -apple-system, sans-serif;
    font-size: 16px;
    line-height: 1.55;
    -webkit-font-smoothing: antialiased;
  }
  .wrap { max-width: 1180px; margin: 0 auto; display: flex; flex-direction: column; gap: 2.5rem; }

  header { display: flex; flex-direction: column; gap: .5rem; }
  .eyebrow {
    font-family: "JetBrains Mono", ui-monospace, Menlo, monospace;
    font-size: .72rem; letter-spacing: .13em; text-transform: uppercase; color: var(--accent);
  }
  h1 {
    font-family: "Bricolage Grotesque", ui-sans-serif, system-ui, sans-serif;
    font-weight: 700; font-size: clamp(1.75rem, 4vw, 2.4rem); line-height: 1.1;
    margin: 0; text-wrap: balance; letter-spacing: -.015em;
  }
  .lede { color: var(--muted); margin: 0; max-width: 64ch; }
  .lede strong { color: var(--fg); font-weight: 600; }

  .events { display: flex; flex-direction: column; gap: 2.25rem; }
  section { display: flex; flex-direction: column; gap: .85rem; border-top: 1px solid var(--line); padding-top: 1.5rem; }
  .head { display: flex; flex-wrap: wrap; align-items: baseline; gap: .6rem; }
  h2 {
    font-family: "Bricolage Grotesque", ui-sans-serif, system-ui, sans-serif;
    font-weight: 500; font-size: 1.15rem; margin: 0; letter-spacing: -.01em;
  }
  .slug {
    font-family: "JetBrains Mono", ui-monospace, Menlo, monospace;
    font-size: .74rem; color: var(--muted); background: var(--surface-2);
    padding: .1rem .4rem; border-radius: 4px;
  }
  .state { margin-left: auto; font-size: .8rem; color: var(--muted); }
  section.done .state { color: var(--accent); font-weight: 600; }

  .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: .85rem; }
  figure {
    margin: 0; background: var(--surface); border: 1px solid var(--line); border-radius: 10px;
    overflow: hidden; cursor: pointer; display: flex; flex-direction: column;
    transition: border-color .15s ease, box-shadow .15s ease, transform .15s ease;
  }
  figure:hover { border-color: var(--accent); transform: translateY(-2px); }
  figure:focus-visible { outline: 2px solid var(--accent); outline-offset: 3px; }
  figure.picked { border-color: var(--accent); box-shadow: inset 0 0 0 2px var(--accent); }
  figure img { display: block; width: 100%; height: 155px; object-fit: cover; }
  figcaption {
    padding: .5rem .6rem; font-family: "JetBrains Mono", ui-monospace, Menlo, monospace;
    font-size: .68rem; line-height: 1.4; color: var(--muted); word-break: break-all; flex: 1;
  }
  figure.picked figcaption { color: var(--fg); background: var(--accent-soft); }

  .none { color: var(--muted); font-style: italic; margin: 0; }

  #tally {
    position: fixed; left: 0; right: 0; bottom: 0; z-index: 10;
    background: var(--surface); border-top: 1px solid var(--line);
    padding: .8rem 1.25rem; display: flex; align-items: center; gap: 1rem;
  }
  #tally .inner { max-width: 1180px; margin: 0 auto; width: 100%; display: flex; align-items: center; gap: 1rem; }
  #count {
    font-family: "JetBrains Mono", ui-monospace, Menlo, monospace; font-size: .8rem;
    font-variant-numeric: tabular-nums; background: var(--accent); color: var(--accent-ink);
    padding: .25rem .55rem; border-radius: 5px; white-space: nowrap;
  }
  #picks {
    font-family: "JetBrains Mono", ui-monospace, Menlo, monospace; font-size: .72rem;
    color: var(--muted); overflow-x: auto; white-space: nowrap; flex: 1;
  }
  @media (prefers-reduced-motion: reduce) {
    * { transition: none !important; }
    figure:hover { transform: none; }
  }
</style>
<div class="wrap">
<header>
  <p class="eyebrow">25 events &middot; 2007–2018</p>
  <h1>Pick one thumbnail per event</h1>
  <p class="lede">Candidates pulled from the archive on the external drive, banners and
  posters first. <strong>Click an image to select it</strong> — the running list at the
  bottom of the page is what to send back, and I will crop, convert and commit them.
  Events with nothing usable keep a text-only card.</p>
</header>
<div class="events">
HEAD

  while IFS='|' read -r slug title folders; do
    [[ -z "$slug" ]] && continue
    echo "<section data-slug=\"${slug}\"><div class=\"head\"><h2>${title}</h2><span class=\"slug\">${slug}</span><span class=\"state\">not picked</span></div><div class=\"grid\">"

    # Gather candidates: banners/posters/logos first, then the largest photos.
    : > "$TMP/cands"
    IFS=':' read -ra dirs <<< "$folders"
    for d in "${dirs[@]}"; do
      [[ -d "$SRC/$d" ]] || continue
      find "$SRC/$d" -maxdepth 3 -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -size +40k \
        \( -iname "*banner*" -o -iname "*cartaz*" -o -iname "*logo*" \
           -o -iname "*convite*" -o -iname "*programa*" \) 2>/dev/null >> "$TMP/cands" || true
    done
    for d in "${dirs[@]}"; do
      [[ -d "$SRC/$d" ]] || continue
      find "$SRC/$d" -maxdepth 3 -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -size +150k \
        2>/dev/null | sort >> "$TMP/cands" || true
    done

    n=0
    while IFS= read -r img; do
      [[ $n -ge $MAX_PER_EVENT ]] && break
      convert "$img" -auto-orient -resize "${THUMB_WIDTH}>" -quality 70 \
              "$TMP/t.jpg" 2>/dev/null || continue
      b64=$(base64 -w0 "$TMP/t.jpg")
      rel=${img#"$SRC/"}
      printf '<figure tabindex="0" role="button" aria-pressed="false" data-path="%s"><img src="data:image/jpeg;base64,%s" alt=""><figcaption>%s</figcaption></figure>\n' \
             "$rel" "$b64" "$rel"
      n=$((n+1))
    done < <(awk '!seen[$0]++' "$TMP/cands")

    [[ $n -eq 0 ]] && echo '<p class="none">No usable image in the archive — card stays text-only.</p>'
    echo "</div></section>"
  done <<< "$EVENTS"

  cat <<'FOOT'
</div>
</div>
<div id="tally">
  <div class="inner">
    <span id="count">0 / 0 picked</span>
    <span id="picks">Nothing picked yet.</span>
  </div>
</div>
<script>
  var sections = Array.prototype.slice.call(document.querySelectorAll('section[data-slug]'))
                      .filter(function (s) { return s.querySelector('figure'); });

  function refresh() {
    var picks = [];
    sections.forEach(function (section) {
      var chosen = section.querySelector('figure.picked');
      section.classList.toggle('done', !!chosen);
      section.querySelector('.state').textContent = chosen ? 'picked' : 'not picked';
      if (chosen) { picks.push(section.dataset.slug + ' = ' + chosen.dataset.path); }
    });
    document.getElementById('count').textContent = picks.length + ' / ' + sections.length + ' picked';
    document.getElementById('picks').textContent = picks.length ? picks.join('   |   ') : 'Nothing picked yet.';
  }

  function toggle(figure) {
    var already = figure.classList.contains('picked');
    figure.closest('section').querySelectorAll('figure.picked').forEach(function (other) {
      other.classList.remove('picked');
      other.setAttribute('aria-pressed', 'false');
    });
    if (!already) {
      figure.classList.add('picked');
      figure.setAttribute('aria-pressed', 'true');
    }
    refresh();
  }

  document.querySelectorAll('figure[data-path]').forEach(function (figure) {
    figure.addEventListener('click', function () { toggle(figure); });
    figure.addEventListener('keydown', function (event) {
      if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); toggle(figure); }
    });
  });

  refresh();
</script>
FOOT
} > "$OUT"

echo "Wrote $OUT ($(du -h "$OUT" | cut -f1))"
