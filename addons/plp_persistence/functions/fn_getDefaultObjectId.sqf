/*
    Builds a deterministic fallback id from class and placement.
*/
params ["_object"];

if (isNull _object) exitWith {""};

private _pos = getPosWorld _object;
format [
    "%1:%2:%3:%4",
    typeOf _object,
    round ((_pos select 0) * 100),
    round ((_pos select 1) * 100),
    round ((_pos select 2) * 100)
]
