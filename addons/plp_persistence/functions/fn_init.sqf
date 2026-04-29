/*
    Initializes client/server persistence loops.
*/

if (isServer) then {
    [] call PLP_fnc_ensureServerState;

    ["INFO", "Initializing persistence", createHashMapFromArray [
        ["missionKey", PLP_missionKey],
        ["playersKey", PLP_playersKey],
        ["logisticsKey", PLP_logisticsKey]
    ]] call PLP_fnc_log;

    {
        PLP_playerData set [_x, [PLP_playerData get _x] call PLP_fnc_normalizePlayerData];
    } forEach keys PLP_playerData;

    PLP_logisticsData = PLP_logisticsData apply {[_x] call PLP_fnc_normalizeLogisticsRecord};

    ["INFO", "Loaded profileNamespace state", createHashMapFromArray [
        ["players", count PLP_playerData],
        ["logisticsRecords", count PLP_logisticsData]
    ]] call PLP_fnc_log;

    {
        if ([_x] call PLP_fnc_isLogisticsPersistent) then {
            [_x] call PLP_fnc_registerLogisticsObject;
        };
    } forEach (allMissionObjects "All");

    [] call PLP_fnc_loadLogistics;

    addMissionEventHandler ["HandleDisconnect", {
        params ["_unit", "_id", "_uid", "_name"];
        if (!isNull _unit && {_uid isNotEqualTo ""}) then {
            ["INFO", "Saving disconnecting player", createHashMapFromArray [
                ["uid", _uid],
                ["name", _name]
            ]] call PLP_fnc_log;
            [_uid, [_unit] call PLP_fnc_collectPlayerData] call PLP_fnc_storePlayerData;
            [] call PLP_fnc_saveAll;
        };
        false
    }];

    [] spawn {
        while {true} do {
            sleep (missionNamespace getVariable ["PLP_saveInterval", 120]);
            [] call PLP_fnc_saveAll;
        };
    };
};

if (hasInterface) then {
    [] spawn {
        waitUntil {sleep 0.25; !isNull player && {getPlayerUID player isNotEqualTo ""}};

        [player, getPlayerUID player] remoteExecCall ["PLP_fnc_requestPlayerLoad", 2];

        player addEventHandler ["Respawn", {
            params ["_unit"];
            [_unit, getPlayerUID _unit] remoteExecCall ["PLP_fnc_requestPlayerLoad", 2];
        }];

        while {true} do {
            sleep (missionNamespace getVariable ["PLP_saveInterval", 120]);
            if (!isNull player && {alive player}) then {
                [getPlayerUID player, [player] call PLP_fnc_collectPlayerData] remoteExecCall ["PLP_fnc_storePlayerData", 2];
            };
        };
    };
};
