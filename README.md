# Zone Radar

### A Real-Time Contextual Encounter Diagnostic Tool for Pokémon Gen 2 Recomp

**Version:** 1.2.0

Zone Radar is a lightweight utility mod that allows you to check the wild encounters of your current location directly from your START menu. It dynamically reads the engine's encounter tables, adapting to the current map, your active movement state (Walking vs. Surfing), and the active time of day.

## Features

* **Contextual Scanning:** The radar knows what you are doing. If you are walking, it scans the local grass or cave tables. If you are actively using Surf, it automatically switches to reading the local water tables.
* **Time of Day Integration:** Fully respects Gen 2's Morning/Day/Night encounter shifts for terrestrial encounters.
* **Safe Pagination:** Formats the output into easily readable pages (max 2 lines per page) to respect the native GameBoy hardware text limits.

## How to Use

1. Open your **START menu**.
2. Choose the **ZONE RADAR** option (located right above SAVE).
3. A text box will appear displaying the encounter slots for your current area, including the exact spawn percentage, species name, and level. Press 'A' to scroll through the pages.

*Note: The radar cannot be used during battles. It currently reads terrestrial encounters (grass/caves) and aquatic encounters (surfing), but does not display fishing tables.*

## Installation

Download `zone_radar_gen2-1.2.0.zip` from the [Releases](https://github.com/zingamau-dev/zone_radar_gen2/releases) page, then in the game:

**Launcher → MODS → Import mod .zip**, or in a running game
**START → MODS → Import mod .zip**.

Because this mod includes its GitHub repository in the manifest, the launcher will keep it up to date automatically. When a new version is published, you can install it directly from the launcher's **Find mods** tab without having to manually download files again.