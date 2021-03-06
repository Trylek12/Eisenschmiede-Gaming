#include "..\script_macros.hpp"
/*
	File: fn_receiveMoney.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Receives money
*/

params [
	["_unit",objNull,[objNull]],
	["_val","",[""]],
	["_from",objNull,[objNull]]
];

if(isNull _unit OR isNull _from OR EQUAL(_val,"")) exitWith {};
if(player != _unit) exitWith {};
if(!([_val] call ES_fnc_isnumber)) exitWith {};
if(_unit == _from) exitWith {}; //Bad boy, trying to exploit his way to riches.

hint format[localize "STR_NOTF_GivenMoney",_from getVariable ["realname",name _from],[(parseNumber (_val))] call ES_fnc_numberText];
ES_cash = ES_cash + parseNumber(_val);
