/*
    Updates one logistics record in PLP_logisticsData by id.
*/
if (!isServer) exitWith {};
[] call PLP_fnc_ensureServerState;
params ["_data"];

if !(_data isEqualType createHashMap) exitWith {};

_data = [_data] call PLP_fnc_normalizeLogisticsRecord;
private _validation = [_data] call PLP_fnc_validateLogisticsRecord;
if !(_validation getOrDefault ["valid", false]) exitWith {
    ["WARN", "Rejected logistics data", createHashMapFromArray [
        ["id", _validation getOrDefault ["id", ""]],
        ["class", _validation getOrDefault ["class", ""]],
        ["reason", _validation getOrDefault ["reason", "unknown"]]
    ]] call PLP_fnc_log;
};

private _id = _data getOrDefault ["id", ""];
if (_id isEqualTo "") exitWith {};

private _index = PLP_logisticsData findIf {(_x getOrDefault ["id", ""]) isEqualTo _id};
if (_index < 0) then {
    PLP_logisticsData pushBack _data;
} else {
    private _existing = [PLP_logisticsData select _index] call PLP_fnc_normalizeLogisticsRecord;
    if ((_data getOrDefault ["lastWrite", 0]) >= (_existing getOrDefault ["lastWrite", 0])) then {
        PLP_logisticsData set [_index, _data];
    };
};
