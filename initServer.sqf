/*********************************************************************************
 _____ ____  _____
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|
ARMA Mission Development Framework
ADF version: 2.26 / Jul 2020

Script: Mission init
Author: Whiztler
Script version: 1.26

File: initServer.sqf
**********************************************************************************
DO NOT edit this file. To set-up and configure your mission, edit the files in
the  '\mission\'  folder.
*********************************************************************************/

// Reporting
diag_log "ADF rpt: Init - executing: initServer.sqf";

// Pre-init
#include "ADF\ADF_init_params.sqf"
#include "mission\ADF_mission_settings.sqf"
#include "ADF\ADF_init_pre.sqf"
#include "ADF\ADF_init_addons.sqf"

// Dedicated server only
if isDedicated then {
	#include "ADF\ADF_init_rpt.sqf"
};

// Execute mission settings
private _handle = execVM "ADF\ADF_init_hc.sqf"; waitUntil {scriptDone _handle};
if ADF_Tickets then {[west, _ADF_wTixNr] call BIS_fnc_respawnTickets; [east, _ADF_eTixNr] call BIS_fnc_respawnTickets};
if _ADF_CleanUp then {[_ADF_CleanUp_viewDist, _ADF_CleanUp_manTimer, _ADF_CleanUp_vehTimer, _ADF_CleanUp_abaTimer] execVM "ADF\ext\repCleanup\repCleanup.sqf"};
if (_ADF_Caching && {!ADF_HC_connected}) then {[_ADF_Caching_UnitDistance, -1, ADF_debug, _ADF_Caching_vehicleDistance_land, _ADF_Caching_vehicleDistance_air, _ADF_Caching_vehicleDistance_sea, _ADF_Caching_debugInfo] execVM "ADF\ext\zbe_cache\main.sqf"};
if _ADF_mhq_enable then {[_ADF_mhq_enable, _ADF_mhq_respawn_time, _ADF_mhq_respawn_nr, _ADF_mhq_respawn_class, _ADF_mhq_deploy_time, _ADF_mhq_packup_time, _ADF_wTixNr] execVM "ADF\ADF_init_mhq.sqf"};

// Post-init
private _versionText 	= format ["ADF - ARMA Mission Development Framework v%1", ADF_tpl_version];
private _marker = createMarker ["mADF_version", [5, -200, 0]];
_marker setMarkerSize [0, 0];
_marker setMarkerShape "ICON";
_marker setMarkerType "mil_box";
_marker setMarkerColor "ColorGrey";
_marker setMarkerDir 0;
_marker setMarkerText _versionText;

// Custom mission init
execVM "Scripts\init.sqf";
