/*
    Applies saved state to a local player unit.
*/
params ["_unit", "_data"];

if (isNull _unit || {!local _unit} || {!alive _unit}) exitWith {};
if !(_data isEqualType createHashMap) exitWith {};

_unit setUnitLoadout (_data getOrDefault ["loadout", getUnitLoadout _unit]);

if (missionNamespace getVariable ["PLP_persistPlayerPosition", true]) then {
    _unit setDir (_data getOrDefault ["dir", getDir _unit]);
    _unit setVectorUp (_data getOrDefault ["vectorUp", vectorUp _unit]);
    _unit setPosASL (_data getOrDefault ["posASL", getPosASL _unit]);
};

if (missionNamespace getVariable ["PLP_persistPlayerDamage", true]) then {
    _unit setDamage (_data getOrDefault ["damage", damage _unit]);
};

private _stance = _data getOrDefault ["stance", ""];
if (_stance isEqualTo "PRONE") then {_unit playActionNow "PlayerProne";};
if (_stance isEqualTo "CROUCH") then {_unit playActionNow "PlayerCrouch";};
if (_stance isEqualTo "STAND") then {_unit playActionNow "PlayerStand";};
