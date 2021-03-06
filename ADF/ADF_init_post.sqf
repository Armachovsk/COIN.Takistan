/*********************************************************************************
 _____ ____  _____
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|
ARMA Mission Development Framework
ADF version: 2.26 / Jul 2020

Script: Mission initialization countdown timer
Author: Whiztler
Script version: 1.53

File: ADF_init_post.sqf
**********************************************************************************
DO NOT edit this file. To set-up and configure your mission, edit the files in
the  '\mission\'  folder.
*********************************************************************************/

// Reporting
diag_log "ADF rpt: Init - executing: ADF_init_post.sqf";

if ADF_debug then {
	{
		private _m = "DIAG - Script executed: " + str _x;
		[_m, false] call ADF_fnc_log;
	} forEach diag_activeSQFScripts;
};

// Init
params ["_init_time","_vt","_vm"];
private _count = 0;
_init_time = _init_time / 100;

// Check debug, locality, etc
if (time > 300) exitWith {ADF_missionInit = true};
if ADF_debug exitWith {ADF_missionInit = true; publicVariable "ADF_missionInit"; diag_log "ADF rpt: INIT - debug mode detected, skipping mission init timer"};
if isMultiplayer then {player enableSimulation false; showMap false;};

// Init client display
while {(_count != 100)} do {
	_count = _count + 1;
	private _hintText = format [localize "STR_ADF_post_initHint1", _count, _init_time * 100, ADF_tpl_version, ADF_mission_version];
	sleep _init_time;
	hintSilent parseText _hintText;
};

if isMultiplayer then {player enableSimulation true; showMap true;};
private _hintText = format [localize "STR_ADF_post_initHint2", _init_time * 100, ADF_tpl_version, ADF_mission_version];
hintSilent parseText _hintText;

finishMissionInit;
sleep 3;
hintSilent "";
ADF_missionInit = true;

// Debug reporting
if ADF_debug then {diag_log "ADF Debug: INIT - ADF_missionInit = true"};
