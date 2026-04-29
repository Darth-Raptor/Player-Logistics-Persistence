/*
    Ensures server-side persistence globals exist before any admin/save path runs.
*/
if (!isServer) exitWith {false};

if (isNil "PLP_missionKey" || {isNil "PLP_playersKey"} || {isNil "PLP_logisticsKey"}) then {
    private _missionId = missionName;
    if (missionNamespace getVariable ["PLP_keyByMissionPbo", true]) then {
        _missionId = missionNameSource;
        if (_missionId isEqualTo "") then {
            _missionId = missionName;
        };
    };

    PLP_missionKey = format ["PLP:%1:%2", worldName, _missionId];
    PLP_playersKey = PLP_missionKey + ":players";
    PLP_logisticsKey = PLP_missionKey + ":logistics";
};

if (isNil "PLP_playerData" || {!(PLP_playerData isEqualType createHashMap)}) then {
    PLP_playerData = profileNamespace getVariable [PLP_playersKey, createHashMap];
    if !(PLP_playerData isEqualType createHashMap) then {
        PLP_playerData = createHashMap;
    };
};

if (isNil "PLP_logisticsData" || {!(PLP_logisticsData isEqualType [])}) then {
    PLP_logisticsData = profileNamespace getVariable [PLP_logisticsKey, []];
    if !(PLP_logisticsData isEqualType []) then {
        PLP_logisticsData = [];
    };
};

true
