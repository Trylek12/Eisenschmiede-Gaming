#include "..\script_macros.hpp"
/*
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Guts the animal?
*/
private["_animalCorpse","_upp","_ui","_progress","_pgText","_cP","_displayName","_item"];
_animalCorpse = param [0,ObjNull,[ObjNull]];
if(isNull _animalCorpse) exitWith {}; //Object passed is null?

ES_interrupted = false;
if(player distance _animalCorpse > 3.5) exitWith {};
ES_action_inUse = true;

switch(typeOf _animalCorpse) do {
	case "Hen_random_F": {_displayName = "Chicken"; _item = "hen_raw";};
	case "Cock_random_F": {_displayName = "Rooster"; _item = "rooster_raw";};
	case "Goat_random_F": {_displayName = "Goat"; _item = "goat_raw";};
	case "Sheep_random_F": {_displayName = "Sheep"; _item = "sheep_raw";};
	case "Rabbit_F": {_displayName = "Rabbit"; _item = "rabbit_raw";};
	default {_displayName = ""; _item = "";};
};

if(EQUAL(_displayName,"")) exitWith {ES_action_inUse = false;};

_upp = format["Gutting %1",_displayName];
//Setup our progress bar.
disableSerialization;
5 cutRsc ["ES_progress","PLAIN"];
_ui = uiNamespace getVariable "ES_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format["%2 (1%1)...","%",_upp];
_progress progressSetPosition 0.01;
_cP = 0.01;

while{true} do {
	if(animationState player != "AinvPknlMstpSnonWnonDnon_medic_1") then {
		[player,"AinvPknlMstpSnonWnonDnon_medic_1",true] remoteExec ["ES_fnc_animSync",-2];
		player switchMove "AinvPknlMstpSnonWnonDnon_medic_1";
		player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";
	};
	uiSleep 0.15;
	_cP = _cP + 0.01;
	_progress progressSetPosition _cP;
	_pgText ctrlSetText format["%3 (%1%2)...",round(_cP * 100),"%",_upp];
	if(_cP >= 1) exitWith {};
	if(!alive player) exitWith {};
	if(isNull _animalCorpse) exitWith {};
	if(player != vehicle player) exitWith {};
	if(ES_interrupted) exitWith {};
};
		
ES_action_inUse = false;
5 cutText ["","PLAIN"];
player playActionNow "stop";
if(isNull _animalCorpse) exitWith {ES_action_inUse = false;};
if(ES_interrupted) exitWith {ES_interrupted = false; titleText[localize "STR_NOTF_ActionCancel","PLAIN"]; ES_action_inUse = false;};
if(player != vehicle player) exitWith {titleText[localize "STR_NOTF_RepairingInVehicle","PLAIN"];};

if(([true,_item,1] call ES_fnc_handleInv)) then {
	deleteVehicle _animalCorpse;
	titleText [format["You have collected some raw %1 meat",_displayName],"PLAIN"];
} else {
	titleText ["Your inventory is full","PLAIN"];
};