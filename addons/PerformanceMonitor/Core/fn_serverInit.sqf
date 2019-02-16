#include "macros.hpp"
/**
 * PerformanceMonitir - clientInit
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

#define SERVER_UPDATE_INTERVAL 5

[
	PERF_INFO_RECEIVE,
	{
		_this select 0 params["_sender", "_minFPS", "_maxFPS", "_avg"];
		
		"logger" callExtension format ["%1;%2;%3;%4", _sender, _minFPS, _maxFPS, _avg];
	}
] call CFUNC(addEventHandler);


GVAR(recursiveInfoSending) = {
	// abort if sending is turned off
	if (!GVAR(isSendingPerformanceInfo)) exitWith {};
	
	// send one right away
	[] call GVAR(sendInfo);
	
	// schedule for regular sendings
	[GVAR(recursiveInfoSending), SERVER_UPDATE_INTERVAL, []] call CFUNC(wait);
};

[
	"missionStarted",
	{
		// wait at least until the frame-buffer has been completely filled before sending perf. info to server
		[
			GVAR(toggleSendingPerformanceInfo),
			FRAMEBUFFER_SIZE,
			[]
		] call CFUNC(skipFrames);
		
		"logger" callExtension format["------------------------ Started %1 ------------------------", missionName];
	}
] call CFUNC(addEventHandler);