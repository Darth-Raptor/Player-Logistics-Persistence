/*
    Returns true for clients logged in as server admin.
*/
if (!hasInterface) exitWith {false};

if !(isNil "BIS_fnc_admin") exitWith {
    (call BIS_fnc_admin) isEqualTo 2
};

serverCommandAvailable "#shutdown"
