﻿/*
 * Author: [Tuntematon]
 * [Description]
 *
 * Arguments:
 * None
 *
 * Return Value:
 * none
 *
 * Example:
 * [] call tun_utilities_fnc_combatZone
 */
#include "script_component.hpp"
private _module = param [0,objNull,[objNull]];
private _markerPreFix = _module getVariable ["markerPreFix", "Missing classname"];
private _markerCount = _module getVariable ["markerCount", "Missing classname"];
private _sideWest = _module getVariable ["sideWest", false];
private _sideEast = _module getVariable ["sideEast", false];
private _sideResistance = _module getVariable ["sideResistance", false];
private _sideCiv = _module getVariable ["sideCiv", false];
private _sides = [];

if (_sideWest) then {
    _sides pushBack west;
};

if (_sideEast) then {
    _sides pushBack east;
};

if (_sideResistance) then {
    _sides pushBack resistance;
};

if (_sideCiv) then {
    _sides pushBack civilian;
};

[{ !isNull player }, {
	_this params ["_sides", "_markerPrefix", "_markerCount"];
    if (playerside in _sides && isNil QGVAR(borderPolygon)) then {
        GVAR(borderPolygon) = [];

        for "_i" from 1 to _markerCount do {
            GVAR(borderPolygon) pushBack (getMarkerPos (format ["%2_%1", _i,_markerPrefix]));
        };

        private _displayIDD = [53, 52] select !isNull findDisplay 52;
        findDisplay _displayIDD displayCtrl 51 ctrlAddEventHandler ["Draw", {
            _this select 0 drawPolygon [GVAR(borderPolygon), [1,0,0,1]];
        }];

        [{ cba_missiontime > 1 }, {
                (findDisplay _this) displayCtrl 51 ctrlRemoveEventHandler ["Draw", _x];

                findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", {
                    _this select 0 drawPolygon [GVAR(borderPolygon), [1,0,0,1]];
                }];   
        
            _handle = [{
                if ( player isKindOf "man" && {alive player} && {!(player isKindOf "ace_spectator_virtual")} && {playerSide in [west,east,resistance,civilian]} && {!(vehicle player isKindOf "air")} && {!(player getVariable ["tun_respawn_waiting_respawn", false])} ) then {
                    private _player_pos = getpos player;
                    if !( _player_pos inPolygon GVAR(borderPolygon)) then {
                        ["<t color='#ff0000' size = '.8'>Warning!<br />You are leaving the combatzone. TURN BACK!</t>",-1,-1,4,1,0,789] spawn BIS_fnc_dynamicText;
                        playSound "beep_strobe";
                    };
                };
            }, 10, []] call CBA_fnc_addPerFrameHandler;
        }, _displayIDD] call CBA_fnc_waitUntilAndExecute;
    };
}, [_sides, _markerPrefix, _markerCount]] call CBA_fnc_waitUntilAndExecute;