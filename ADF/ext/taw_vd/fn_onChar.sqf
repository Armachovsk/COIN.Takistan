#include "defines.h"
/*
	Author: Bryan "Tonic" Boardwine
	
	Description:
	When a character is entered it is validated and changes the
	correct slider it is associated with. I probably over-complicated
	this more then I had to but onChar behaves weird.
	
	PARAMS:
		0: CONTROL
		1: SCALAR (INT)
		2: STRING (Case option)
*/

params [
	"_control",
	"_code",
	"_slider"
];

disableSerialization;
if(isNull _control) exitWith {}; //POOOOOP

private _maxRange = if(!isNil "tawvd_maxRange") then {tawvd_maxRange} else {20000};
private _value = parseNumber (ctrlText _control);
if (_value > _maxRange OR _value < 100) exitwith {[] call TAWVD_fnc_openMenu;};

private _varName = switch (_slider) do {
	case "vehicle":	{"tawvd_car"};
	case "air":		{"tawvd_air"};
	case "object":	{"tawvd_object"};
	case "drone":	{"tawvd_drone"};
	case "ground";
	default 			{"tawvd_foot"};
};

SVAR_MNS [_varName,_value];
[] call TAWVD_fnc_updateViewDistance;
[] call TAWVD_fnc_openMenu;