/*
    Returns serializable state for a logistics object.
*/
params ["_object"];

private _id = [_object] call PLP_fnc_registerLogisticsObject;
private _category = [_object] call PLP_fnc_getObjectCategory;
private _cargoData = [_object] call PLP_fnc_collectCargoData;

createHashMapFromArray [
    ["id", _id],
    ["class", typeOf _object],
    ["category", _category],
    ["posASL", getPosASL _object],
    ["dir", getDir _object],
    ["vectorUp", vectorUp _object],
    ["damage", damage _object],
    ["fuel", fuel _object],
    ["locked", locked _object],
    ["weaponsCargo", _cargoData getOrDefault ["weaponsCargo", []]],
    ["magazinesCargo", _cargoData getOrDefault ["magazinesCargo", []]],
    ["itemsCargo", _cargoData getOrDefault ["itemsCargo", []]],
    ["backpacksCargo", _cargoData getOrDefault ["backpacksCargo", []]],
    ["nestedContainers", _cargoData getOrDefault ["nestedContainers", []]],
    ["vars", _object getVariable ["PLP_persistentVars", createHashMap]],
    ["timestamp", serverTime]
]
