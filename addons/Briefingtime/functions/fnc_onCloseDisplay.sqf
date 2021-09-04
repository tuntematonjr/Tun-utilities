﻿/*
 * Author: [Tuntematon]
 * [Description]
 *
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call tun_briefingtime_fnc_onCloseDisplay
 */
#include "script_component.hpp"

private _newTime = sliderPosition ((uiNamespace getVariable "Tun_Briefingtime_Time") displayCtrl 320003);

//Create notification and admin will modify
if (IS_ADMIN) then {
	//Update time
	_newTime = _newTime * 60;
	GVAR(value) = _newTime;
	publicVariable QGVAR(value);
	
	["Briefing time has been modified"] remoteExecCall [QFUNC(notification), [0,-2] select isDedicated, false];
} else {
	private _text = format ["%2 (%1) has requestend additional %3min briefing time", playerSide, profileName, _newTime];
	[_text] remoteExecCall [QFUNC(notification), [0,-2] select isDedicated, false];
};