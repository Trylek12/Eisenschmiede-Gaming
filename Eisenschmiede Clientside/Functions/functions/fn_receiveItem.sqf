#include "..\script_macros.hpp"
/*
	File: fn_receiveItem.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Receive an item from a player.
*/
private["_unit","_val","_item","_from","_diff"];
_unit = SEL(_this,0);
if(_unit != player) exitWith {};
_val = SEL(_this,1);
_item = SEL(_this,2);
_from = SEL(_this,3);

_diff = [_item,(parseNumber _val),ES_carryWeight,ES_maxWeight] call ES_fnc_calWeightDiff;

if(!(EQUAL(_diff,(parseNumber _val)))) then {
	if(([true,_item,_diff] call ES_fnc_handleInv)) then {
		hint format[localize "STR_MISC_TooMuch_3",_from getVariable ["realname",name _from],_val,_diff,((parseNumber _val) - _diff)];
		[_from,_item,str((parseNumber _val) - _diff),_unit] remoteExec ["ES_fnc_giveDiff",_from];
	} else {
		[_from,_item,_val,_unit,false] remoteExec ["ES_fnc_giveDiff",_from];
	};
} else {
	if(([true,_item,(parseNumber _val)] call ES_fnc_handleInv)) then {
		private "_type";
		_type = M_CONFIG(getText,"VirtualItems",_item,"displayName");
		hint format[localize "STR_NOTF_GivenItem",_from getVariable ["realname",name _from],_val,(localize _type)];
	} else {
		[_from,_item,_val,_unit,false] remoteExec ["ES_fnc_giveDiff",_from];
	};
};

if(_item == "ring" && ES_married != "-2") then{     ES_married = (_from getVariable["realname",name _from]);};