/*
    Saves players and logistics to profileNamespace.
*/
if (!isServer) exitWith {};

private _playersSaved = 0;
{
    if (!isNull _x && {isPlayer _x} && {alive _x}) then {
        [getPlayerUID _x, [_x] call PLP_fnc_collectPlayerData] call PLP_fnc_storePlayerData;
        _playersSaved = _playersSaved + 1;
    };
} forEach allPlayers;

private _previousLogisticsData = +PLP_logisticsData;
private _seen = createHashMap;
PLP_logisticsData = [];
private _objectsSaved = 0;
private _tombstonesPreserved = 0;
private _tombstonesCreated = 0;
private _nestedCargoContainers = [];
private _fnc_markNestedContainers = {
    params ["_container"];

    {
        _x params ["", "_childContainer"];
        if (!isNull _childContainer) then {
            _nestedCargoContainers pushBackUnique _childContainer;
            [_childContainer] call _fnc_markNestedContainers;
        };
    } forEach (everyContainer _container);
};

{
    [_x] call _fnc_markNestedContainers;
} forEach (allMissionObjects "All");

{
    if (!(_x in _nestedCargoContainers) && {[_x] call PLP_fnc_isLogisticsPersistent}) then {
        private _data = [_x] call PLP_fnc_collectLogisticsData;
        private _id = _data getOrDefault ["id", ""];
        if (_id isNotEqualTo "" && {isNil {_seen get _id}}) then {
            _seen set [_id, true];
            [_data] call PLP_fnc_upsertLogisticsData;
            _objectsSaved = _objectsSaved + 1;
        };
    };
} forEach (allMissionObjects "All");

{
    private _id = _x getOrDefault ["id", ""];
    if (_id isNotEqualTo "" && {isNil {_seen get _id}}) then {
        if (_x getOrDefault ["deleted", false]) then {
            PLP_logisticsData pushBack _x;
            _tombstonesPreserved = _tombstonesPreserved + 1;
        } else {
            private _category = _x getOrDefault ["category", ""];
            private _class = _x getOrDefault ["class", ""];
            PLP_logisticsData pushBack createHashMapFromArray [
                ["id", _id],
                ["class", _class],
                ["category", _category],
                ["deleted", true],
                ["timestamp", serverTime]
            ];
            _tombstonesCreated = _tombstonesCreated + 1;
        };
    };
} forEach _previousLogisticsData;

profileNamespace setVariable [PLP_playersKey, PLP_playerData];
profileNamespace setVariable [PLP_logisticsKey, PLP_logisticsData];
saveProfileNamespace;

["INFO", "Save complete", createHashMapFromArray [
    ["players", _playersSaved],
    ["objects", _objectsSaved],
    ["records", count PLP_logisticsData],
    ["tombstonesPreserved", _tombstonesPreserved],
    ["tombstonesCreated", _tombstonesCreated]
]] call PLP_fnc_log;
