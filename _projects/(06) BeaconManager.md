---
name: Beacon Manager
slug: beacon-manager
tools: [TypeScript, Fastify, Next.js, React, Mantine, PostgreSQL, Prisma, Zod, JWT, Turborepo, ESP32, ESP-IDF, PlatformIO, FreeRTOS, C++, BLE, I2C, OTA, Docker]
image:
description: Beacon Manager is an IoT platform that covers the whole path from firmware to dashboard — provisioning devices over Bluetooth, collecting their telemetry and managing the fleet from a web panel.<br><br> The firmware is ESP-IDF on ESP32; the platform is a Fastify and Next.js monorepo over PostgreSQL.
external_url:
---

# Beacon Manager

**Beacon Manager** is the IoT platform behind IA.PURU's "data from the physical world" thesis. It is two repositories that only make sense together: the **firmware that runs on the device** and the **platform that provisions, monitors and updates a fleet of them**.

The [Carlota Weather Station](/projects/carlota) is the first public deployment of this stack.

## The firmware

Written against **ESP-IDF with PlatformIO** — not the Arduino framework — on FreeRTOS, targeting three boards: ESP32 WROOM-32, ESP32-S3 DevKitC-1 and ESP32-CAM.

- **Provisioning over BLE GATT** with an HMAC-SHA256 challenge-response handshake, so a device is claimed by its owner and not by whoever is standing nearest to it.
- **Configuration in NVS**, fetched from the platform and persisted across reboots.
- **OTA updates with a SHA-256 integrity check** — a device that receives a corrupted image refuses it rather than bricking itself.
- **Sensors over I2C** — the BME280 for temperature, humidity and pressure.
- Plus BLE beacon scanning, relay and actuator control, an RGB status LED, and camera capture on the ESP32-CAM.

## The platform

A pnpm + Turborepo monorepo:

- **Backend** — Fastify with Zod-validated contracts, exposing one API for devices (HTTP Basic, polled by the firmware for its configuration) and another for humans.
- **Admin panel** — Next.js + React with Mantine, for registering devices, watching what they report and pushing configuration down.
- **Database** — Prisma over PostgreSQL 16, modelling devices, their configuration and their environment readings.
- **Auth** — JWT with Google OAuth and TOTP two-factor, because a panel that can flash firmware onto a fleet deserves a second factor.
- **Deployment** — Docker Compose for local development, PM2 behind Nginx in production.

## What I did

Both ends, and the protocol between them:

- The firmware architecture — a static manager pattern with BLE provisioning, NVS-backed configuration, OTA and the sensor drivers;
- The device API contract, and the security model that lets a device authenticate without shipping a shared secret in the binary;
- The Fastify backend, the Prisma schema and the migration path;
- The admin panel, including the two-factor flow;
- The public environment-data feature that the weather station is built on.
