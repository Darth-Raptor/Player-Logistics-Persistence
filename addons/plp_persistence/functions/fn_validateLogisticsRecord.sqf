/*
    Validates a logistics record before restore/save.
*/
params ["_record"];

private _result = createHashMapFromArray [
    ["valid", false],
    ["reason", "unknown"],
    ["id", ""],
    ["class", ""]
];

if !(_record isEqualType createHashMap) exitWith {
    _result set ["reason", "not_hashmap"];
    _result
};

private _id = _record getOrDefault ["id", ""];
private _class = _record getOrDefault ["class", ""];
_result set ["id", _id];
_result set ["class", _class];

if ((_record getOrDefault ["recordType", "logistics"]) isNotEqualTo "logistics") exitWith {
    _result set ["reason", "wrong_record_type"];
    _result
};

if ((_record getOrDefault ["schemaVersion", 0]) isNotEqualTo 1) exitWith {
    _result set ["reason", "unsupported_schema"];
    _result
};

if (_id isEqualTo "") exitWith {
    _result set ["reason", "missing_id"];
    _result
};

if (_class isEqualTo "") exitWith {
    _result set ["reason", "missing_class"];
    _result
};

if !(isClass (configFile >> "CfgVehicles" >> _class)) exitWith {
    _result set ["reason", "unknown_class"];
    _result
};

private _pos = _record getOrDefault ["posASL", []];
if (!(_record getOrDefault ["deleted", false]) && {(!(_pos isEqualType []) || {count _pos < 3})}) exitWith {
    _result set ["reason", "invalid_position"];
    _result
};

_result set ["valid", true];
_result set ["reason", "ok"];
_result
