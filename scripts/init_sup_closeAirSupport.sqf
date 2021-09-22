/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.26 / Jul 2020

Script: COIN Close Air Support
Author: Whiztler
Script version: 0.92

File: init_sup_closeAirSupport.sqf
**********************************************************************************
DO NOT edit this file. This is part of the COIN mission code base.

CAS script based on the BIS ARMA 3 CAS Module (BIS_fnc_module_cas)
********************************************************************************/

if hasInterface then {
	COIN_fnc_msg_viper = {
		params [
			"_eta",
			["_position", [], [[]]],
			["_vector", 94, [0]],
			"_vectorOffset",
			"_distance",
			"_direction",
			"_nato1",
			"_nato2",
			"_bp",
			"_egress",
			"_targetDesc"
		];
		private _altitude = ATLToASL _position;		
		sleep 6;
		["BCO", "VIPER", localize "STR_ADF_supp_stanbyForMsg"] call ADF_fnc_MessageParser;
		sleep 8;
		["VIPER", "BCO", selectRandom [localize "STR_ADF_supp_readyToCopy1", localize "STR_ADF_supp_readyToCopy2", localize "STR_ADF_supp_readyToCopy3"]] call ADF_fnc_MessageParser;
		sleep 8;
		private _order = format [localize "STR_ADF_supp_viper1", _bp, _vector, _vectorOffset, _distance, mapGridPosition _position, round (_altitude # 2), _targetDesc, _direction, _egress];
		["BCO", "VIPER", format [localize "STR_ADF_supp_howCopy", _order]] call ADF_fnc_MessageParser;
		sleep 11;
		["VIPER", "BCO", format [localize "STR_ADF_supp_readBack", _order]] call ADF_fnc_MessageParser;
		sleep 12;
		["BCO", "VIPER", localize "STR_ADF_supp_readBackCorrect"] call ADF_fnc_MessageParser;
		sleep 9;
		["VIPER", "BCO", format [localize "STR_ADF_supp_eta", round (_eta / 60)]] call ADF_fnc_MessageParser;
		if ADF_MissionTest then {sleep 10} else {sleep (_eta - 15);};
		COIN_viperActive = true;
		publicVariableServer "COIN_viperActive";		
		["VIPER", "BCO", localize "STR_ADF_supp_viper2"] call ADF_fnc_MessageParser;
		sleep 30;
		private _service = selectRandom [localize "STR_ADF_supp_viper3", localize "STR_ADF_supp_viper4", localize "STR_ADF_supp_viper5", localize "STR_ADF_supp_viper6", localize "STR_ADF_supp_viper7"];
		["VIPER", "BCO", format [localize "STR_ADF_supp_viper9", _service]] call ADF_fnc_MessageParser;
		sleep 12;
		["BCO", "VIPER", localize "STR_ADF_supp_thanks"] call ADF_fnc_MessageParser;

		if !(player isEqualTo COIN_leadership) exitWith {};
		// wait for 15-30 minutes and then re-add the menu options to the leadership player
		if !ADF_missionTest then {
			private _timer = time + ((15 *60) + (random (15 * 60)));
			waitUntil {sleep 1; time > _timer || !alive COIN_leadership};
		}; 
		call COIN_fnc_assignViper;				
	};
	
	COIN_fnc_airSupportRequest = {
		// Init
		params ["_unit", "_index"];
		
		if COIN_supportActive exitWith {systemChat localize "STR_ADF_supp_supportActive"};
		COIN_supportActive = true;

		// Map click process.
		openMap true;
		hint parseText format [localize "STR_ADF_supp_viper8", name _unit];		
		[_unit, _index] onMapSingleClick {
			params [
				"_unit",
				"_index"
			];
			private _direction = (getDirVisual _unit) + (selectRandom [90, 270]);
			[_unit, _pos, _direction] remoteExec ["COIN_fnc_spawnAirSupport", 2];
			_unit removeAction _index;			
			onMapSingleClick ""; true;
			openMap false; hintSilent "";
		};	
	};
	
	///// ASSIGN VIPER TO THE LEADERSHIP PLAYER

	COIN_fnc_assignViper = {
		airsupportActionID = COIN_leadership addAction [
			localize "STR_ADF_supp_viperSuppMenu",{
				[_this # 1, _this # 2] call COIN_fnc_airSupportRequest
			}, [], -95, false, true, "", ""
		];
	};
};

if isServer then {
	COIN_fnc_spawnAirSupport = {
		// init
		params [
			["_unit", objNull, [objNull]],
			["_position", [0, 0, 0], [[]]],
			["_vector", 0, [0]],
			["_hardTarget", false, [true]],
			["_allTargets", [], [[]]],
			["_closestTarget", objNull, [objNull]],
			["_closestTargetDist", 50, [0, []]],
			["_targetDesc", "", [""]]
		];		
		private _airframeClass = if ADF_mod_RHS then {"RHS_A10"} else {"CUP_B_A10_DYN_USA"};
		private _airframeCfg = configfile >> "cfgvehicles" >> _airframeClass;
		private _weaponTypes = ["machinegun", "missilelauncher"];
		private _exitPosition = getMarkerPos (selectRandom COIN_ambientAirSpawn);
		private _airframeArsenal = [];
		private _distance = 3000;
		private _altitude = 1000;
		private _pitch = atan (_altitude / _distance);
		private _speed = 400 / 3.6;
		private _duration = ([0, 0] distance [_distance, _altitude]) / _speed;
		
		// HARD TARGET OR LOCATION POSITION
		
		// See if there's any enemy hard targets at the position and if the found targets are enemy combat vehicles. 
		private _targetObjects = _position nearEntities [["CAR", "APC", "TANK"], 50];
		
		{
			if ((side _x isEqualTo east) && {canFire _x && {canMove _x}}) then {_allTargets pushBack _x};
		} forEach _targetObjects;
		
		if !(_allTargets isEqualTo []) then {
			_hardTarget = true;
			
			// Just 1 target?
			if (count _allTargets isEqualTo 1) then {
				_closestTarget = _allTargets # 0;
			} else {
				_closestTarget = _allTargets # 0;
				// Get the closest hard target to the clicked position.
				{
					private _targetDistance = (getPosWorld _x) distance _position;
					if (_targetDistance < _closestTargetDist) then {
						_closestTargetDist = _targetDistance;
						_closestTarget = _x;
					}			
				} forEach _allTargets;			
			};

			_targetDesc = getText(configFile >> "CfgVehicles" >> (typeOf _closestTarget) >> "displayName");
		} else {
			_targetDesc = "foot mobiles";
		};
		
		private _eta = round (60 * (1 + (random 2)));
		private _nato = ["ALFA", "BRAVO", "CHARLIE", "DELTA", "ECHO", "FOXTROT", "GOLF", "HOTEL", "INDIA", "JULIETT", "KILO", "LIMA", "MIKE", "NOVEMBER", "OSCAR", "PAPA", "QUEBEC", "ROMEO", "SIERRA", "TANGO", "UNIFORM", "VICTOR", "WHISKEY", "X-RAY", "YANKEE", "ZULU"];
		private _bp = format ["%1-%2", selectRandom ["ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE"], selectRandom _nato];
		private _egress = if (_vector < 181) then {round (_vector + 180)} else {round (_vector - 180)};
		[_eta, _position, _vector, selectRandom ["left", "right"], round (3 + (random 8)), round (random 360), selectRandom _nato, selectRandom _nato, _bp, _egress, _targetDesc] remoteExec ["COIN_fnc_msg_viper", 0];

		// Create target area for VIPER. In case of a hard target, attach the target to the (moving) object
		private _target = createVehicle ["LaserTargetW", [0, 0, 0], [], 0, "CAN_COLLIDE"];
		if _hardTarget then {
			_target attachTo [_closestTarget, [0,0,0]];
		} else {
			_target setPosATL _position;
			_target setDir _vector;
			_target enableSimulationGlobal false;
		};				
		_target hideObjectGlobal true;

		// Wait untill 9-liners are finished
		waitUntil {sleep 0.5; COIN_viperActive};

		// Delete the simulation object after 60 seconds
		[_target, _hardTarget] spawn {
			params ["_target", "_hardTarget"];			
			sleep 60;
			if _hardTarget then {detach _target};
			[_target] call ADF_fnc_delete;
			sleep 60;
			COIN_supportActive = false;
			COIN_leadershipID publicVariableClient "COIN_supportActive";
		};
		
		// Create VIPER (adapted from BIS_module_CAS)
		private _positionATL = getPosATL _target;
		private _position = +_positionATL;
		private _direction = direction _target;
		private _airframePosition = [_position, _distance, _direction + 180] call BIS_fnc_relPos;
		
		_position set [2, (_position # 2) + getTerrainHeightASL _position];
		_airframePosition set [2, (_position # 2) + _altitude];
		
		{
			if (tolower ((_x call BIS_fnc_itemType) # 1) in _weaponTypes) then {
				_modes = getarray (configfile >> "cfgweapons" >> _x >> "modes");
				if (count _modes > 0) then {
					_mode = _modes # 0;
					if (_mode == "this") then {_mode = _x;};
					_airframeArsenal set [count _airframeArsenal, [_x, _mode]];
				};
			};
		} foreach (_airframeClass call BIS_fnc_weaponsEntityType);


		///// CREATE AND POSITION AIRCRAFT

		private _airframeArray = [_airframePosition, _direction, _airframeClass, west] call BIS_fnc_spawnVehicle;
		private _airframe = _airframeArray # 0;
		private _pilot = driver _airframe;
		_airframe setPosASL _airframePosition;
		_airframe move ([_position, _distance, _direction] call BIS_fnc_relPos);
		_pilot call ADF_fnc_heliPilotAI;  

		private _vectorDir = [_airframePosition, _position] call BIS_fnc_vectorFromXToY;
		private _velocity = [_vectorDir, _speed] call BIS_fnc_vectorMultiply;
		_airframe setVectorDir _vectorDir;
		[_airframe, -90 + atan (_distance / _altitude), 0] call BIS_fnc_setPitchBank;
		private _vectorUp = vectorUp _airframe;
		
		[_airframe] spawn {
			params ["_airframe"];
			private _mViper = createMarker ["_mViperCAS", getPosWorld _airframe];
			_mViper setMarkerShape "ICON";
			_mViper setMarkerType "b_plane";
			_mViper setMarkerSize [1 ,1];
			_mViper setMarkerColor "ColorWEST";
			_mViper setMarkerDir 0;
			
			waitUntil {
				sleep 0.1;
				_mViper setMarkerPos (getPosWorld _airframe);
				if ADF_MissionTest then {systemChat format ["VIPER -- speed: %1 -- alt: %2", round (speed _airframe), round ((getPosATL _airframe) # 2)];};
				!alive _airframe 
			};
			[_mViper] call ADF_fnc_delete;			
		};

		////// ARSENAL
		
		private _currentWeapons = weapons _airframe;
		{
			if !(tolower ((_x call BIS_fnc_itemType) # 1) in (_weaponTypes + ["countermeasureslauncher"])) then {
				_airframe removeWeapon _x;
			};
		} foreach _currentWeapons;

		///// FLIGHT 
		
		private _fire = [] spawn {waituntil {false}};
		private _fireNull = true;
		private _time = time;
		private _offset = if ({_x == "missilelauncher"} count _weaponTypes > 0) then {20} else {0};
		
		waitUntil {
			// Update flight path if target is on the move
			if (getPosATL _target distance _positionATL > 0 || direction _target != _direction) then {
				_positionATL = getPosATL _target;
				_position = +_positionATL;
				_position set [2, (_position # 2) + getTerrainHeightASL _position];
				_direction = direction _target;

				_airframePosition = [_position, _distance, _direction + 180] call BIS_fnc_relPos;
				_airframePosition set [2, (_position # 2) + _altitude];
				_vectorDir = [_airframePosition, _position] call BIS_fnc_vectorFromXToY;
				_velocity = [_vectorDir, _speed] call BIS_fnc_vectorMultiply;
				_airframe setVectorDir _vectorDir;
				_vectorUp = vectorUp _airframe;
				_airframe move ([_position, _distance, _direction] call BIS_fnc_relPos);
			};

			// Approach vector
			_airframe setVelocityTransformation [
				_airframePosition,  [_position # 0, _position # 1, (_position # 2) + _offset + 12], 
				_velocity,  _velocity, 
				_vectorDir, _vectorDir, 
				_vectorUp,  _vectorUp, 
				(time - _time) / _duration
			];
			_airframe setVelocity velocity _airframe;

			// Assault
			if ((getPosASL _airframe) distance _position < 1000 && {_fireNull}) then {
				_airframe reveal laserTarget _target;
				_airframe doWatch laserTarget _target;
				_airframe doTarget laserTarget _target;
				_fireNull = false;
				terminate _fire;
				
				_fire = [_airframe, _airframeArsenal, _target, _pilot] spawn {
					params ["_airframe", "_airframeArsenal", "_target", "_pilot"];
					private _duration = 3;
					private _time = time + _duration;
					
					waitUntil {
						{_pilot fireAtTarget [_target, (_x # 0)];} forEach _airframeArsenal;
						sleep 0.1;
						time > _time || !alive _airframe || !canMove _airframe
					};
					sleep 1;
				};
			};

			sleep 0.01;
			scriptDone _fire || !alive _target || !alive _airframe || !canMove _airframe
		};
		if (!alive (driver _airframe) || {!canMove _airframe}) exitWith {_airframe setDamage 1};

		// Chaffs
		if ({_x == "bomblauncher"} count _weaponTypes == 0) then {
			for "_i" from 0 to 1 do {
				driver _airframe forceWeaponFire ["CMFlareLauncher", "Burst"];
				_time = time + 1.1;
				waitUntil {time > _time || isNull _target || isNull _airframe};
			};
		};		
		
		// RTB
		_airframe allowDamage false;
		_airframe flyInHeight 800;
		_airframe setSpeedMode "FULL";		
		private _timeOut = time + 120;
		_exitPosition set [2, 800];
		_airframe move _exitPosition;
		waitUntil {sleep 0.5; (_airframe distance2D _exitPosition) < 300 || !alive _airframe || time > _timeOut};

		// Delete plane
		if (alive _airframe) then {[_airframe] call ADF_fnc_delete};		

	};
};