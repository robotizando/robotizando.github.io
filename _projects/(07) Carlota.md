---
name: Carlota Weather Station
slug: carlota
tools: [Next.js, React, TypeScript, Mantine, Recharts, Fastify, PostgreSQL, Prisma, ESP32, BME280, I2C, PM2, Nginx]
image: /assets/images/projects/carlota.webp
description: A weather station of my own — an ESP32 with a BME280 sensor reporting temperature, humidity and pressure, with a public dashboard that anyone can open.<br><br> It is the first live deployment of the Beacon Manager platform, and the proof that the hardware-to-dashboard path actually closes.
external_url:
---

# Carlota Weather Station

**Carlota** is a weather station reporting live from the house it is named after. It measures **temperature, humidity and atmospheric pressure**, and publishes them on a dashboard that needs no login.

{% include elements/figure.html image="/assets/images/projects/carlota.webp" caption="Estação Meteorológica Carlota — dados de ambiente em tempo real." %}

## Why it exists

IA.PURU's argument is that owning the data collection is what makes applied AI worth anything. Carlota is that argument reduced to its smallest working form: a sensor we chose, on hardware we flashed, writing to a database we run, feeding a page we built. Every layer is ours, and the whole path is short enough to inspect.

It is also the first production deployment of [Beacon Manager](/projects/beacon-manager) — the platform stopped being a fleet-management abstraction and started having an actual device to manage.

## How it works

1. **The sensor** — a **BME280** wired over I2C at address `0x76` to an ESP32-S3 running the Beacon firmware.
2. **The device** — polls the platform for its configuration, reads the sensor on the interval it is told to use, and POSTs each reading to the backend.
3. **The store** — Fastify writes the readings to PostgreSQL through Prisma, timestamped both by the device and on arrival.
4. **The dashboard** — a Next.js app rendering three current-value cards plus time series over **24 hours, 48 hours and 5 days**, charted with Mantine Charts on Recharts.

The dashboard never talks to the backend directly from the browser: a server-side route proxies `/api/environment`, so the internal backend URL stays internal. There is no authentication on the public app, deliberately — the weather is not a secret.

## What I did

- Wired and mounted the station, and flashed the firmware;
- Added BME280 support and the public environment-data endpoint to the Beacon platform;
- Designed the dashboard, its time windows and its server-side proxy;
- Deployed it behind Nginx with PM2 on the IA.PURU infrastructure.

Check it out at <https://carlota.iapuru.com.br>
