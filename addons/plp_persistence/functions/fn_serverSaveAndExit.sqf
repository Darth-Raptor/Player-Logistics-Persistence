/*
    Client utility: ask server to save all state, then exit after server acknowledgement.
*/
if (!hasInterface) exitWith {};
if (isNull player || {!alive player}) exitWith {};
if !([] call PLP_fnc_isAdminClient) exitWith {
    systemChat "PLP: Server Save & Exit is only available to logged-in admins.";
};

systemChat "PLP: Requesting server save...";
[player, getPlayerUID player, name player] remoteExecCall ["PLP_fnc_handleServerSaveAndExit", 2];

