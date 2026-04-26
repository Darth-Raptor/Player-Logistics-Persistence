/*
    Recreates saved logistics objects on the server.
*/
if (!isServer) exitWith {};

private _loaded = 0;
private _deleted = 0;
private _skipped = 0;

{
    private _record = _x;
    private _id = _record getOrDefault ["id", ""];
    private _class = _record getOrDefault ["class", ""];
    if (_id isNotEqualTo "" && {_class isNotEqualTo ""}) then {
        private _existing = allMissionObjects "All" select {
            ((_x getVariable ["PLP_persistenceId", ""]) isEqualTo _id) ||
            {([_x] call PLP_fnc_getDefaultObjectId) isEqualTo _id}
        };

        if (_record getOrDefault ["deleted", false]) then {
            {
                deleteVehicle _x;
            } forEach _existing;
            _deleted = _deleted + 1;
            ["DEBUG", "Applied deleted logistics tombstone", createHashMapFromArray [
                ["id", _id],
                ["class", _class]
            ]] call PLP_fnc_log;
        } else {
            private _recordCategory = _record getOrDefault ["category", ""];
            if (_recordCategory isEqualTo "" || {[_recordCategory] call PLP_fnc_isCategoryEnabled}) then {
                private _object = objNull;
                if (_existing isEqualTo []) then {
                    _object = createVehicle [_class, [0, 0, 0], [], 0, "CAN_COLLIDE"];
                } else {
                    _object = _existing select 0;
                };

                if ([_object] call PLP_fnc_isLogisticsPersistent) then {
                    [_object, _id] call PLP_fnc_registerLogisticsObject;
                    _object setDir (_record getOrDefault ["dir", getDir _object]);
                    _object setVectorUp (_record getOrDefault ["vectorUp", vectorUp _object]);
                    _object setPosASL (_record getOrDefault ["posASL", getPosASL _object]);
                    _object setDamage (_record getOrDefault ["damage", damage _object]);
                    _object setFuel (_record getOrDefault ["fuel", fuel _object]);
                    _object lock (_record getOrDefault ["locked", locked _object]);

                    [_object, _record] call PLP_fnc_applyCargoData;
                    _loaded = _loaded + 1;

                    private _vars = _record getOrDefault ["vars", createHashMap];
                    if (_vars isEqualType createHashMap) then {
                        {
                            _object setVariable [_x, _y, true];
                        } forEach _vars;
                    };
                } else {
                    _skipped = _skipped + 1;
                    ["DEBUG", "Skipped logistics record after object category check", createHashMapFromArray [
                        ["id", _id],
                        ["class", _class],
                        ["category", _recordCategory]
                    ]] call PLP_fnc_log;
                };
            } else {
                _skipped = _skipped + 1;
                ["DEBUG", "Skipped disabled logistics category", createHashMapFromArray [
                    ["id", _id],
                    ["class", _class],
                    ["category", _recordCategory]
                ]] call PLP_fnc_log;
            };
        };
    };
} forEach PLP_logisticsData;

["INFO", "Logistics load complete", createHashMapFromArray [
    ["loaded", _loaded],
    ["deletedTombstones", _deleted],
    ["skipped", _skipped],
    ["records", count PLP_logisticsData]
]] call PLP_fnc_log;
