/*
    Stores one player record and immediately flushes persistence to disk.
*/
if (!isServer) exitWith {};
[] call PLP_fnc_ensureServerState;
params ["_uid", "_data", ["_name", ""]];

if (_uid isEqualTo "" || {!(_data isEqualType createHashMap)}) exitWith {
    ["WARN", "Rejected player flush request", createHashMapFromArray [
        ["uid", _uid],
        ["name", _name]
    ]] call PLP_fnc_log;
};

[_uid, _data] call PLP_fnc_storePlayerData;

profileNamespace setVariable [PLP_playersKey, PLP_playerData];
saveProfileNamespace;

["INFO", "Flushed player data", createHashMapFromArray [
    ["uid", _uid],
    ["name", _name],
    ["players", count PLP_playerData],
    ["logisticsTouched", false]
]] call PLP_fnc_log;
