#include "macros.hpp"
/**
 * PerformanceMonitir - clientInit
 * 
 * Author: Raven
 * 
 * Description:
 * Initializes the performance monitor on the client-side
 * 
 * Parameter(s):
 * 0: None <Any>
 * 
 * Return Value:
 * None <Any>
 * 
 */

#define CLIENT_UPDATE_INTERVAL 10

GVAR(recursiveInfoSending) = {
	// abort if sending is turned off
	if (!GVAR(isSendingPerformanceInfo)) exitWith {};
	
	// send one right away
	[] call GVAR(sendInfo);
	
	// schedule for regular sendings
	[GVAR(recursiveInfoSending), CLIENT_UPDATE_INTERVAL, []] call CFUNC(wait);
};

[
	"missionStarted",
	{		
		// delay according to sender group
		private _delay = diag_tickTime random SENDER_GROUP_COUNT;
		
		[
			{
				// wait at least until the frame-buffer has been completely filled before sending perf. info to server
				[
					GVAR(toggleSendingPerformanceInfo),
					FRAMEBUFFER_SIZE,
					[]
				] call CFUNC(skipFrames);
			},
			_delay,
			[]
		] call CFUNC(wait);
	}
] call CFUNC(addEventHandler);