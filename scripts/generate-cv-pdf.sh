#!/usr/bin/env bash
set -euo pipefail

# Gera o currículo em PDF (A4) a partir da página /resume/ do site Jekyll.
# Uso: ./scripts/generate-cv-pdf.sh
#
# Pré-requisitos:
#   - bundle install  (Jekyll e dependências)
#   - google-chrome / google-chrome-stable instalado

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/assets/cv/Daniel-Basconcello-Filho-CV.pdf"
PORT="${PORT:-4000}"

# Detecta o binário do Chrome
CHROME="$(command -v google-chrome || command -v google-chrome-stable || command -v chromium || true)"
if [ -z "$CHROME" ]; then
  echo "ERRO: google-chrome/chromium não encontrado no PATH." >&2
  exit 1
fi

cd "$ROOT"
mkdir -p "$(dirname "$OUT")"

echo "==> Subindo o Jekyll em http://localhost:$PORT ..."
bundle exec jekyll serve --detach --port "$PORT" >/dev/null

cleanup() { pkill -f "jekyll serve" >/dev/null 2>&1 || true; }
trap cleanup EXIT

# Aguarda o servidor responder na rota /resume/
echo "==> Aguardando o servidor responder ..."
for _ in $(seq 1 60); do
  if curl -sf "http://localhost:$PORT/resume/" >/dev/null; then break; fi
  sleep 1
done

echo "==> Gerando PDF ..."
"$CHROME" --headless --disable-gpu --no-sandbox \
  --no-pdf-header-footer \
  --print-to-pdf="$OUT" \
  "http://localhost:$PORT/resume/"

echo "==> PDF gerado em: $OUT"
