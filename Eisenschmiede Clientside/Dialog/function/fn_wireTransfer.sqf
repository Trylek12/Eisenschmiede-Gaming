#include "..\script_macros.hpp"
/*
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Initiates the wire-transfer
*/
params [
	["_value",0,[0]],
	["_from","",[""]]
];

if(EQUAL(_value,0) OR EQUAL(_from,"") OR EQUAL(_from,profileName)) exitWith {}; //No
ES_atmbank = ES_atmbank + _value;

hint format["%1 has wire transferred $%2 to you",_from,[_value] call ES_fnc_numberText];