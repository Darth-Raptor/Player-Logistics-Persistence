/*
    Applies saved cargo data to a vehicle, crate, or nested inventory container.
*/
params ["_container", "_data", ["_depth", 0]];

if (isNull _container || {!(_data isEqualType createHashMap)}) exitWith {};

clearWeaponCargoGlobal _container;
clearMagazineCargoGlobal _container;
clearItemCargoGlobal _container;
clearBackpackCargoGlobal _container;

{
    private _weapon = if (_x isEqualType []) then {_x param [0, ""]} else {_x};
    if (_weapon isNotEqualTo "") then {
        _container addWeaponCargoGlobal [_weapon, 1];
    };
} forEach (_data getOrDefault ["weaponsCargo", []]);

{
    _x params ["_magazine", "_ammo"];
    _container addMagazineCargoGlobal [_magazine, 1];
} forEach (_data getOrDefault ["magazinesCargo", []]);

{
    _container addItemCargoGlobal [_x, 1];
} forEach (_data getOrDefault ["itemsCargo", []]);

{
    _container addBackpackCargoGlobal [_x, 1];
} forEach (_data getOrDefault ["backpacksCargo", []]);

private _availableContainers = everyContainer _container;
private _usedIndexes = [];

if (_depth < 8) then {
    {
        private _record = _x;
        private _class = _record getOrDefault ["class", ""];
        private _index = -1;

        {
            if (_index < 0 && {(_usedIndexes find _forEachIndex) < 0} && {(_x select 0) isEqualTo _class}) then {
                _index = _forEachIndex;
            };
        } forEach _availableContainers;

        if (_index >= 0) then {
            _usedIndexes pushBack _index;
            private _childContainer = (_availableContainers select _index) select 1;
            [_childContainer, _record, _depth + 1] call PLP_fnc_applyCargoData;
        };
    } forEach (_data getOrDefault ["nestedContainers", []]);
};
