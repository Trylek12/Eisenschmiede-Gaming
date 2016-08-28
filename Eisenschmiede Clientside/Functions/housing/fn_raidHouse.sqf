#include "..\script_macros.hpp"
/*
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Raids the players house?
*/
private["_house","_uid","_cpRate","_cP","_title","_titleText","_ui","_houseInv","_houseInvData","_houseInvVal"];
_house = param [0,ObjNull,[ObjNull]];

if(isNull _house OR !(_house isKindOf "House_F")) exitWith {};
if(isNil {(_house getVariable "house_owner")}) exitWith {hint localize "STR_House_Raid_NoOwner"};

_uid = SEL((_house getVariable "house_owner"),0);

if(!([_uid] call ES_fnc_isUIDActive)) exitWith {hint localize "STR_House_Raid_OwnerOff"};

_houseInv = _house getVariable ["Trunk",[[],0]];
if(_houseInv isEqualTo [[],0]) exitWith {hint localize "STR_House_Raid_Nothing"};
ES_action_inUse = true;

//Setup the progress bar
disableSerialization;
_title = localize "STR_House_Raid_Searching";
5 cutRsc ["ES_progress","PLAIN"];
_ui = uiNamespace getVariable "ES_progress";
_progressBar = _ui displayCtrl 38201;
_titleText = _ui displayCtrl 38202;
_titleText ctrlSetText format["%2 (1%1)...","%",_title];
_progressBar progressSetPosition 0.01;
_cP = 0.01;
_cpRate = 0.0075;

while {true} do
{
	sleep 0.26;
	if(isNull _ui) then {
		5 cutRsc ["ES_progress","PLAIN"];
		_ui = uiNamespace getVariable "ES_progress";
	};
	_cP = _cP + _cpRate;
	_progressBar progressSetPosition _cP;
	_titleText ctrlSetText format["%3 (%1%2)...",round(_cP * 100),"%",_title];
	if(_cP >= 1 OR !alive player) exitWith {};
	if(player distance _house > 13) exitWith {};
};

//Kill the UI display and check for various states
5 cutText ["","PLAIN"];
if(player distance _house > 13) exitWith {ES_action_inUse = false; titleText[localize "STR_House_Raid_TooFar","PLAIN"]};
if(!alive player) exitWith {ES_action_inUse = false;};
ES_action_inUse = false;

_houseInvData = SEL(_houseInv,0);
_houseInvVal = SEL(_houseInv,1);
_value = 0;
{
	_var = SEL(_x,0);
	_val = SEL(_x,1);
	
	if(EQUAL(ITEM_ILLEGAL(_var),1)) then {
		if(!(EQUAL(ITEM_SELLPRICE(_var),-1))) then {
			_houseInvData set[_forEachIndex,-1];
			
			_houseInvData = _houseInvData - [-1];
			_houseInvVal = _houseInvVal - (([_var] call ES_fnc_itemWeight) * _val);
			_value = _houseInvData + (_val * ITEM_SELLPRICE(_var));	
		};
	};
} foreach (SEL(_houseInv,0));

if(_value > 0) then {
	[0,"STR_House_Raid_Successful",true,[[_value] call ES_fnc_numberText]] remoteExec ["ES_fnc_broadcast",-2];
	ES_atmbank = ES_atmbank + round(_value / 2);
	
	_house setVariable ["Trunk",[_houseInvData,_houseInvVal],true];
	[_house] remoteExec ["ES_fnc_updateHouseTrunk",2];
} else {
	hint localize "STR_House_Raid_NoIllegal";
};