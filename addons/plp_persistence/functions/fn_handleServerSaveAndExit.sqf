/*
    Server side of admin Server Save & Exit.
*/
if (!isServer) exitWith {};
[] call PLP_fnc_ensureServerState;
params ["_unit", ["_uid", ""], ["_name", ""]];

private _targetOwner = if (!isNull _unit) then {owner _unit} else {remoteExecutedOwner};
private _adminState = admin _targetOwner;

if (_adminState isNotEqualTo 2) exitWith {
    ["WARN", "Rejected server save and exit request from non-logged-in admin", createHashMapFromArray [
        ["uid", _uid],
        ["name", _name],
        ["owner", _targetOwner],
        ["adminState", _adminState]
    ]] call PLP_fnc_log;
};

["WARN", "Admin requested server save and exit", createHashMapFromArray [
    ["uid", _uid],
    ["name", _name],
    ["owner", _targetOwner],
    ["adminState", _adminState]
]] call PLP_fnc_log;

[] call PLP_fnc_saveAll;

if (_targetOwner > 0) then {
    [] remoteExecCall ["PLP_fnc_saveAndExitComplete", _targetOwner];
};
