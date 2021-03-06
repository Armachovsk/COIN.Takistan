/*********************************************************************************
 _____ ____  _____
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|
ARMA Mission Development Framework
ADF version: 2.26 / Jul 2020

Script: Crate Cargo Script (BLUEFOR) - Infantry Fire Team (Fox)
Author: Whiztler
Script version: 1.9

Game type: n/a
File: ADF_cCargo_B_IFT.sqf
**********************************************************************************
INSTRUCTIONS::

Paste below line in the INITIALIZATION box of the crate:
null = [this] execVM "mission\loadout\crates\ADF_cCargo_B_IFT.sqf";

You can comment out (//) lines of ammo you do not want to include
in the vehicle Cargo.
*********************************************************************************/

if !isServer exitWith {};

waitUntil {time > 0 && !isNil "ADF_preInit"};

// Init
params ["_crate"];

_crate allowDamage false;
private _wpn = 1; 	// Regular Weapons
private _spw = 1; 	// Special Purpose Weapons
private _lau = 5;		// Launchers
private _mag = 20;	// Magazines
private _dem = 1;		// Demo/Explosives
private _mis = 5;		// Missiles/Rockets
private _itm = 1;		// Items
private _uni = 4;		// Uniform/Vest/Backpack/etc

// Settings
_crate call ADF_fnc_stripVehicle;

// Primary weapon
_crate addWeaponCargoGlobal ["arifle_MX_F", _wpn];
_crate addWeaponCargoGlobal ["arifle_MX_GL_F", _wpn]; // GL
_crate addWeaponCargoGlobal ["arifle_MX_SW_F", _wpn]; // LMG

// Secondary weapon
_crate addWeaponCargoGlobal ["hgun_P07_F", _wpn];

// Magazines primary weapon
if ADF_mod_ACE3 then {
	_crate addMagazineCargoGlobal ["ACE_30Rnd_65x39_caseless_mag_Tracer_Dim", _mag];
	_crate addMagazineCargoGlobal ["ACE_100Rnd_65x39_caseless_mag_Tracer_Dim", _mag];
	_crate addMagazineCargoGlobal ["ACE_200Rnd_65x39_cased_Box_Tracer_Dim", _mag];
} else {
	_crate addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag", _mag];
	_crate addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag_Tracer", _mag];
	_crate addMagazineCargoGlobal ["100Rnd_65x39_caseless_mag_tracer", _mag]; // LMG
	_crate addMagazineCargoGlobal ["100Rnd_65x39_caseless_mag", _mag]; // LMG
};

// Magazines secondary weapon
_crate addMagazineCargoGlobal ["16Rnd_9x21_Mag", _mag];

// Launchers
_crate addweaponCargoGlobal ["launch_NLAW_F", _lau];

// Rockets/Missiles
if (!ADF_mod_ACE3) then {_crate addMagazineCargoGlobal ["NLAW_F", _mis]};

// Demo/Explosives
_crate addMagazineCargoGlobal ["DemoCharge_Remote_Mag", _dem];
_crate addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", _dem];
_crate addMagazineCargoGlobal ["ATMine_Range_Mag", _dem];
_crate addMagazineCargoGlobal ["SLAMDirectionalMine_Wire_Mag", _itm];
_crate addItemCargoGlobal ["MineDetector", _itm];
if ADF_mod_ACE3 then {
	_crate addItemCargoGlobal ["ACE_Cellphone", _itm];
	_crate addItemCargoGlobal ["ACE_Clacker", _itm];
	_crate addItemCargoGlobal ["ACE_DefusalKit", _itm];
	_crate addItemCargoGlobal ["ACE_wirecutter", _itm];
};

// Weapon mountings
if ADF_mod_ACE3 then {
	_crate addItemCargoGlobal ["acc_pointer_IR", _itm];
	_crate addItemCargoGlobal ["acc_flashlight", _itm];
	_crate addItemCargoGlobal ["ACE_optic_Hamr_2D", _itm];
	_crate addItemCargoGlobal ["ACE_optic_Hamr_PIP", _itm];
	_crate addItemCargoGlobal ["ACE_optic_Arco_2D", _itm];
	_crate addItemCargoGlobal ["ACE_optic_Arco_PIP", _itm];
	_crate addItemCargoGlobal ["ACE_optic_MRCO_2D", _itm];
} else {
	_crate addItemCargoGlobal ["acc_pointer_IR", _itm];
	_crate addItemCargoGlobal ["optic_ACO", _itm];
	_crate addItemCargoGlobal ["optic_NVS", _itm];
	_crate addItemCargoGlobal ["optic_Hamr", _itm];
	_crate addItemCargoGlobal ["acc_flashlight", _itm];
};

// GL Ammo
_crate addMagazineCargoGlobal ["1Rnd_HE_Grenade_shell", 10];
_crate addMagazineCargoGlobal ["3Rnd_HE_Grenade_shell", 5];
_crate addMagazineCargoGlobal ["1Rnd_Smoke_Grenade_shell", 3];
_crate addMagazineCargoGlobal ["3Rnd_Smoke_Grenade_shell", 3];
_crate addMagazineCargoGlobal ["1Rnd_SmokeRed_Grenade_shell", 3];
_crate addMagazineCargoGlobal ["3Rnd_SmokeRed_Grenade_shell", 3];
_crate addMagazineCargoGlobal ["1Rnd_SmokeGreen_Grenade_shell", 3];
_crate addMagazineCargoGlobal ["3Rnd_SmokeGreen_Grenade_shell", 3];
_crate addMagazineCargoGlobal ["1Rnd_SmokePurple_Grenade_shell", 3];
_crate addMagazineCargoGlobal ["3Rnd_SmokePurple_Grenade_shell", 3];
_crate addMagazineCargoGlobal ["UGL_FlareCIR_F", _itm];
_crate addMagazineCargoGlobal ["UGL_FlareWhite_F", 3];
_crate addMagazineCargoGlobal ["UGL_FlareGreen_F", 3];
_crate addMagazineCargoGlobal ["UGL_FlareRed_F", 3];
if ADF_mod_ACE3 then {
	_crate addItemCargoGlobal ["ACE_HuntIR_M203", 2];
	_crate addItemCargoGlobal ["ACE_HuntIR_monitor", 1];
};

// Grenades/Chemlights
_crate addMagazineCargoGlobal ["HandGrenade", 15];
_crate addMagazineCargoGlobal ["SmokeShell", 15];
_crate addMagazineCargoGlobal ["SmokeShellGreen", 3];
_crate addMagazineCargoGlobal ["SmokeShellRed", 3];
_crate addMagazineCargoGlobal ["SmokeShellPurple", _itm];
_crate addMagazineCargoGlobal ["Chemlight_green", _mag];
_crate addMagazineCargoGlobal ["Chemlight_red", _mag];
_crate addMagazineCargoGlobal ["B_IR_Grenade", 5];
if ADF_mod_ACE3 then {
	_crate addItemCargoGlobal ["ACE_HandFlare_White", 10];
	_crate addItemCargoGlobal ["ACE_HandFlare_Red", 3];
	_crate addItemCargoGlobal ["ACE_HandFlare_Green", 3];
	_crate addItemCargoGlobal ["ACE_HandFlare_Yellow", 3];
};

// Medical Items
if ADF_mod_ACE3 then {
	_crate addItemCargoGlobal ["ACE_fieldDressing", _mag];
	_crate addItemCargoGlobal ["ACE_personalAidKit", _itm];
	_crate addItemCargoGlobal ["ACE_morphine", 15];
	_crate addItemCargoGlobal ["ACE_epinephrine", 5];
} else {
	_crate addItemCargoGlobal ["FirstAidKit", _mag];
	_crate addItemCargoGlobal ["Medikit", _itm];
};

// Optical/Bino's/Goggles
if ADF_mod_ACE3 then {
	_crate addItemCargoGlobal ["ACE_Vector", _itm];
	_crate addItemCargoGlobal ["ACE_Kestrel4500", _itm];
} else {
	_crate addWeaponCargoGlobal ["Binocular", _itm];
};
_crate addItemCargoGlobal ["G_Tatical_Clear", 5];
_crate addItemCargoGlobal ["NVGoggles", 5];

// ACRE / TFAR and cTAB
if ADF_mod_ACRE then {
	_crate addItemCargoGlobal ["ACRE_PRC343", 5];
	_crate addItemCargoGlobal ["ACRE_PRC148", _itm];
};
if ADF_mod_TFAR then {
	_crate addItemCargoGlobal ["tf_anprc152", 5];
	_crate addItemCargoGlobal ["tf_microdagr", 5];
	//_crate addItemCargoGlobal ["tf_rt1523g", 3];
	_crate addBackpackCargoGlobal ["tf_rt1523g", _itm];
};
if (!ADF_mod_ACRE && !ADF_mod_TFAR) then {_crate addItemCargoGlobal ["ItemRadio", 5]};
if ADF_mod_CTAB then {
	_crate addItemCargoGlobal ["ItemAndroid", _itm];
	_crate addItemCargoGlobal ["ItemcTabHCam", 5];
};

// Gear kit (not working from crates/veh)
_crate addBackpackCargoGlobal ["B_Carryall_Base", _itm];
_crate addBackpackCargoGlobal ["B_AssaultPack_blk", _itm];
_crate addBackpackCargoGlobal ["B_Kitbag_mcamo", _itm];

// Misc items
_crate addItemCargoGlobal ["ItemMap", _itm];
_crate addItemCargoGlobal ["ItemWatch", _itm];
_crate addItemCargoGlobal ["ItemCompass", _itm];
if ADF_mod_ACE3 then {
	_crate addItemCargoGlobal ["ACE_UAVBattery", 1];
	_crate addItemCargoGlobal ["ACE_EarPlugs", 5];
	_crate addItemCargoGlobal ["ace_mapTools", _itm];
};
