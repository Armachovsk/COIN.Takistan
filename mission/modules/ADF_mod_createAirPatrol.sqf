/*********************************************************************************
 _____ ____  _____ 
|  _  |    \|   __|
|     |  |  |   __|
|__|__|____/|__|   
ARMA Mission Development Framework
ADF version: 2.26 / Jul 2020

Module: Create Air Patrol
Author: Whiztler
Module version: 1.14

File: ADF_mod_createAirPatrol.sqf
**********************************************************************************
This module creates a crewed aircraft that patrols a given position/radius. The 
module creates waypoints in a given radius. You can define the type of aircraft.

INSTRUCTIONS:
Execute the module on the SERVER or HC only!
*********************************************************************************/

/****  vv  COPY FROM HERE TILL THE END  vv  *****/
///// DO NOT EDIT BELOW
diag_log "ADF rpt: Init - executing: ADF_mod_createAirPatrol.sqf";
///// DO NOT EDIT ABOVE

/*
	Step 1:	Copy from (COPY FROM HERE) into your script for each air patrol you want to create.
	Step 2:	Determine a location where the aircraft will spawn. This can be a marker, an editor placed object, trigger, etc.
			Note that the aircraft will spawn airborne, fully crewed with pilot/gunner(s)			
	Step 3.	Fill out below parameters
    Note: Don't worry about the many comments as the ARMA engine ignores comments.
*/

"myMarker",         // Spawn location. This is the location on the map where the patrol units will be created. The location can be a marker, trigger, object, etc:
                    // - "myMarker" use the name of the marker to span an airborne aircraft on the marker location. Markers are always a string ("")
                    // - myTrigger use the name of the trigger to spawn an airborne aircraft at the trigger location (center). 
                    // - myObject use the name of an editor placed object to spawn the aircraft (airborne)
                    
"PatrolMarker",     // Patrol start location. Can be the same as the spawn location. If you want a different location than the spawn location than use:
                    // - "PatrolMarker" use the name of the marker where units will move to after they have spawned. Markers are always a string ("")
                    // - myTrigger use the name of the trigger here units will move to after they have spawned. (center). 
                    // - myObject use the name of an editor placed object where units will move to after they have spawned.
                    
east,               // Side of the aircraft and its crew. Can be east, west or independent

2,                  // Number that represents the type of aircraft. Options are 
					// In case you want to use a specific aircraft then you can use the class name of the aircraft (string): "aircraftClassname"