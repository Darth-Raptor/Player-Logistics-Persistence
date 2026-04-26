/*
    Returns the persistence category for an object, or "" when unsupported.
*/
params ["_object"];

if (isNull _object) exitWith {""};
if (_object isKindOf "CAManBase") exitWith {""};
if (_object isKindOf "Logic") exitWith {""};
if (_object isKindOf "Module_F") exitWith {""};
if (_object isKindOf "EmptyDetector") exitWith {""};

if (_object isKindOf "ReammoBox_F") exitWith {"crates"};
if (_object isKindOf "StaticWeapon") exitWith {"statics"};
if (_object isKindOf "Air") exitWith {"air"};
if (_object isKindOf "Ship") exitWith {"ships"};
if (_object isKindOf "Tank") exitWith {"armor"};
if (_object isKindOf "Car") exitWith {"cars"};

"props"
