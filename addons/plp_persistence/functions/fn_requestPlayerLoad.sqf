/*
    Server receives a player load request and sends saved state to the owning client.
*/
if (!isServer) exitWith {};
params ["_unit", "_uid"];

if (isNull _unit || {_uid isEqualTo ""}) exitWith {};

private _data = PLP_playerData getOrDefault [_uid, createHashMap];
if (count _data isEqualTo 0) exitWith {
    ["DEBUG", "No player data found", createHashMapFromArray [
        ["uid", _uid]
    ]] call PLP_fnc_log;
    [] spawn {
        sleep 2;
        [] call PLP_fnc_reapplyLogisticsCargo;
    };
};

_data = [_data] call PLP_fnc_normalizePlayerData;
private _validation = [_data] call PLP_fnc_validatePlayerData;
if !(_validation getOrDefault ["valid", false]) exitWith {
    ["WARN", "Skipped invalid player load data", createHashMapFromArray [
        ["uid", _uid],
        ["reason", _validation getOrDefault ["reason", "unknown"]]
    ]] call PLP_fnc_log;
};

["INFO", "Sending player data to client", createHashMapFromArray [
    ["uid", _uid],
    ["owner", owner _unit]
]] call PLP_fnc_log;

[_unit, _data] remoteExecCall ["PLP_fnc_applyPlayerData", owner _unit];

[] spawn {
    sleep 2;
    [] call PLP_fnc_reapplyLogisticsCargo;
};
