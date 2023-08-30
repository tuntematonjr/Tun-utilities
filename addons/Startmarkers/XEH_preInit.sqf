#include "script_component.hpp"
#include "XEH_prep.sqf"

GVAR(allowedSidesStarmarker) = [];
GVAR(allowedSidesBFT) = [];

[
    QGVAR(enable), // Unique setting name. Matches resulting variable name <STRING>
    "CHECKBOX", // Type of setting. Can be "CHECKBOX", "EDITBOX", "LIST", "SLIDER" or "COLOR" <STRING>
    ["Enable startmakers", "Enable whole system"], // Display name or display name + tooltip (optional, default: same as setting name) <STRING, ARRAY>
    "Tun Utilities - Startmakers & BFT", // Category for the settings menu + optional sub-category <STRING, ARRAY>
    true, // Extra properties of the setting depending of _settingType.
    1, // 1: all clients share the same setting, 2: setting can't be overwritten (optional, default: 0) <ARRAY>
    {}, // Script to execute when setting is changed. (optional) <CODE>
    true //Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_Settings_fnc_init;

[
    QGVAR(showAI), 
    "CHECKBOX", 
    ["Add tag if vehicle crew or squad is AI", "Add tag for squad where is only AI units and vehicles which crew is only AI."], 
    "Tun Utilities - Startmakers & BFT", 
    true,
    1,
    {},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(showUnmanned), 
    "CHECKBOX", 
    "Add tag if vehicle is unmanned", 
    "Tun Utilities - Startmakers & BFT", 
    false,
    1,
    {},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(commandElementID), 
    "EDITBOX", 
    ["Command element ID", "If this is found in names of squads, squad marker will be HQ. There can be multiple, seperate by comas"], 
    "Tun Utilities - Startmakers & BFT", 
    "10",
    1,
    {},
    true
] call CBA_Settings_fnc_init;

////////////////
//StartMarkers//
////////////////

[
    QGVAR(prepTime), 
    "SLIDER", 
    ["Preparation time (minutes)", "After this time is passed, all markers are auto hidden. You can bring them up again through the settings menu."], 
    ["Tun Utilities - Startmakers & BFT","Startposition"], 
    [1, 60, 15, 0],
    1,
    { GVAR(prepTime) = (["Afi_safeStart_duration", _this ] call BIS_fnc_getParamValue) * 60; },
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(allowMarkersWest), 
    "CHECKBOX", 
    ["Allow Startposition Blufor", "Allow Startposition for this side"], 
    ["Tun Utilities - Startmakers & BFT","Startposition"], 
    true,
    1,
    {
        if (_this) then {
            GVAR(allowedSidesStarmarker) pushBack west;
        };
    },
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(allowMarkerEast), 
    "CHECKBOX", 
    ["Allow Startposition Opfor", "Allow Startposition for this side"], 
    ["Tun Utilities - Startmakers & BFT","Startposition"], 
    true,
    1,
    {
        if (_this) then {
            GVAR(allowedSidesStarmarker) pushBack east;
        };
    },
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(allowMarkerInd), 
    "CHECKBOX", 
    ["Allow Startposition Indfor", "Allow Startposition for this side"], 
    ["Tun Utilities - Startmakers & BFT","Startposition"], 
    true,
    1,
    {
        if (_this) then {
            GVAR(allowedSidesStarmarker) pushBack resistance;
        };
    },
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(allowMarkerCivilian), 
    "CHECKBOX", 
    ["Allow Startposition Civilian", "Allow Startposition for this side"], 
    ["Tun Utilities - Startmakers & BFT","Startposition"], 
    true,
    1,
    {
        if (_this) then {
            GVAR(allowedSidesStarmarker) pushBack civilian;
        };
    },
    true
] call CBA_Settings_fnc_init;

///////
//BFT//
///////
[
    QGVAR(enableBFT), 
    "CHECKBOX", 
    ["Blue Force Tracking", "Enable BFT"], 
    ["Tun Utilities - Startmakers & BFT","BFT"], 
    false,
    1,
    {},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(bftAlwaysOn), 
    "CHECKBOX", 
    ["BFT always on", "Enable BFT for everyone. No item requirements"], 
    ["Tun Utilities - Startmakers & BFT","BFT"], 
    false,
    1,
    {},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(addAllVehicles), 
    "CHECKBOX", 
    ["Add all vehicles", "Add all vehicles. Even if created after mission start. If vehicle side is not defined. First unit who get in vehicle will specify it."], 
    ["Tun Utilities - Startmakers & BFT","BFT"], 
    false,
    1,
    {},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(updateInterval), 
    "SLIDER", 
    ["BFT update interval (seconds)", "Time between updates (seconds)"], 
    ["Tun Utilities - Startmakers & BFT","BFT"], 
    [1, 60, 5, 0],
    1,
    {},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(bftItems), 
    "EDITBOX", 
    ["Required item", "List of item classnames to allow BFT. Seperate by comas"], 
    ["Tun Utilities - Startmakers & BFT","BFT"], 
    '"ACE_microDAGR", "ItemGPS"',
    1,
    { GVAR(bftItems) = _this splitString """, """; MAP(GVAR(bftItems), toLower _x);},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(allowBftWest), 
    "CHECKBOX", 
    ["Allow BFT Blufor", "Allow BFT for this side"], 
    ["Tun Utilities - Startmakers & BFT","BFT"], 
    true,
    1,
    {
        if (_this) then {
            GVAR(allowedSidesBFT) pushBack west;
        };
    },
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(allowBftEast), 
    "CHECKBOX", 
    ["Allow BFT Opfor", "Allow BFT for this side"], 
    ["Tun Utilities - Startmakers & BFT","BFT"], 
    true,
    1,
    {
        if (_this) then {
            GVAR(allowedSidesBFT) pushBack east;
        };
    },
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(allowBftInd), 
    "CHECKBOX", 
    ["Allow BFT Indfor", "Allow BFT for this side"], 
    ["Tun Utilities - Startmakers & BFT","BFT"], 
    true,
    1,
    {
        if (_this) then {
            GVAR(allowedSidesBFT) pushBack resistance;
        };
    },
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(allowBftCivilian), 
    "CHECKBOX", 
    ["Allow BFT Civilian", "Allow BFT for this side"], 
    ["Tun Utilities - Startmakers & BFT","BFT"], 
    true,
    1,
    {
        if (_this) then {
            GVAR(allowedSidesBFT) pushBack civilian;
        };
    },
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(lostContactTime), 
    "SLIDER", 
    ["Lost contact time", "After this time is passed without update for marker data, marker alpha will be set to 0.5. (Minutes)"], 
    ["Tun Utilities - Startmakers & BFT","BFT"], 
    [1, 60, 5, 0],
    1,
    {},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(enableDeleteMarker), 
    "CHECKBOX", 
    ["Enable delete non updated markers", "Enable system to delete unupdated markers"], 
    ["Tun Utilities - Startmakers & BFT","BFT"], 
    true,
    1,
    {},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(deleteMarkerTime), 
    "SLIDER", 
    ["Delete marker without update time", "After this time is passed without update for marker data, it will be deleted. (Minutes)"], 
    ["Tun Utilities - Startmakers & BFT","BFT"], 
    [1, 60, 15, 0],
    1,
    {},
    true
] call CBA_Settings_fnc_init;