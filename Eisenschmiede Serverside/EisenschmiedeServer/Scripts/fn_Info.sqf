_mode = param [0,-1,[-1]];

disableSerialization;
_menuContent = getArray(missionConfigFile >> "ES_Settings" >> "infoMenu");

if(_mode == 0) then {
	if (!(isNull (findDisplay 133337))) exitWith {};
	createDialog "ES_infoMenu";
	_dialog = findDisplay 133337;
	_contentList = _dialog displayCtrl 1997;
	{
		_contentList lbAdd (_x select 0);
	} forEach _menuContent;

} else {

	_dialog = findDisplay 133337;
	if(isNull _dialog) exitWith {};
	_contentList = _dialog displayCtrl 1997;
	_content = _dialog displayCtrl 121212;
	_title = _dialog displayCtrl 1342;
	_curSel = lbCurSel _contentList;
	_title ctrlSetText ((_menuContent select _curSel) select 1);
	_content ctrlSetStructuredText parseText ((_menuContent select _curSel) select 2);
};
