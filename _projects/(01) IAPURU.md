---
name: IA.PURU
slug: iapuru
tools: [Node.js, Express, EJS, i18n, Nodemailer, Helmet, PM2, Nginx, GitHub Actions]
image: /assets/images/projects/iapuru.webp
description: IA.PURU — Inovação e Tecnologia is the company I co-founded to apply artificial intelligence on top of data we collect ourselves.<br><br> We build both the hardware that gathers data from the physical world and the software that consumes it, with a strong bias towards social impact.
external_url:
---

# IA.PURU

**IA.PURU — Inovação e Tecnologia** is the company I co-founded with **Laura Conde Tresca**. She brings the social impact and public policy side (ex-ARTIGO 19, CGI.br); I bring the technology and R&D side.

{% include elements/figure.html image="/assets/images/projects/iapuru.webp" caption="Aplicando inteligência artificial em soluções tecnológicas." %}

## The thesis

Generic models are trained on the same public data everyone else has. If the data is the same, the model is not the differentiator — so the differentiation has to come from **owning the collection**.

That is why IA.PURU builds both ends: the **hardware that collects data from the physical world** and the **software that turns it into decisions**. Data we gather ourselves is data nobody else has.

## What we do

- **Applied AI** — models running on proprietary data, not on someone else's scrape.
- **Consulting** — helping organizations figure out where AI actually earns its place.
- **Social impact** — our current contract is with [Instituto Auá](https://institutoaua.org.br), mapping sociobiodiversity enterprises.
- **Zero to One** — taking products from an idea to something in operation.
- **Hardware & IoT** — the sensors and devices that feed the models.
- **Observability and analytics** — instrumenting what we ship.

## What runs under this umbrella

The other projects on this page are the products IA.PURU has in operation, not in prototype:

- [CriarMusicas](/projects/criarmusicas) and [Criar Jingles](/projects/criarjingles) — AI music generation for people and for brands;
- [Jopoia](/projects/jopoia) — community-based tourism scheduling;
- [Beacon Manager](/projects/beacon-manager) — the IoT platform, firmware to dashboard;
- [Carlota Weather Station](/projects/carlota) — a live deployment of that platform.

## About the site

The institutional site itself is deliberately small: a server-rendered **Express + EJS** application with no database and no build step. All copy lives in JSON locale files, so the site ships in **four languages** — Portuguese, Spanish, English and French. Contact goes out through Nodemailer, Helmet handles the security headers, and deploys are a GitHub Actions workflow that rsyncs over SSH and reloads PM2 behind Nginx.

Check it out at <https://iapuru.com.br>
