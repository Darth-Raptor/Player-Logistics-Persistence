/*
    Returns normalized player persistence data with current schema fields.
*/
params ["_data"];

if !(_data isEqualType createHashMap) exitWith {createHashMap};

private _normalized = +_data;
_normalized set ["recordType", _normalized getOrDefault ["recordType", "player"]];
_normalized set ["schemaVersion", _normalized getOrDefault ["schemaVersion", 1]];
_normalized set ["lastWrite", _normalized getOrDefault ["lastWrite", _normalized getOrDefault ["timestamp", serverTime]]];

_normalized
