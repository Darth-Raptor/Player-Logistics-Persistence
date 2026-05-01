/*
    Registers optional ACE self interactions when ACE Interaction is loaded.
*/
if (!hasInterface) exitWith {};
if !(isClass (configFile >> "CfgPatches" >> "ace_interact_menu")) exitWith {};
if (missionNamespace getVariable ["PLP_aceActionsRegistered", false]) exitWith {};

[] spawn {
    waitUntil {
        sleep 0.25;
        !isNil "ace_interact_menu_fnc_createAction" &&
        {!isNil "ace_interact_menu_fnc_addActionToClass"}
    };

    private _saveAndExitAction = [
        "PLP_saveAndExit",
        "Save & Exit",
        "",
        {[] call PLP_fnc_saveAndExit;},
        {!isNull player && {alive player} && {getPlayerUID player isNotEqualTo ""}}
    ] call ace_interact_menu_fnc_createAction;

    private _serverSaveAndExitAction = [
        "PLP_serverSaveAndExit",
        "Server Save & Exit",
        "",
        {[] call PLP_fnc_serverSaveAndExit;},
        {!isNull player && {alive player} && {[] call PLP_fnc_isAdminClient}}
    ] call ace_interact_menu_fnc_createAction;

    ["CAManBase", 1, ["ACE_SelfActions"], _saveAndExitAction, true] call ace_interact_menu_fnc_addActionToClass;
    ["CAManBase", 1, ["ACE_SelfActions"], _serverSaveAndExitAction, true] call ace_interact_menu_fnc_addActionToClass;
    missionNamespace setVariable ["PLP_aceActionsRegistered", true];
};
