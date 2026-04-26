/*
    Validates player persistence data before apply/store.
*/
params ["_data"];

private _result = createHashMapFromArray [
    ["valid", false],
    ["reason", "unknown"]
];

if !(_data isEqualType createHashMap) exitWith {
    _result set ["reason", "not_hashmap"];
    _result
};

if ((_data getOrDefault ["recordType", "player"]) isNotEqualTo "player") exitWith {
    _result set ["reason", "wrong_record_type"];
    _result
};

if ((_data getOrDefault ["schemaVersion", 0]) isNotEqualTo 1) exitWith {
    _result set ["reason", "unsupported_schema"];
    _result
};

if !((_data getOrDefault ["loadout", []]) isEqualType []) exitWith {
    _result set ["reason", "invalid_loadout"];
    _result
};

private _pos = _data getOrDefault ["posASL", []];
if (!(_pos isEqualType []) || {count _pos < 3}) exitWith {
    _result set ["reason", "invalid_position"];
    _result
};

_result set ["valid", true];
_result set ["reason", "ok"];
_result
