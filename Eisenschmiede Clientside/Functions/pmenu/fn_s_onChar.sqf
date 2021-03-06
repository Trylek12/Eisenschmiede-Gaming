#include "..\script_macros.hpp"
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
private["_control","_code","_slider","_value","_varName","_onKeyUp"];
_control = SEL(_this,0);
_code = SEL(_this,1);
_slider = SEL(_this,2);
_onKeyUp = SEL(_this,3);

disableSerialization;
if(isNull _control) exitWith {};

if(_onKeyUp) then {
	_value = parseNumber(ctrlText _control);
	_varName = switch(_slider) do {
		case "ground": {"ES_vdFoot";};
		case "vehicle": {"ES_vdCar"};
		case "air": {"ES_vdAir"};
		default {"ES_vdFoot"};
	};

	missionNamespace setVariable [_varName,_value];
	[] call ES_fnc_settingsMenu;
	[] call ES_fnc_updateViewDistance;
};