#include "..\script_macros.hpp"
/*
	File: fn_buyLicense.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Called when purchasing a license. May need to be revised.
*/
private["_type","_varName","_displayName","_sideFlag","_price"];
_type = SEL(_this,3);

if(!isClass (missionConfigFile >> "Licenses" >> _type)) exitWith {}; //Bad entry?
_varName = M_CONFIG(getText,"Licenses",_type,"variable");
_displayName = M_CONFIG(getText,"Licenses",_type,"displayName");
_price = M_CONFIG(getNumber,"Licenses",_type,"price");
_sideFlag = M_CONFIG(getText,"Licenses",_type,"side");
_varName = LICENSE_VARNAME(_varName,_sideFlag);

if(ES_cash < _price) exitWith {hint format[localize "STR_NOTF_NE_1",[_price] call ES_fnc_numberText,localize _displayName];};
ES_cash = ES_cash - _price;

titleText[format[localize "STR_NOTF_B_1", localize _displayName,[_price] call ES_fnc_numberText],"PLAIN"];
missionNamespace setVariable [_varName,true];

["Lizenzkauf"] call ES_fnc_xp_add;
playSound "kaufen";

_toLog = format ["Name: %1 (%2) hat Lizenz: %3 für: %4 $ gekauft", player getVariable["realname",name player], getPlayerUID player, localize _displayName, [_price] call ES_fnc_numberText];
["LIZENZ_LOG",_toLog] remoteExecCall ["ES_fnc_logIt",2];