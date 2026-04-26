# Build Notes

## Version 0.2.0

Base stabilization checkpoint: `48db80b Stabilize SQF persistence core`

Status:

- SQF persistence core stabilized with schema metadata, record normalization, and validation.
- Server-authoritative crate/container restore path verified on a local dedicated server.
- Vehicle, crate, player, nested backpack, removable restored cargo, and loaded magazine ammo persistence have been tested successfully.
- Category and class-name persistence disable settings were removed. Logistics persistence is now default-on, with per-object opt-out through `PLP_persistenceDisabled`.

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
