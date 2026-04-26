/*
    Registers CBA settings before mission init.
*/

[
    "PLP_saveInterval",
    "SLIDER",
    ["Save interval", "Seconds between automatic persistence saves."],
    ["PLP Persistence", "General"],
    [30, 600, 120, 0],
    true
] call CBA_fnc_addSetting;

[
    "PLP_keyByMissionPbo",
    "CHECKBOX",
    ["Key by mission PBO", "Use the mission PBO/source name for persistence so data carries across missions with the same PBO name."],
    ["PLP Persistence", "General"],
    true,
    true
] call CBA_fnc_addSetting;

[
    "PLP_logEnabled",
    "CHECKBOX",
    ["Enable RPT logging", "Write PLP persistence events to the Arma RPT log."],
    ["PLP Persistence", "Debug"],
    false,
    true
] call CBA_fnc_addSetting;

[
    "PLP_logLevel",
    "LIST",
    ["Log level", "Controls how much PLP detail is written when RPT logging is enabled."],
    ["PLP Persistence", "Debug"],
    [["ERROR", "WARN", "INFO", "DEBUG"], ["Error", "Warning", "Info", "Debug"], 2],
    true
] call CBA_fnc_addSetting;

[
    "PLP_persistPlayerPosition",
    "CHECKBOX",
    ["Persist player position", "Save and restore player position and direction."],
    ["PLP Persistence", "Players"],
    true,
    true
] call CBA_fnc_addSetting;

[
    "PLP_persistPlayerDamage",
    "CHECKBOX",
    ["Persist player damage", "Save and restore player damage."],
    ["PLP Persistence", "Players"],
    true,
    true
] call CBA_fnc_addSetting;
