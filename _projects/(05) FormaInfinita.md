---
name: Forma Infinita
slug: formainfinita
tools: [TypeScript, Next.js, React, Fastify, Prisma, SQLite, Zod, Turborepo, pnpm, Vitest, SSE, PM2, Nginx]
image: /assets/images/projects/formainfinita.webp
description: Forma Infinita is a generative art gallery with a single, permanent, globally shared artwork.<br><br> Every click, every page and every minute any visitor has ever spent on the site permanently alters the shape that the next visitor sees. It never resets and never converges.
external_url:
---

# Forma Infinita

**Forma Infinita** is an experimental art space where matter, technology, interaction and time meet. The works are not static objects — they are open systems that respond and transform.

The home page is the clearest case: it renders **one artwork, shared by everyone, computed from everything every visitor has ever done on the site**. Your clicks, your navigation, your scrolling and the minutes you spend there permanently change the shape that the next person will see. There is no reset button.

{% include elements/figure.html image="/assets/images/projects/formainfinita.webp" caption="Uma única obra, viva, compartilhada por todos os visitantes." %}

## How the form is generated

The shape is a closed polar curve summing harmonics over the prime orders 2, 3, 5, 7, 11 and 13. Each visitor is hashed to **exactly one** of those harmonics — that harmonic is their voice in the piece, and it is the only one they can push on.

Three rules keep it interesting rather than chaotic:

- **Decay** — the strength of a gesture falls off as the total interaction count grows. Early visitors shape the work far more than late ones, but a gesture never reaches zero. That is the literal sense of *infinita*: the form never settles.
- **Caps** — each amplitude is bounded, their sum is bounded, and the radius is clamped. No sequence of interactions, and no bot, can make the piece illegible.
- **Epochs** — every ten thousand interactions the amplitudes anneal by 15% and that cycle's drawing is archived. The archive at `/estados` is the piece's own memory.

## Architecture

A pnpm + Turborepo monorepo with a real frontend/backend split:

- **`packages/forma`** — the generative engine: pure, deterministic, zero dependencies, and **isomorphic**. The same code runs on the server, which holds the truth, and in the browser, which draws an optimistic response before the network answers. 25 tests cover determinism, the caps and legibility.
- **`apps/api`** — Fastify. State is held in memory, batch-flushed to SQLite every two seconds, and broadcast to open pages over **Server-Sent Events** only when it is actually dirty. Rate limiting is both per-minute and a gesture budget, so a script cannot shout over a person.
- **`apps/web`** — Next.js App Router. The live shape renders as stacked SVG layers with a rising luminous front, a deliberate nod to a 3D printer bed.
- **`packages/database`** — Prisma over SQLite, with the production database file kept **outside** the deploy directory. The deploy script refuses to run if it is not: the workflow publishes with `rsync --delete`, and a database inside the deploy path would be destroyed on every push, taking the artwork with it.
- **`packages/content`** — the gallery works are versioned Markdown validated with Zod at build time, so a malformed work breaks the build instead of a page.

## Privacy as a material

The piece needs to know that you are you across a session, and nothing else. So it stores exactly one random identifier in an httpOnly cookie. **No IP address, no user agent, no fingerprint, no third parties, no analytics.** The constraint is part of the work, not a compliance checkbox.

## The gallery

Alongside the live form, the site publishes physical and electronic installations — *Pac-Man Mesh*, a set of 3D-printed lamps talking over ESP-NOW, and *Remanescência*, an e-waste installation built on an ESP32-S3 with a captive portal. Publishing a work is a commit and a deploy; there is no admin panel and no upload form, on purpose.

## Status

Built and running, **not yet deployed to a public domain** — the site currently lives only on my machine and in the repo. When it goes up it will be at formainfinita.com.br.
