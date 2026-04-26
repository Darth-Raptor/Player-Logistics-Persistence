/*
    Assigns a persistence id to an object.
*/
params ["_object", ["_id", ""]];

if (isNull _object) exitWith {""};

if (_id isEqualTo "") then {
    _id = _object getVariable ["PLP_persistenceId", ""];
};

if (_id isEqualTo "") then {
    _id = [_object] call PLP_fnc_getDefaultObjectId;
};

_object setVariable ["PLP_persistenceId", _id, true];

_id
