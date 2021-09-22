/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.26 / Jul 2020

Script: Mission pre-init
Author: Whiztler
Script version: 1.44

File: ADF_init_pre.sqf
**********************************************************************************
DO NOT edit this file. To set-up and configure your mission, edit the files in
the  '\mission\'  folder.
*********************************************************************************/

// Reporting
diag_log "ADF rpt: Init - executing: ADF_init_pre.sqf";

diag_log ""; diag_log "";
diag_log "──────────────────────────────────────────────────────────────────────────────────────";
diag_log "ARMA Development Framework (ADF)";
diag_log format ["Reporting entity: %1", call BIS_fnc_getNetMode];
diag_log "──────────────────────────────────────────────────────────────────────────────────────";
diag_log ""; diag_log "";

// Get addon/mod/dlc availability from the A3 config file and store them in easy to use variables
ADF_dlc_Marksman = isClass (configFile >> "CfgMods" >> "Mark"); // Marksman DLC
ADF_dlc_Bundle = isClass (configFile >> "CfgMods" >> "DLCBundle"); // DLC Bundle
ADF_dlc_Bundle2 = isClass (configFile >> "CfgMods" >> "DLCBundle"); // DLC Bundle 2
ADF_dlc_Heli = isClass (configFile >> "CfgMods" >> "Heli"); // Helicopters DLC
ADF_dlc_Apex = isClass (configFile >> "CfgMods" >> "Expansion"); // Apex/Tanoa
ADF_dlc_LawsofWar = isClass (configFile >> "CfgMods" >> "Orange"); // Laws of War
ADF_dlc_TacOps = isClass (configFile >> "CfgMods" >> "Tacops"); // Tac-Ops
ADF_dlc_Tanks = isClass (configFile >> "CfgMods" >> "Tank"); // Tanks

// Milsim
ADF_mod_CBA = isClass (configFile >> "CfgPatches" >> "cba_main"); // CBA_A3
ADF_mod_ACRE = isClass (configFile >> "CfgPatches" >> "acre_main"); // ACRE2
ADF_mod_TFAR = isClass (configFile >> "CfgPatches" >> "task_force_radio"); // TFAR
ADF_mod_CTAB = isClass (configFile >> "CfgPatches" >> "cTab"); // cTAB
ADF_mod_ACE3 = isClass (configFile >> "CfgPatches" >> "ace_common"); // ACE3 

// Terrain Core
ADF_mod_AIA = isClass (configFile >> "CfgPatches" >> "AiA_Core"); // All in Arma (Terrain Pack)
ADF_mod_CUP_T = isClass (configFile >> "CfgPatches" >> "CUP_Terrains_Core"); // CUP Terrains Maps

// Utility
ADF_mod_ACHIL = isClass (configFile >> "CfgPatches" >> "achilles"); // Achilles Zeus
ADF_mod_ARES = isClass (configFile >> "CfgPatches" >> "Ares"); // Ares Zeus
if (ADF_mod_ACHIL) then {ADF_mod_ARES = true;};

// Units/Vehicles/Weapons/Etc
ADF_mod_JR = isClass (configFile >> "CfgPatches" >> "asdg_jointrails"); // ASDG Joint Rails
ADF_mod_CSAT = isClass (configFile >> "CfgPatches" >> "TEC_CSAT"); // TEC CSAT
ADF_mod_RHS = isClass (configFile >> "CfgPatches" >> "rhs_main"); // Red Hammer Studios USAF & AFRF
ADF_mod_NIARMS = isClass (configFile >> "CfgPatches" >> "hlc_core"); // HLC / NIArms
ADF_mod_PROPFOR = isClass (configFile >> "CfgPatches" >> "po_main"); // Project Opfor
ADF_mod_3CB_FACT= isClass (configFile >> "CfgPatches" >> "uk3cb_factions_Common"); // Project Opfor
ADF_mod_CUP_W = isClass (configFile >> "CfgPatches" >> "CUP_Weapons_WeaponsCore"); // CUP Weapons
ADF_mod_CUP_U = isClass (configFile >> "CfgPatches" >> "CUP_Creatures_People_Core"); // CUP Units
ADF_mod_CUP_V = isClass (configFile >> "CfgPatches" >> "CUP_WheeledVehicles_Core"); // CUP Vehicles
ADF_mod_CFP = isClass (configFile >> "CfgPatches" >> "cfp_main"); // Community Factions Project
ADF_mod_ETF = isClass (configFile >> "CfgPatches" >> "Taliban_Fighters"); // EricJ Taliban Units

// AI Enhancement
ADF_mod_ASRAI = isClass (configFile >> "CfgPatches" >> "asr_ai3_main"); // ASR AI
ADF_mod_BCOMBAT = isClass (configFile >> "CfgPatches" >> "bcombat"); // bCombat
ADF_mod_BAI = isClass (configFile >> "CfgPatches" >> "cf_bai"); // Charlie Foxtrot Better AI
ADF_mod_VCOMAI = isClass (configFile >> "CfgPatches" >> "vcomai"); // vCom AI
ADF_mod_DANGER = isClass (configFile >> "CfgPatches" >> "lambs_main"); // nKenny's Danger.fsm
if (!isNil "Vcm_Settings" || !isNil "VCM_PublicScript") then {ADF_mod_VCOMAI = true};

// Total Modification
ADF_modded = if (ADF_mod_PROPFOR || {ADF_mod_3CB_FACT || {ADF_mod_CFP || {ADF_mod_CUP_U}}}) then {true} else {false};
if (!isNil "ADF_moddedOverride" && {("ADF_moddedOverride" call BIS_fnc_getParamValue) == 1}) then {ADF_modded = false}; // Check modded/vanilla assets

// Init global framework vars
ADF_missionInit = false;
ADF_HC_execute = false;
MotsActive = false;
ADF_init_AO	= false;
ADF_debug_IED = false;
ADF_debug_bPos = false;
ADF_vStrip = true;
ADF_microDAGR_all = 0; 
ADF_TFAR_LR_freq = 0;
ADF_TFAR_SW_freq = 0;
ADF_set_callSigns = false;
ADF_set_radios = false;
ADF_isHC = false;
ADF_GM_init = false;
ADF_ABF = false;
ADF_microDAGR = "";
ADF_gearLoaded = false;
ADF_cntHC = 0;
ADF_log_rptMods = "";
ADF_isHC1 = false;
ADF_isHC2 = false;
ADF_isHC3 = false;
ADF_mapLoaded = "Altis";
if (isNil "ADF_HC_connected") then {ADF_HC_connected = false;}; // HC init
ADF_preInit = true;


// Disable AI chatter. In multiplayer for players only
if hasInterface then {player setVariable ["BIS_noCoreConversations", true]};
if isMultiplayer then {{[[_x, "NoVoice"]] remoteExec ["setSpeaker", -2, true]} forEach allPlayers;} else {enableSentences false};

if (ADF_mod_VCOMAI || {ADF_mod_ASRAI || {ADF_mod_BCOMBAT || {ADF_mod_BAI}}}) then {	
	[] spawn {
		waitUntil {time > 0};
		private _mod = call {
			if ADF_mod_VCOMAI exitWith {"'Vcom AI'"};
			if ADF_mod_ASRAI exitWith {"'ASR AI'"};
			if ADF_mod_BCOMBAT exitWith {"BCombat"};
			if ADF_mod_BAI exitWith {"'Charlie Foxtrot Better AI'"};			
		};
		private _message = format [localize "STR_ADF_pre_AImods", _mod];
		if hasInterface then {systemChat _message;};
		diag_log "";
		diag_log "────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────";
		diag_log _message;
		diag_log "────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────";
		diag_log "";
	};
};
