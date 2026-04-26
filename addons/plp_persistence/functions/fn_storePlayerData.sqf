/*
    Server stores player state in memory; saveAll flushes it to disk.
*/
if (!isServer) exitWith {};
params ["_uid", "_data"];

if (_uid isEqualTo "" || {!(_data isEqualType createHashMap)}) exitWith {};

private _normalized = [_data] call PLP_fnc_normalizePlayerData;
private _validation = [_normalized] call PLP_fnc_validatePlayerData;
if !(_validation getOrDefault ["valid", false]) exitWith {
    ["WARN", "Rejected player data", createHashMapFromArray [
        ["uid", _uid],
        ["reason", _validation getOrDefault ["reason", "unknown"]]
    ]] call PLP_fnc_log;
};

PLP_playerData set [_uid, _normalized];

["DEBUG", "Stored player data", createHashMapFromArray [
    ["uid", _uid],
    ["players", count PLP_playerData]
]] call PLP_fnc_log;
