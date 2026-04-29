/*
    Clears saved persistence data for the current mission.
*/
if (!isServer) exitWith {};
[] call PLP_fnc_ensureServerState;

profileNamespace setVariable [PLP_playersKey, nil];
profileNamespace setVariable [PLP_logisticsKey, nil];
saveProfileNamespace;

PLP_playerData = createHashMap;
PLP_logisticsData = [];

["WARN", "Cleared mission persistence data", createHashMapFromArray [
    ["playersKey", PLP_playersKey],
    ["logisticsKey", PLP_logisticsKey]
]] call PLP_fnc_log;
