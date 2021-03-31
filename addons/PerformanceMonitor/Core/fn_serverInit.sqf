#include "macros.hpp"
/**
 * PerformanceMonitir - serverInit
 * 
 * Author: Raven
 * 
 * Description:
 * Initializes the performance monitor on the server-side
 * 
 * Parameter(s):
 * 0: None <Any>
 * 
 * Return Value:
 * None <Any>
 * 
 */

[
	PERF_INFO_RECEIVE,
	{
		_this select 0 params["_playerName", "_playerUID", "_fps"];
		private _separator = toString [9]; // tabulator
		"logger" callExtension format ["%1%2%3%4%5", _playerName, _separator, _playerUID, _separator, _fps];
	}
] call CFUNC(addEventHandler);

[
	"missionStarted",
	{
		// toggle performance monitoring on
		[] call FUNC(togglePerformanceInfoSending);
		
		"logger" callExtension format["------------------------ Started %1 ------------------------", missionName];
	}
] call CFUNC(addEventHandler);