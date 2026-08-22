---
name: Criar Jingles
slug: criarjingles
tools: [Next.js, React, TypeScript, Node.js, Express, PostgreSQL, Drizzle ORM, TailwindCSS, next-intl, OpenAI, FFmpeg, Stripe, Pagar.me, Turborepo, PM2]
image: /assets/images/projects/criarjingles.webp
description: Criar Jingles turns a brand briefing into a finished commercial jingle — copyright-free, royalty-free and ready for radio, social media or WhatsApp.<br><br> It is the business-facing sibling of CriarMusicas, sharing the same generation engine but with its own prompts, plans and credit wallet.
external_url:
---

# Criar Jingles

**Criar Jingles** is the business-facing product built on the same engine as [CriarMusicas](/projects/criarmusicas). Where CriarMusicas turns a personal story into a song for someone you love, Criar Jingles turns a **brand briefing into a commercial jingle** — no studio, no production company, no ECAD.

{% include elements/figure.html image="/assets/images/projects/criarjingles.webp" caption="Crie jingles comerciais livre de copyright." %}

## How it works

1. **Describe your brand**: the client fills in the name, the key message and the goal of the jingle. It takes less than two minutes.
2. **The AI writes the lyrics**: the pipeline produces commercial copy oriented to the business, not a love letter — this is where the prompts diverge from CriarMusicas.
3. **The jingle is ready**: delivered as an MP3, ready for radio, social media or WhatsApp, with no royalties and no licensing paperwork.

## Architecture

Criar Jingles is **not a separate codebase**. It lives in the same Turborepo monorepo as CriarMusicas and reuses the whole backend:

- **Shared** — the Express + TypeScript backend, the Drizzle/PostgreSQL schema, the AI generation pipeline, the FFmpeg audio post-processing and the payment integrations (Stripe and Pagar.me).
- **Separate** — its own Next.js frontend app, its own prompts, its own pricing plans, and a **segregated credit wallet**: credits bought for jingles are a distinct product type and cannot be spent on personal songs.
- **Admin** — both products are managed from the same admin panel, with dedicated jingle views.

Running two products off one backend was the point of the split: a single generation engine, two audiences, two commercial models.

## What I did

- Specified the product and the way it diverges from CriarMusicas — brand-oriented lyrics, commercial framing, a different buyer;
- Built the separate frontend app in Next.js with `next-intl` and zustand;
- Designed the segregated credit wallet so the two products share infrastructure without sharing balances;
- Wrote the jingle-specific prompt chain on top of the shared generation pipeline;
- Extended the admin panel and the transactional e-mail templates to cover both brands;
- Set up the deployment as another PM2 process alongside the existing ones.

Check it out at <https://criarjingles.com.br>
