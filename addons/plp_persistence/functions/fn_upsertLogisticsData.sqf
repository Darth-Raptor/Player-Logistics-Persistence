/*
    Updates one logistics record in PLP_logisticsData by id.
*/
if (!isServer) exitWith {};
params ["_data"];

if !(_data isEqualType createHashMap) exitWith {};

private _id = _data getOrDefault ["id", ""];
if (_id isEqualTo "") exitWith {};

private _index = PLP_logisticsData findIf {(_x getOrDefault ["id", ""]) isEqualTo _id};
if (_index < 0) then {
    PLP_logisticsData pushBack _data;
} else {
    PLP_logisticsData set [_index, _data];
};
