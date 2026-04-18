---
name: CriarMusicas
tools: [Next.js, React, TypeScript, Node.js, Express, PostgreSQL, Drizzle ORM, TailwindCSS, OpenAI, Whisper, GPT, Stripe, FFmpeg, Turborepo, PM2]
image: /assets/images/criarmusicas-logo.png
description: CriarMusicas.com.br is a web application that generates personalized AI-powered songs for loved ones.<br><br> Users record a story about their relationship and the platform turns it into a unique song using AI for transcription, lyrics and music generation.
---

# CriarMusicas

**CriarMusicas**  is a web application I built to generate **personalized AI-powered songs** for loved ones. The user records a story about their relationship, and the platform turns it into a unique song — lyrics and melody included.

{% include elements/figure.html image="/assets/images/criarmusicas-logo.png" caption="Músicas para o Mozão — sua história de amor, sua trilha sonora." %}

## How it works

1. **Record**: the user types the name of a person and records an audio telling the story of the relationship.
2. **Compose the music**: the AI pipeline uses the information provided to create a full song, and **FFmpeg** stitches custom jingles into the final track.
3. **Share**: the finished song is delivered to the user, ready to be shared with their loved one.

## Architecture

The project is organized as a **Turborepo** monorepo with a clear split between backend and frontend:

- **Frontend** — Next.js 15 + React + TypeScript, styled with TailwindCSS and internationalized with `next-intl` for multi-language support.
- **Backend** — Node.js + Express + TypeScript, using **Drizzle ORM** on top of **PostgreSQL**.
- **Payments** — Stripe integration with a credit system, plus a free trial mode that delivers watermarked songs.
- **Auth** — OAuth login flows for a frictionless sign-up.
- **Audio pipeline** — all glued together with FFmpeg for post-processing.
- **Deployment** — PM2 process manager running on AWS Lightsail, with automated deploy scripts and reverse proxy configuration (Nginx / Apache).

## What I did

I designed and implemented the whole product end-to-end:

- Product definition, UX and visual identity;
- Monorepo setup with Turborepo and shared packages;
- Backend API, database schema and migrations (Drizzle + PostgreSQL);
- Integration with AI apis
- Audio processing pipeline with FFmpeg (intro/outro jingles, watermarking);
- Credit system and Stripe billing, including the free-trial flow;
- Frontend in Next.js with i18n and responsive design;
- Deploy automation on AWS Lightsail with PM2 and zero-downtime reloads.

Check it out at <https://criarmusicas.com.br>
