# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal portfolio site for Daniel Basconcello Filho, built as a **Jekyll** site hosted on **GitHub Pages** at `daniel.robotizando.com.br` (see [CNAME](CNAME)). It uses the `YoussefRaafatNasry/portfolYOU` remote theme — most layout/styling comes from the theme gem, not from this repo.

## Commands

Local development requires Ruby + Bundler:

```bash
bundle install                 # Install dependencies (first time)
bundle exec jekyll serve       # Serve locally at http://localhost:4000 with live reload
bundle exec jekyll build       # Build static site into _site/
```

There are no tests or linters configured. GitHub Pages builds the site automatically on push to `main`.

## Architecture

### Content model
Jekyll collections drive the content. When adding content, place files in the matching directory:

- [_posts/](_posts/) — blog posts. Filenames must be `YYYY-MM-DD-slug.md`; permalinks are `/blog/:title` (configured in [_config.yml](_config.yml)).
- [_projects/](_projects/) — portfolio project cards. Filename order controls display order (`(01)`, `(02)`, ... prefixes), but permalinks are `/projects/:title`, which resolves to the `slug` front matter key — so the numeric prefix stays out of the URL. Renumbering a file is therefore safe; changing its `slug` breaks the URL. Use two digits: Jekyll sorts by path, and `(10)` would sort before `(2)`.
- [_events/](_events/) — speaking, workshop and mentoring engagements, one file per event with every edition grouped inside it. Filename order controls display order (`(01)`, `(02)`, ... prefixes), but permalinks are `/events/:title`, which resolves to the `slug` front matter key — so the numeric prefix stays out of the URL. Renumbering a file is therefore safe; changing its `slug` breaks the URL.
- [_posts_not_published/](_posts_not_published/) — drafts parked outside the `_posts` collection so Jekyll ignores them. Move to `_posts/` to publish.
- [pages/](pages/) — standalone pages ([about.md](pages/about.md), [blog.html](pages/blog.html), [projects.html](pages/projects.html), etc.). Each sets its own `permalink` in front matter.
- [_data/](_data/) — YAML data files (`hard-skills.yml`, `timeline.yml`, ...) consumed by `about.md` via `site.data.<filename>` and rendered through theme includes like `about/skills.html`, `about/timeline.html`.

### Includes and theme
[_includes/](_includes/) contains this repo's overrides of theme partials (`landing.html`, `navbar.html`, `head.html`, subfolders `about/`, `blog/`, `projects/`, `events/`, `elements/`). When something renders unexpectedly, check whether an override exists here before assuming it's theme-level — theme defaults come from the `portfolYOU` gem, not this repo. To see the theme's source, inspect `bundle info --path github-pages` and the portfolYOU repo.

### Site config
[_config.yml](_config.yml) wires everything together: `remote_theme`, the `projects` collection with its permalink, nav exclusions, author info, Google Analytics, and Buy-Me-a-Coffee. Change `baseurl` only if hosting under a subpath (it is empty because the site is served at the apex of a custom domain).

## Content conventions

- Project markdown files use front matter keys `name`, `slug`, `tools` (array), `image`, `description` (HTML allowed), and optional `external_url`. Leave `external_url` empty to make the card open the local detail page and put the outbound link in the body instead. See [(02) CriarMusicas.md](_projects/(02)%20CriarMusicas.md) as a template. The same unquoted-scalar caveat as events applies to `description` — see below.
- Project thumbnails are screenshots of each project's own site: record the source URL in [scripts/project-images.tsv](scripts/project-images.tsv) and run [scripts/capture-project-shots.sh](scripts/capture-project-shots.sh), which shoots them with headless Chrome and writes `assets/images/projects/<slug>.webp` at 800×600 — the same format as the event thumbnails. The TSV carries per-project flags for TLS bypass, render delay and streaming pages; its comments record which projects need a local dev server running first. Note the older projects `(08)`–`(12)` predate this and keep ad-hoc images loose in `assets/images/`.
- Event markdown files use `name`, `slug`, `location`, `role`, `years` (array), `topics` (array), `image`, `description` (HTML allowed), and optional `external_url`. The card shows `location · N editions`, the topic badges and one badge per year; the body carries a `## <year>` section per edition. See [(01) Campus Party Brasil.md](_events/(01)%20Campus%20Party%20Brasil.md) as a template. Note that `description` is an unquoted YAML scalar — a `: ` inside it breaks the build, so use an em dash instead.
- Event thumbnails come from a photo archive kept outside the repo (an external drive, `EVENTS_ARCHIVE`, default `/media/phantor/VeeFilesRepo/Eventos Daniel`). [scripts/build-event-contactsheet.sh](scripts/build-event-contactsheet.sh) renders the candidates as one self-contained HTML page to pick from; record the picks in [scripts/event-images.tsv](scripts/event-images.tsv) and run [scripts/import-event-images.sh](scripts/import-event-images.sh) to crop them into `assets/images/events/`.
- The poems post ([_posts/2025-02-11-my-poems.md](_posts/2025-02-11-my-poems.md)) is Portuguese text content; preserve accents and diacritics when editing.
- Do not edit `_site/`, `.jekyll-cache/`, `.sass-cache/`, or `vendor/` — all are build output and git-ignored.
