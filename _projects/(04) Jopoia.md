---
name: Jopoia
slug: jopoia
tools: [HTML5, CSS3, Vanilla JavaScript, Node.js, pnpm, Design Tokens, Accessibility, UX Research]
image: /assets/images/projects/jopoia.webp
description: Jopoia is a scheduling system for community-based tourism — trails, boat rides, craft workshops, meals and lodging offered by traditional communities on the São Paulo coast.<br><br> Built to be used on a phone by people who are not computer users. Currently a navigable prototype, made to validate the flow before choosing a stack.
external_url:
---

# Jopoia

**Jopoia** organizes the agenda of *Turismo de Base Comunitária* (community-based tourism) on the north coast of São Paulo — the trails, boat rides, basketry workshops, community lunches and lodging that **caiçara**, **quilombola** and **Guarani** communities offer to visitors themselves.

The name is Guarani: *jo-poí*, "open hands" — reciprocity, giving and receiving in the same gesture.

{% include elements/figure.html image="/assets/images/projects/jopoia-agenda.webp" caption="A agenda de reservas da comunidade — quem atende, quem já confirmou, e o dia reservado para a maricultura." %}

> **Status:** this phase is a **navigable prototype in static HTML** — no framework, no backend, no database. It exists to validate the visual language and the flow with the communities themselves *before* committing to any stack. No form saves anything yet.

## The problem

The community already has everything: the trail, the boat, the cook, the person who weaves the basket. What it does not have is one place that knows **what is offered, who provides it, what it costs this season, and who is booked on Saturday**.

The constraint that shaped every screen: it has to be usable on a phone, by people who are not computer users, without looking like office software.

## How it works

The prototype models four actors:

- **Visitor** — sees what the community offers and asks for a date.
- **Community admin** — the person in the community who runs the agenda: registers activities, providers and prices, and closes quotes.
- **Provider** — the individual who actually delivers the service, and who signs in to see **only what is theirs**.
- **Global admin** — IA.PURU, managing the communities themselves as tenants.

Domain rules worth naming, because they came out of how the communities actually work:

- **Seasonal pricing** with four tiers — weekday, weekend, low season and high season — auto-suggested from the date but always overridable by the admin, because the community has the last word on its own price.
- **A confirmation deadline of ten minutes** for the provider to accept a job, configurable per community and always spelled out literally in the message, never left implicit.
- **Blocked community days** — dates when the community is not receiving anyone, like the maricultura harvest, are simply unavailable.
- **Reports carry no monetary values** by design.

The second app in the repo prototypes the **WhatsApp confirmation flow**, because that is the channel providers already use. Today the provider replies through canned buttons; the flow is designed so that AI can later interpret a free-text "pode deixar comigo" as a confirmation.

## Multi-tenant by design

Each community is a tenant with its own accent color, driven by a single design token. The visual language — sand, ink, *serra* green, *juçara* purple — came from the reference photography, not from a UI kit.

## What I did

- Field framing of the problem with the communities and the four-actor model;
- The whole design system as CSS custom properties, with a documented token file as the single source of truth;
- Every screen of the prototype in semantic HTML — `<dialog>`, `<details>`, ARIA tabs — written to **WCAG AA** as an explicit constraint, not an afterthought;
- The quote engine, seasonal price logic and provider-selection rules in vanilla JavaScript, no dependencies;
- The messaging flow prototype, including where AI enters in the next phase.

Deliberately no framework, no bundler and no database — at this stage those would be decisions made too early.
