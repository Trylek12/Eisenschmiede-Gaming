#include "..\script_macros.hpp"
/*
	File: fn_removeLicenses.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Used for stripping certain licenses off of civilians as punishment.
*/
private "_state";
_state = param [0,1,[0]];

switch (_state) do {
	//Death while being wanted
	case 0: {
		missionNamespace setVariable [LICENSE_VARNAME("rebel","civ"),false];
		missionNamespace setVariable [LICENSE_VARNAME("driver","civ"),false];
		missionNamespace setVariable [LICENSE_VARNAME("heroin","civ"),false];
		missionNamespace setVariable [LICENSE_VARNAME("marijuana","civ"),false];
		missionNamespace setVariable [LICENSE_VARNAME("coke","civ"),false];
	};
	
	//Jail licenses
	case 1: {
		missionNamespace setVariable [LICENSE_VARNAME("gun","civ"),false];
		missionNamespace setVariable [LICENSE_VARNAME("driver","civ"),false];
		missionNamespace setVariable [LICENSE_VARNAME("rebel","civ"),false];
	};
	
	//Remove motor vehicle licenses
	case 2: {
		if(missionNamespace getVariable LICENSE_VARNAME("driver","civ") OR missionNamespace getVariable LICENSE_VARNAME("air","civ") OR missionNamespace getVariable LICENSE_VARNAME("truck","civ") OR missionNamespace getVariable LICENSE_VARNAME("boat","civ")) then {			
			missionNamespace setVariable [LICENSE_VARNAME("air","civ"),false];
			missionNamespace setVariable [LICENSE_VARNAME("driver","civ"),false];
			missionNamespace setVariable [LICENSE_VARNAME("truck","civ"),false];
			missionNamespace setVariable [LICENSE_VARNAME("boat","civ"),false];
			hint localize "STR_Civ_LicenseRemove_1";
		};
	};
	
	//Killing someone while owning a gun license
	case 3: {
		if(missionNamespace getVariable LICENSE_VARNAME("gun","civ")) then {
			missionNamespace setVariable [LICENSE_VARNAME("gun","civ"),false];
			hint localize "STR_Civ_LicenseRemove_2";
		};
	};

	//Remove driver vehicle licenses
	case 4: {
		missionNamespace setVariable [LICENSE_VARNAME("driver","civ"),false];
	};
};