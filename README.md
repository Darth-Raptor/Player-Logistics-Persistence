# PLP Persistence

Player and logistics persistence for Arma 3 using CBA.

This is a source addon intended to be packed into a PBO. It persists:

- Player position, direction, loadout, damage, stance, and vehicle assignment.
- Eden and Zeus placed logistics objects by default.
- Object position, direction, damage, fuel, cargo inventories, nested container inventories, and custom variables.

The default storage backend is `profileNamespace` on the dedicated server or host. It does not require extDB.

## Folder Layout

```text
addons/
  plp_persistence/
    config.cpp
    functions/
```

Pack `addons/plp_persistence` into `plp_persistence.pbo` with Arma 3 Tools, Addon Builder, HEMTT, or your preferred PBO workflow.

The source addon includes `$PBOPREFIX$` so function paths resolve as `\plp_persistence\...` after packing.

## Requirements

- CBA_A3

## Mission Setup

The addon starts automatically.

Objects placed in Eden or Zeus are persistent by default.

To force a specific object to be persistent:

```sqf
this setVariable ["PLP_persistent", true, true];
```

To exclude a specific object from automatic persistence:

```sqf
this setVariable ["PLP_persistenceDisabled", true, true];
```

To force a specific persistence id, useful for editor-placed objects:

```sqf
this setVariable ["PLP_persistenceId", "base_ammo_truck_01", true];
this setVariable ["PLP_persistent", true, true];
```

## CBA Settings

Settings are registered in CBA Addon Options under `PLP Persistence`.

- General: save interval and mission-key mode.
- Debug: optional RPT logging and log level.
- Players: player position and damage persistence.

The default key mode uses `worldName` plus `missionNameSource`, so persistence carries over when the mission PBO/source name is the same. Disable `Key by mission PBO` to fall back to `missionName`.

If your mission uses a restrictive `CfgRemoteExec`, whitelist these functions:

```cpp
class PLP_fnc_applyPlayerData { allowedTargets = 1; };
class PLP_fnc_requestPlayerLoad { allowedTargets = 2; };
class PLP_fnc_storePlayerData { allowedTargets = 2; };
class PLP_fnc_flushPlayerData { allowedTargets = 2; };
class PLP_fnc_handleServerSaveAndExit { allowedTargets = 2; };
class PLP_fnc_saveAndExitComplete { allowedTargets = 1; };
class PLP_fnc_saveAll { allowedTargets = 2; };
class PLP_fnc_clearMissionData { allowedTargets = 2; };
```

When ACE Interaction is loaded, players get a self interaction named `Save & Exit`. It saves the local player state, flushes it on the server, then exits that client from the mission.

Logged-in admins also get `Server Save & Exit`. It runs a full server save, then exits only the requesting admin client after the save completes.

## Admin Utilities

Clear all saved data for the current mission:

```sqf
[] remoteExecCall ["PLP_fnc_clearMissionData", 2];
```

Force a save:

```sqf
[] remoteExecCall ["PLP_fnc_saveAll", 2];
```

When `Enable RPT logging` is turned on in CBA settings, PLP writes lines like this to the Arma RPT:

```text
[PLP] [INFO] Save complete | [...]
```

Delete the object you are looking at and save a deletion tombstone:

```sqf
[cursorObject] call PLP_fnc_deleteObjectAndSave;
```

## Notes

- Persistence keys include `worldName` and, by default, `missionNameSource`, so saves bleed across missions with the same PBO/source name on the same map.
- Editor and Zeus placed logistics objects are saved by default. Individual objects can opt out with `PLP_persistenceDisabled`.
- Backpacks and other containers inside saved objects have their internal cargo restored recursively.
- Dynamically spawned logistics objects should receive a stable `PLP_persistenceId` if you want them to reload as the same object after restart.
- Deleted objects are saved as deleted tombstones on the next save so Eden-placed objects do not reappear at their original positions.
- Saved records are normalized and validated before restore. Invalid player or logistics records are skipped and logged when PLP RPT logging is enabled.
- For a public server, move destructive admin utilities behind your admin framework before exposing them to players.
