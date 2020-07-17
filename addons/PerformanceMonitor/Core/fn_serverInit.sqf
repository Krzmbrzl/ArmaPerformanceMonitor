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
		_this select 0 params["_sender", "_fps"];
		
		"logger" callExtension format ["%1;%2;", _sender, _fps];
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