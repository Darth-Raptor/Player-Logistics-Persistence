/*
    Returns true when an object should be included in logistics persistence.
*/
params ["_object"];

if (isNull _object) exitWith {false};
if (_object getVariable ["PLP_persistenceDisabled", false]) exitWith {false};
if (_object isKindOf "Bag_Base" && {!(_object getVariable ["PLP_persistent", false])}) exitWith {false};

private _category = [_object] call PLP_fnc_getObjectCategory;
if (_category isNotEqualTo "" && {!([_category] call PLP_fnc_isCategoryEnabled)}) exitWith {false};

if (_object getVariable ["PLP_persistent", false]) exitWith {true};

_category isNotEqualTo ""
