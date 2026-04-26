/*
    Applies saved cargo data to a vehicle, crate, or nested inventory container.
*/
params ["_container", "_data", ["_depth", 0]];

if (isNull _container || {!(_data isEqualType createHashMap)}) exitWith {};

private _fnc_classCount = {
    params ["_entry", ["_defaultCount", 1]];

    private _class = "";
    private _count = _defaultCount;

    if (_entry isEqualType "") then {
        _class = _entry;
    } else {
        if (_entry isEqualType []) then {
            _class = _entry param [0, ""];
            private _rawCount = _entry param [1, _defaultCount];
            if (_rawCount isEqualType 0) then {
                _count = _rawCount;
            };
        };
    };

    [_class, _count]
};

clearWeaponCargoGlobal _container;
clearMagazineCargoGlobal _container;
clearItemCargoGlobal _container;
clearBackpackCargoGlobal _container;

private _weaponsItemsCargo = _data getOrDefault ["weaponsItemsCargo", []];
if (_weaponsItemsCargo isNotEqualTo []) then {
    {
        if (_x isEqualType [] && {(_x param [0, ""]) isNotEqualTo ""}) then {
            _container addWeaponWithAttachmentsCargoGlobal [_x, 1];
        };
    } forEach _weaponsItemsCargo;
} else {
    {
        ([ _x ] call _fnc_classCount) params ["_weapon", "_count"];
        if (_weapon isNotEqualTo "" && {_count > 0}) then {
            _container addWeaponCargoGlobal [_weapon, _count];
        };
    } forEach (_data getOrDefault ["weaponsCargo", []]);
};

{
    ([ _x ] call _fnc_classCount) params ["_magazine", "_count"];
    if (_magazine isNotEqualTo "" && {_count > 0}) then {
        _container addMagazineCargoGlobal [_magazine, _count];
    };
} forEach (_data getOrDefault ["magazinesCargo", []]);

{
    ([ _x ] call _fnc_classCount) params ["_item", "_count"];
    if (_item isNotEqualTo "" && {_count > 0}) then {
        _container addItemCargoGlobal [_item, _count];
    };
} forEach (_data getOrDefault ["itemsCargo", []]);

{
    ([ _x ] call _fnc_classCount) params ["_backpack", "_count"];
    if (_backpack isNotEqualTo "" && {_count > 0}) then {
        _container addBackpackCargoGlobal [_backpack, _count];
    };
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
