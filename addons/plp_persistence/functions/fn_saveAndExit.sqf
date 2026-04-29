/*
    Client utility: save local player state, flush it server-side, then exit locally.
*/
if (!hasInterface) exitWith {};
if (isNull player || {!alive player}) exitWith {};

private _uid = getPlayerUID player;
if (_uid isEqualTo "") exitWith {};

private _name = name player;
private _data = [player] call PLP_fnc_collectPlayerData;

systemChat "PLP: Saving player data...";
[_uid, _data, _name] remoteExecCall ["PLP_fnc_flushPlayerData", 2];

[] spawn {
    sleep 2;
    systemChat "PLP: Player data sent. Exiting mission...";
    sleep 1;
    endMission "END1";
};

