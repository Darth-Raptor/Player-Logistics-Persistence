/*
    Returns serializable state for a unit.
*/
params ["_unit"];

private _vehicle = objectParent _unit;
private _vehicleId = "";
if (!isNull _vehicle) then {
    _vehicleId = _vehicle getVariable ["PLP_persistenceId", ""];
};

createHashMapFromArray [
    ["posASL", getPosASL _unit],
    ["dir", getDir _unit],
    ["vectorUp", vectorUp _unit],
    ["loadout", getUnitLoadout _unit],
    ["damage", damage _unit],
    ["stance", stance _unit],
    ["vehicleId", _vehicleId],
    ["timestamp", serverTime]
]
