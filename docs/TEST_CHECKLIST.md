# PLP Persistence Test Checklist

Use this checklist after packing a new `plp_persistence.pbo`.

## Single Player or Editor

1. Launch Arma 3 with CBA and `@PLP_Persistence`.
2. Open the VR test mission in Eden.
3. Place a player, one vehicle, and one supply crate.
4. Start the mission.
5. Move the player away from the start position.
6. Put a rifle with a partially loaded magazine into the crate.
7. Put a backpack into the crate, then put at least one item inside the backpack.
8. Run a server save:

```sqf
[] remoteExecCall ["PLP_fnc_saveAll", 2];
```

9. Restart the mission.
10. Confirm the player position, vehicle position, crate position, rifle, magazine ammo state, backpack, and backpack contents restored.
11. Confirm restored crate items can be removed and moved normally.
12. Delete the crate you are looking at:

```sqf
[cursorObject] remoteExecCall ["PLP_fnc_deleteObjectAndSave", 2];
```

13. Save again, restart the mission, and confirm the crate does not reappear.

## Local Dedicated Server

1. Start the server with `-noBattlEye` and `BattlEye = 0`.
2. Join with the client using the same PLP build and a compatible CBA version.
3. Wait for RPT lines showing:

```text
[PLP] [INFO] Initializing persistence
[PLP] [INFO] Logistics load complete
```

4. Move the player and modify crate cargo.
5. Save:

```sqf
[] remoteExecCall ["PLP_fnc_saveAll", 2];
```

6. Wait for:

```text
[PLP] [INFO] Save complete
```

7. Disconnect and reconnect.
8. Confirm player state and logistics state restored.
9. Confirm restored crate cargo can be removed.
10. Stop and restart the dedicated server.
11. Reconnect and repeat the same restore checks.

## Expected RPT Signals

- `Loaded profileNamespace state` shows nonzero records after a successful save.
- `Logistics load complete` has `skipped = 0` for clean saved data.
- `Reapplied logistics cargo` has `skipped = 0` for clean reconnect/JIP cargo reapply.
- `Save complete` shows expected player and object counts.

