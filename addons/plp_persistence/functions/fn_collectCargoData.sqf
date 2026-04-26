/*
    Returns serializable cargo data for a vehicle, crate, or nested inventory container.
*/
params ["_container", ["_depth", 0]];

private _nestedContainers = [];
private _fnc_toPairs = {
    params ["_cargo"];

    private _pairs = [];
    private _classes = _cargo param [0, []];
    private _counts = _cargo param [1, []];

    {
        private _count = _counts param [_forEachIndex, 0];
        if (_x isNotEqualTo "" && {_count > 0}) then {
            _pairs pushBack [_x, _count];
        };
    } forEach _classes;

    _pairs
};

if (_depth < 8) then {
    {
        _x params ["_class", "_childContainer"];

        if (!isNull _childContainer) then {
            private _childData = [_childContainer, _depth + 1] call PLP_fnc_collectCargoData;
            _childData set ["class", _class];
            _nestedContainers pushBack _childData;
        };
    } forEach (everyContainer _container);
};

createHashMapFromArray [
    ["weaponsCargo", [getWeaponCargo _container] call _fnc_toPairs],
    ["weaponsItemsCargo", weaponsItemsCargo _container],
    ["magazinesCargo", [getMagazineCargo _container] call _fnc_toPairs],
    ["itemsCargo", [getItemCargo _container] call _fnc_toPairs],
    ["backpacksCargo", [getBackpackCargo _container] call _fnc_toPairs],
    ["nestedContainers", _nestedContainers]
]
