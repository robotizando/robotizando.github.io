# Gerar o currículo em PDF

O currículo em PDF é gerado a partir da página `/resume/` deste site Jekyll
([`_layouts/resume.html`](../_layouts/resume.html), alimentada pelos dados em [`_data/`](../_data/)).

> **Por que é um passo local?** O GitHub Pages não executa o Chrome, então o PDF
> **não** é gerado no deploy. Ele é gerado localmente e commitado como asset estático
> em [`assets/cv/`](../assets/cv/). O botão "Download CV" em `/about/` aponta para esse arquivo.

## Pré-requisitos

- `bundle install` (Jekyll e dependências do `Gemfile`)
- `google-chrome` (ou `google-chrome-stable` / `chromium`) instalado

## Geração automática (recomendado)

```bash
./scripts/generate-cv-pdf.sh
```

O script sobe o Jekyll, aguarda o servidor, renderiza `/resume/` em PDF (A4) e salva em
`assets/cv/Daniel-Basconcello-Filho-CV.pdf`. A porta pode ser trocada com `PORT=5000 ./scripts/generate-cv-pdf.sh`.

## Geração manual (equivalente)

```bash
bundle exec jekyll serve --detach --port 4000

google-chrome --headless --disable-gpu --no-sandbox \
  --no-pdf-header-footer \
  --print-to-pdf="assets/cv/Daniel-Basconcello-Filho-CV.pdf" \
  http://localhost:4000/resume/

pkill -f "jekyll serve"
```

Alternativa sem linha de comando: abrir `http://localhost:4000/resume/` no navegador e usar
**Ctrl/Cmd + P → Salvar como PDF**, com tamanho **A4** e **sem cabeçalhos/rodapés**.

## Notas

- Tamanho A4 e margens vêm do CSS `@page` em [`_layouts/resume.html`](../_layouts/resume.html).
- O PDF deve ter texto **selecionável** (requisito para sistemas ATS) — confira copiando/colando.
- **Sempre regenere e recommite o PDF** após editar `_data/` (skills/timeline) ou o layout,
  caso contrário o PDF baixado pelo site ficará desatualizado.
