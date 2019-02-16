#include "macros.hpp"
/**
 * PerformanceMonitir - init
 * 
 * Author: Raven
 * 
 * Description:
 * Initializes the performance monitor
 * 
 * Parameter(s):
 * 0: None <Any>
 * 
 * Return Value:
 * None <Any>
 * 
 */
 
GVAR(maxFPS) = -1;
GVAR(minFPS) = 2000;
GVAR(FrameBuffer) = [];
GVAR(FrameBuffer) resize FRAMEBUFFER_SIZE;
GVAR(FrameBuffer) = GVAR(FrameBuffer) apply {0};
GVAR(performanceInfoCollector) = -1;

GVAR(isSendingPerformanceInfo) = false;

GVAR(sendInfo) = {
	// calculate avg FPS
	private _avg = 0;
	{
		_avg = _avg + _x;
		nil;
	} count GVAR(FrameBuffer);
	_avg = _avg / FRAMEBUFFER_SIZE;
	
	[PERF_INFO_RECEIVE, [[name player, "__Server"] select isServer, GVAR(minFPS), GVAR(maxFPS), _avg]] call CFUNC(serverEvent);
};

GVAR(toggleSendingPerformanceInfo) = {
	if (GVAR(isSendingPerformanceInfo)) then {
		// turn sending off
		GVAR(isSendingPerformanceInfo) = false;
	} else {
		// turn sending on
		GVAR(isSendingPerformanceInfo) = true;
		
		[] call GVAR(recursiveInfoSending);
	};
};

[
	"missionStarted",
	{
		// set up a PFH to collect FPS information
		GVAR(performanceInfoCollector) = [{
			private _currentFPS = 1 / CGVAR(deltaTime);
			GVAR(maxFPS) = _currentFPS max GVAR(maxFPS);
			GVAR(minFPS) = _currentFPS min GVAR(minFPS);

			GVAR(FrameBuffer) deleteAt 0;
			GVAR(FrameBuffer) pushBack _currentFPS;
		}, 0, []] call CFUNC(addPerFrameHandler);
	}
] call CFUNC(addEventHandler);