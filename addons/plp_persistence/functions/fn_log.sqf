/*
    Writes a PLP log line to the RPT when logging is enabled.
*/
params [
    ["_level", "INFO"],
    ["_message", ""]
];
private _hasData = (count _this) > 2;
private _data = if (_hasData) then {_this select 2} else {""};

if !(missionNamespace getVariable ["PLP_logEnabled", false]) exitWith {};

private _levels = createHashMapFromArray [
    ["ERROR", 0],
    ["WARN", 1],
    ["INFO", 2],
    ["DEBUG", 3]
];
private _configuredLevel = missionNamespace getVariable ["PLP_logLevel", "INFO"];
private _messageLevel = _levels getOrDefault [toUpper _level, 2];
private _minimumLevel = _levels getOrDefault [toUpper _configuredLevel, 2];

if (_messageLevel > _minimumLevel) exitWith {};

private _line = format ["[PLP] [%1] %2", toUpper _level, _message];
if (_hasData) then {
    _line = format ["%1 | %2", _line, _data];
};

diag_log _line;
