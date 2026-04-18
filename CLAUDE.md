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
- [_projects/](_projects/) — portfolio project cards. Filename order controls display order (hence the `(1)`, `(2)`, ... prefixes). Permalinks are `/projects/:name`.
- [_posts_not_published/](_posts_not_published/) — drafts parked outside the `_posts` collection so Jekyll ignores them. Move to `_posts/` to publish.
- [pages/](pages/) — standalone pages ([about.md](pages/about.md), [blog.html](pages/blog.html), [projects.html](pages/projects.html), etc.). Each sets its own `permalink` in front matter.
- [_data/](_data/) — YAML data files (`hard-skills.yml`, `timeline.yml`, ...) consumed by `about.md` via `site.data.<filename>` and rendered through theme includes like `about/skills.html`, `about/timeline.html`.

### Includes and theme
[_includes/](_includes/) contains this repo's overrides of theme partials (`landing.html`, `navbar.html`, `head.html`, subfolders `about/`, `blog/`, `projects/`, `elements/`). When something renders unexpectedly, check whether an override exists here before assuming it's theme-level — theme defaults come from the `portfolYOU` gem, not this repo. To see the theme's source, inspect `bundle info --path github-pages` and the portfolYOU repo.

### Site config
[_config.yml](_config.yml) wires everything together: `remote_theme`, the `projects` collection with its permalink, nav exclusions, author info, Google Analytics, and Buy-Me-a-Coffee. Change `baseurl` only if hosting under a subpath (it is empty because the site is served at the apex of a custom domain).

## Content conventions

- Project markdown files use front matter keys `name`, `tools` (array), `image`, `description` (HTML allowed), and optional `external_url`. See [(1) Robotizando.md](_projects/(1)%20Robotizando.md) as a template.
- The poems post ([_posts/2025-02-11-my-poems.md](_posts/2025-02-11-my-poems.md)) is Portuguese text content; preserve accents and diacritics when editing.
- Do not edit `_site/`, `.jekyll-cache/`, `.sass-cache/`, or `vendor/` — all are build output and git-ignored.
