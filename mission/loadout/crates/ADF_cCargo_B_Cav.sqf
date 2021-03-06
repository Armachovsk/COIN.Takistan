/*********************************************************************************
 _____ ____  _____
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|
ARMA Mission Development Framework
ADF version: 2.26 / Jul 2020

Script: Crate Cargo Script (BLUEFOR) - Cavalry Squadron (Knight)
Author: Whiztler
Script version: 2.0

Game type: n/a
File: ADF_cCargo_B_Cav.sqf
**********************************************************************************
INSTRUCTIONS::

Paste below line in the INITIALIZATION box of the crate:
null = [this] execVM "mission\loadout\crates\ADF_cCargoGlobal_B_Cav.sqf";

You can comment out (//) lines of ammo you do not want to include
in the vehicle Cargo.
*********************************************************************************/

if !isServer exitWith {};

waitUntil {time > 0 && !isNil "ADF_preInit"};

// Init
params ["_crate"];

_crate allowDamage false;
private _wpn = 3; 	// Regular Weapons
private _spw = 1; 	// Special Purpose Weapons
private _lau = 1;		// Launchers
private _mag = 15;	// Magazines
private _dem = 1;		// Demo/Explosives
private _mis = 1;		// Missiles/Rockets
private _itm = 3;		// Items
private _uni = 1;		// Uniform/Vest/Backpack/etc

// Empty vehicle CargoGlobal contents on init
_crate call ADF_fnc_stripVehicle;

// Primary weapon
_crate addWeaponCargoGlobal ["arifle_MXC_F", _wpn]; // Carbine

// Secondary weapon
_crate addWeaponCargoGlobal ["hgun_P07_F", _wpn];

// Magazines primary weapon
_crate addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag", _mag];

// Magazines secondary weapon
_crate addMagazineCargoGlobal ["16Rnd_9x21_Mag", _mag];

// Launchers
if (!ADF_mod_ACE3) then {_crate addweaponCargoGlobal ["launch_NLAW_F", _lau]};

// Rockets/Missiles
_crate addMagazineCargoGlobal ["NLAW_F", _mis];

// Demo/Explosives
_crate addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", _dem];
_crate addMagazineCargoGlobal ["ATMine_Range_Mag", _dem];
_crate addItemCargoGlobal ["MineDetector", _itm];
if ADF_mod_ACE3 then {
	_crate addItemCargoGlobal ["ACE_Clacker", _dem];
	_crate addItemCargoGlobal ["ACE_DefusalKit", _dem];
};

// Weapon mountings
_crate addItemCargoGlobal ["acc_pointer_IR", _itm];
_crate addItemCargoGlobal ["optic_ACO", _itm];
_crate addItemCargoGlobal ["optic_MRCO", _itm];
_crate addItemCargoGlobal ["optic_Holosight", _itm];
_crate addItemCargoGlobal ["acc_flashlight", _itm];

// GL Ammo

// Grenades/Chemlights
_crate addMagazineCargoGlobal ["MiniGrenade", _mag];
_crate addMagazineCargoGlobal ["SmokeShell", _mag];
_crate addMagazineCargoGlobal ["SmokeShellGreen", _mag];
_crate addMagazineCargoGlobal ["SmokeShellRed", _mag];
_crate addMagazineCargoGlobal ["Chemlight_green", _mag];
_crate addMagazineCargoGlobal ["Chemlight_red", _mag];
_crate addMagazineCargoGlobal ["B_IR_Grenade", _mag];

// Medical Items
if ADF_mod_ACE3 then {
	_crate addItemCargoGlobal ["ACE_fieldDressing", _mag];
	_crate addItemCargoGlobal ["ACE_morphine", _itm];
	_crate addItemCargoGlobal ["ACE_packingBandage", _itm];
	_crate addItemCargoGlobal ["ACE_elasticBandage", _itm];
} else {
	_crate addItemCargoGlobal ["FirstAidKit", _mag];
};

// Optical/Bino's/Goggles
_crate addWeaponCargoGlobal ["Binocular", _itm];
_crate addItemCargoGlobal ["NVGoggles", _itm];

// ACRE and cTAB
if ADF_mod_ACRE then {
	_crate addItemCargoGlobal ["ACRE_PRC343", _itm];
	_crate addItemCargoGlobal ["ACRE_PRC148", 1];
};
if ADF_mod_TFAR then {
	_crate addItemCargoGlobal ["tf_anprc152", _itm];
	//_crate addItemCargoGlobal ["tf_rt1523g", 3];
	_crate addBackpackCargoGlobal ["tf_rt1523g", 1];
};
if (!ADF_mod_ACRE && !ADF_mod_TFAR) then {_crate addItemCargoGlobal ["ItemRadio", _itm]};
if ADF_mod_CTAB then {
	_crate addItemCargoGlobal ["ItemAndroid", 1];
	_crate addItemCargoGlobal ["ItemcTabHCam", _itm];
};

// Misc items
_crate addItemCargoGlobal ["ItemGPS", _itm];
_crate addItemCargoGlobal ["ItemMap", _itm];
_crate addItemCargoGlobal ["ItemWatch", _itm];
_crate addItemCargoGlobal ["ItemCompass", _itm];
_crate addItemCargoGlobal ["ToolKit", _itm];
if ADF_mod_ACE3 then {
	_crate addItemCargoGlobal ["ACE_EarPlugs", _itm];
	_crate addItemCargoGlobal ["ace_mapTools", _itm];
	_crate addItemCargoGlobal ["ACE_CableTie", _itm];
};
