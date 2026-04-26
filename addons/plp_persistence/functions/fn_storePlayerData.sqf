/*
    Server stores player state in memory; saveAll flushes it to disk.
*/
if (!isServer) exitWith {};
params ["_uid", "_data"];

if (_uid isEqualTo "" || {!(_data isEqualType createHashMap)}) exitWith {};

PLP_playerData set [_uid, _data];

["DEBUG", "Stored player data", createHashMapFromArray [
    ["uid", _uid],
    ["players", count PLP_playerData]
]] call PLP_fnc_log;
