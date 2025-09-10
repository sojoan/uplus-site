# One‑Click Pilot Automation (Windows)

This folder lets you automate **(a)** Stripe Payment Links, **(b)** signing, and **(c)** publishing the **Edge** site to GitHub Pages — with minimal manual work.

## Prereqs (once)
1) **Node.js 18+** (https://nodejs.org)
2) **Git** + **GitHub CLI** (`gh`) — `winget install Git.Git` and `winget install GitHub.cli`
3) **OpenSSL** (optional; if missing, the script will show how to install quickly)

## What it does
- Creates Stripe **Products + Prices + Payment Links** automatically.
- Injects the payment links into your local **Edge Pilot** pages.
- Generates RSA keys, **signs pricing.json**, and publishes **uplus-edge-pilot** to **GitHub Pages**.

## Quick Start (PowerShell)
Open PowerShell in this folder and run:

```powershell
# 1) Create Stripe payment links and inject into Edge Pilot
./run_stripe_and_inject.ps1 -StripeKey "sk_live_..." -OffersJson "..\AME_Suite_v15_1_Pilot\configs\pilot_mode.json" -EdgeFolder "..\UPlus_Edge_Pilot_v15_1"

# 2) Generate RSA keys, sign pricing.json, publish Edge to GitHub Pages
./publish_edge.ps1 -Owner "sojoan" -Repo "uplus-edge-pilot" -EdgeFolder "..\UPlus_Edge_Pilot_v15_1"
```

At the end, your Edge site will be live on GitHub Pages with working **Stripe Payment Links** and **signed prices**.
