/*
    Returns true when an object should be included in logistics persistence.
*/
params ["_object"];

if (isNull _object) exitWith {false};
if (_object isKindOf "Bag_Base" && {!(_object getVariable ["PLP_persistent", false])}) exitWith {false};

private _category = [_object] call PLP_fnc_getObjectCategory;

if (_object getVariable ["PLP_persistent", false]) exitWith {true};
if (_category in ["cars", "armor", "air", "ships", "statics"]) then {
    private _aiCrew = (crew _object) select {!isPlayer _x};
    if (_aiCrew isNotEqualTo []) exitWith {false};
};

_category isNotEqualTo ""
