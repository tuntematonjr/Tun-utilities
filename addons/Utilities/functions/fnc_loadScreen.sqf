﻿/*
 * Author: [Tuntematon]
 * [Description]
 * Force players to map view to reduce desync
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call tun_utilities_fnc_loadScreen
 */
#include "script_component.hpp"
LOG("Called desync load screen");
if (!isMultiplayer || count allPlayers > 10) exitWith { LOG("Skip desync load screen in SP"); }; // skip if singleplayer

[{!isNull player && !isNull findDisplay 12 && !isNil QGVAR(runLoadScreen)}, {
    if !(GVAR(runLoadScreen)) exitWith { LOG("Desync load screen disabled"); };
    if !(playerside in [west, east, resistance, civilian]) exitWith { LOG("Not in right side, so skip desync load screen"); };
    LOG("Start desync load screen");
	GVAR(loadScreenTimer) = GVAR(loadScreenTime);

    if (cba_missiontime > GVAR(loadScreenTime)) then {
        GVAR(loadScreenTimer) = (GVAR(loadScreenTime) / 2);
    };

    tun_loadscreen_done = false;
  
    _camera = "camera" camCreate [(getPos player select 0),(getPos player select 1),100];
    _camera cameraEffect ["internal","back"];
    _camera camSetFOV 0.700;
    _camera camSetTarget player;
    _camera camCommit 0;
	openMap [true, true];
    //Run loadscreen text loop
    private _debugText = format ["Desync load screen start time: %1", cba_missiontime]; 
    LOG(_debugText);
    [{
        if (GVAR(loadScreenTimer) <= 0) then {
            titleText [GVAR(loadScreenText), "PLAIN", 5, true];
            titleFadeOut 5;
            [_handle] call CBA_fnc_removePerFrameHandler;
            tun_loadscreen_done = true;
        } else {
            titleText [format ["%2\n%1", GVAR(loadScreenTimer), GVAR(loadScreenText)], "PLAIN", 1, true];
            titleFadeOut 5;
            GVAR(loadScreenTimer) = GVAR(loadScreenTimer) - 1;
        };
    }, 1] call CBA_fnc_addPerFrameHandler;

    // Destroy camera after loadtime is done
    [{tun_loadscreen_done}, {
        private _camera = _this;
        player cameraEffect ["terminate","back"];
        camDestroy _camera;
        titleText ["", "PLAIN"];
        openMap [false, false];
		if (GVAR(rulesHintEnable)) then {
		    GVAR(rulesTitleText) hintC GVAR(rulesMessageText);
		};
        private _debugText = format ["Desync load screen end time: %1", cba_missiontime]; 
        LOG(_debugText);
    }, _camera] call CBA_fnc_waitUntilAndExecute;

}] call CBA_fnc_waitUntilAndExecute;