# Waylaid Crate Advisor

Calculates the Auctionator-based fill cost for every WoW Forever Waylaid Crate, and compares it to the crate's AH sell price so you can decide whether to fill-and-turn-in or just vendor/sell the crate.

## Features

- **Tooltip overlay** — hover any Waylaid Crate to see a per-item breakdown of fill costs + profit/loss vs. AH sell price
- **Bag summary** — `/crates` opens a window listing every crate in your bags with individual and grand totals
- `/crates id` — hover an item and run this to print its item ID (useful for updating crate IDs)

<img width="1108" height="824" alt="WaylaidCrateAdvisor screenshot" src="https://github.com/user-attachments/assets/63b0f302-ffd8-4620-b9c0-adbf20379cab" />

## Supported crates

| Tier        | Subtiers |
|-------------|----------|
| Apprentice  | Curiosities, Herbs, Ore, Textiles, Parts, Fabrics, Ingots |
| Journeyman  | Curiosities, Herbs, Ore, Textiles, Parts, Fabrics, Ingots |
| Expert      | Curiosities, Earthly Herbs, Flowering Herbs, Ore, Textiles, Parts, Fabrics, Ingots |

## Installation

Copy the `WaylaidCrateAdvisor/` folder to:
```
World of Warcraft/_classic_/Interface/AddOns/
```
Then `/reload` or restart.

## Auctionator requirement

Auctionator must be installed and you should run a scan before using this addon.
The addon reads prices from `AUCTIONATOR_PRICING_MODEL_5` (Auctionator's saved variable).
Items without scan data are flagged with `⚠`.

## Updating crate item IDs

The crate item IDs in `WCA.CRATE_ID_TO_NAME` are estimates — WoW Forever may use different IDs.
To find the real ID for any crate:

1. Hover the crate in your bags
2. Run `/crates id`
3. Update the matching entry in `WCA.CRATE_ID_TO_NAME`

## Commands

| Command | Effect |
|---|---|
| `/crates` | Open bag summary window |
| `/wca` | Same as above |
| `/crates id` | Print item ID of hovered item |
| `/crates help` | Show help |
