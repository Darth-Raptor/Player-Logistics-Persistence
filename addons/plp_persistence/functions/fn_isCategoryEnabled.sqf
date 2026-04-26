/*
    Returns true when a persistence category is enabled in CBA settings.
*/
params ["_category"];

switch (_category) do {
    case "cars": {missionNamespace getVariable ["PLP_persistCars", true]};
    case "armor": {missionNamespace getVariable ["PLP_persistArmor", true]};
    case "air": {missionNamespace getVariable ["PLP_persistAir", true]};
    case "ships": {missionNamespace getVariable ["PLP_persistShips", true]};
    case "statics": {missionNamespace getVariable ["PLP_persistStatics", true]};
    case "crates": {missionNamespace getVariable ["PLP_persistCrates", true]};
    case "props": {missionNamespace getVariable ["PLP_persistProps", true]};
    default {true};
}
