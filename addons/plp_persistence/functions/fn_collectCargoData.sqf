/*
    Returns serializable cargo data for a vehicle, crate, or nested inventory container.
*/
params ["_container", ["_depth", 0]];

private _nestedContainers = [];

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
    ["weaponsCargo", weaponsItemsCargo _container],
    ["magazinesCargo", magazinesAmmoCargo _container],
    ["itemsCargo", itemCargo _container],
    ["backpacksCargo", backpackCargo _container],
    ["nestedContainers", _nestedContainers]
]
