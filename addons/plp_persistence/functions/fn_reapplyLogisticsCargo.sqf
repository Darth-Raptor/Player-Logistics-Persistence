/*
    Reapplies saved logistics cargo on the server after JIP/reconnect.
*/
if (!isServer) exitWith {};
[] call PLP_fnc_ensureServerState;

private _reapplied = 0;
private _missing = 0;
private _skipped = 0;

{
    private _record = [_x] call PLP_fnc_normalizeLogisticsRecord;
    private _validation = [_record] call PLP_fnc_validateLogisticsRecord;
    private _id = _record getOrDefault ["id", ""];

    if !(_validation getOrDefault ["valid", false]) then {
        _skipped = _skipped + 1;
        ["WARN", "Skipped invalid logistics cargo reapply record", createHashMapFromArray [
            ["id", _validation getOrDefault ["id", _id]],
            ["class", _validation getOrDefault ["class", _record getOrDefault ["class", ""]]],
            ["reason", _validation getOrDefault ["reason", "unknown"]]
        ]] call PLP_fnc_log;
    } else {
        if (_id isNotEqualTo "" && {!(_record getOrDefault ["deleted", false])}) then {
            private _matches = allMissionObjects "All" select {
                ((_x getVariable ["PLP_persistenceId", ""]) isEqualTo _id) ||
                {([_x] call PLP_fnc_getDefaultObjectId) isEqualTo _id}
            };

            if (_matches isEqualTo []) then {
                _missing = _missing + 1;
            } else {
                private _object = _matches select 0;
                if ([_object] call PLP_fnc_isLogisticsPersistent) then {
                    [_object, _record] call PLP_fnc_applyCargoData;
                    _reapplied = _reapplied + 1;
                };
            };
        };
    };
} forEach PLP_logisticsData;

["INFO", "Reapplied logistics cargo", createHashMapFromArray [
    ["reapplied", _reapplied],
    ["missing", _missing],
    ["skipped", _skipped],
    ["records", count PLP_logisticsData]
]] call PLP_fnc_log;
