/*
    Deletes a persistent object, writes a tombstone, and flushes persistence.
*/
if (!isServer) exitWith {};
params ["_object"];

if (isNull _object) exitWith {};

private _id = _object getVariable ["PLP_persistenceId", ""];
if (_id isEqualTo "") then {
    _id = [_object] call PLP_fnc_getDefaultObjectId;
};
if (_id isEqualTo "") exitWith {};

private _category = [_object] call PLP_fnc_getObjectCategory;
private _class = typeOf _object;
private _index = PLP_logisticsData findIf {(_x getOrDefault ["id", ""]) isEqualTo _id};
private _record = createHashMapFromArray [
    ["id", _id],
    ["class", _class],
    ["category", _category],
    ["deleted", true],
    ["timestamp", serverTime]
];

["INFO", "Deleting persistent object", createHashMapFromArray [
    ["id", _id],
    ["class", _class],
    ["category", _category]
]] call PLP_fnc_log;

if (_index < 0) then {
    PLP_logisticsData pushBack _record;
} else {
    PLP_logisticsData set [_index, _record];
};

deleteVehicle _object;

{
    if (!isNull _x && {isPlayer _x} && {alive _x}) then {
        [getPlayerUID _x, [_x] call PLP_fnc_collectPlayerData] call PLP_fnc_storePlayerData;
    };
} forEach allPlayers;

profileNamespace setVariable [PLP_playersKey, PLP_playerData];
profileNamespace setVariable [PLP_logisticsKey, PLP_logisticsData];
saveProfileNamespace;

["INFO", "Delete tombstone saved", createHashMapFromArray [
    ["id", _id],
    ["records", count PLP_logisticsData],
    ["players", count PLP_playerData]
]] call PLP_fnc_log;
