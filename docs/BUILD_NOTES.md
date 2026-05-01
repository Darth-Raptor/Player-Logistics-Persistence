# Build Notes

## Version 0.2.0

Base stabilization checkpoint: `48db80b Stabilize SQF persistence core`

Status:

- SQF persistence core stabilized with schema metadata, record normalization, and validation.
- Server-authoritative crate/container restore path verified on a local dedicated server.
- Vehicle, crate, player, nested backpack, removable restored cargo, and loaded magazine ammo persistence have been tested successfully.
- Category and class-name persistence disable settings were removed. Logistics persistence is now default-on, with per-object opt-out through `PLP_persistenceDisabled`.

## Version 0.2.1

Status:

- Fixed hosted dedicated server compatibility issue where HashMap normalization used unary copy syntax that could produce a scalar/NaN value before `getOrDefault`.
- Player and logistics normalization now updates the validated HashMap record directly.

## Version 0.2.2

Status:

- Added an idempotent server-state bootstrap used by save, load, clear, delete, store, upsert, and reconnect cargo reapply paths.
- Hardened admin/debug calls made before normal postInit state is available or during mission transitions.
- Removed another HashMap/array unary-copy use from `saveAll`.

## Version 0.2.3

Status:

- Disconnect handling now always flushes cached player data for a valid UID, even if the disconnecting unit is already unavailable.
- Added optional ACE self interaction: `Save & Exit`.
- `Save & Exit` sends the current local player state to the server, immediately flushes it to `profileNamespace`, then exits the player locally.
- Avoided adding a high-frequency player polling loop.

## Version 0.2.4

Status:

- Added optional ACE self interaction for logged-in admins: `Server Save & Exit`.
- The admin action asks the server to run `PLP_fnc_saveAll`, then exits only the requesting admin client after the server save completes.

## Version 0.2.5

Status:

- Fixed player-only `Save & Exit` clobbering logistics persistence with stale in-memory logistics data.
- `PLP_fnc_flushPlayerData` now writes only the player profile key. Full logistics writes remain owned by `PLP_fnc_saveAll` and admin `Server Save & Exit`.

## Version 0.2.6

Status:

- Renamed ACE interactions to `Player Save & Exit` and `Server Save & Exit`.
- Added ACE confirmation sub-actions before either exit flow executes.
- Excluded vehicles with AI crew from default logistics persistence unless explicitly forced persistent with `PLP_persistent`.

## Packing

When Arma and the dedicated server are closed, pack:

```powershell
robocopy 'C:\Users\JustF\Documents\New project 2\addons\plp_persistence' 'P:\plp_persistence' /MIR /XD .git /XF *.pbo *.log
& 'C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools\AddonBuilder\AddonBuilder.exe' 'P:\plp_persistence' 'C:\Users\JustF\Documents\New project 2\build' -packonly -clear -prefix=plp_persistence -project=P:\ -toolsDirectory='C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools'
```

Then copy the built PBO to:

```text
C:\Users\JustF\Documents\New project 2\@PLP_Persistence\addons\plp_persistence.pbo
C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Server\@PLP_Persistence\addons\plp_persistence.pbo
```

Verify:

```powershell
& 'C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools\BankRev\BankRev.exe' -lf 'C:\Users\JustF\Documents\New project 2\build\plp_persistence.pbo'
```

Do not replace the server PBO while the dedicated server is running.
