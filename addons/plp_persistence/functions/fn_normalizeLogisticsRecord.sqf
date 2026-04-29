/*
    Returns a normalized logistics record with current schema fields.
*/
params ["_record"];

if !(_record isEqualType createHashMap) exitWith {createHashMap};

private _normalized = _record;
_normalized set ["recordType", _normalized getOrDefault ["recordType", "logistics"]];
_normalized set ["schemaVersion", _normalized getOrDefault ["schemaVersion", 1]];
_normalized set ["lastWrite", _normalized getOrDefault ["lastWrite", _normalized getOrDefault ["timestamp", serverTime]]];

if !(_normalized getOrDefault ["deleted", false]) then {
    private _cargoKeys = [
        "weaponsCargo",
        "weaponsItemsCargo",
        "magazinesCargo",
        "itemsCargo",
        "backpacksCargo",
        "nestedContainers"
    ];

    {
        if !((_normalized getOrDefault [_x, []]) isEqualType []) then {
            _normalized set [_x, []];
        };
    } forEach _cargoKeys;
};

_normalized
