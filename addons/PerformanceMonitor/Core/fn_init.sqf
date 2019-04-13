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
 
GVAR(overallMaxFPS) = -1;
GVAR(overallMinFPS) = 2000;
GVAR(FrameBuffer) = [];
GVAR(FrameBuffer) resize FRAMEBUFFER_SIZE;
GVAR(FrameBuffer) = GVAR(FrameBuffer) apply {0};
GVAR(performanceInfoCollector) = -1;

GVAR(isSendingPerformanceInfo) = false;

GVAR(sendInfo) = {
	// pre-sort framebuffer
	true sort GVAR(FrameBuffer);
	
	// use the the lowest/highest 10% for the min/max values but at least 3 frames
	private _minMaxWindow = (FRAMEBUFFER_SIZE * 0.1) min 3;
	
	// calculate avg FPS
	private _max = 0;
	private _min = 0;
	private _avg = 0;
	{
		_avg = _avg + _x;
		
		if (_foreachIndex <= _minMaxWindow) then {
			_min = _min + _x;
		} else {
			if (_foreachIndex >= FRAMEBUFFER_SIZE - _minMaxWindow) then {
				_max = _max + _x;
			};
		}
	} forEach GVAR(FrameBuffer);
	_avg = _avg / FRAMEBUFFER_SIZE;
	_max = _max / _minMaxWindow;
	_min = _min / _minMaxWindow;
	
	[PERF_INFO_RECEIVE, [[name player, "__Server"] select isServer, _min, _max, _avg]] call CFUNC(serverEvent);
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
			GVAR(overallMaxFPS) = _currentFPS max GVAR(overallMaxFPS);
			GVAR(overallMinFPS) = _currentFPS min GVAR(overallMinFPS);

			GVAR(FrameBuffer) deleteAt 0;
			GVAR(FrameBuffer) pushBack _currentFPS;
		}, 0, []] call CFUNC(addPerFrameHandler);
	}
] call CFUNC(addEventHandler);