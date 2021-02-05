#include "macros.hpp"
/**
 * PerformanceMonitir - recursiveInfoSending
 * 
 * Author: Raven
 * 
 * Description:
 * Starts recursive performance-information sending. This function will terminate if GVAR(isSendingPerformanceInfo) is set to false.
 * 
 * Parameter(s):
 * 0: None <Any>
 * 
 * Return Value:
 * None <Any>
 * 
 */


// abort if sending is turned off
if (!GVAR(isSendingPerformanceInfo)) exitWith {};

if !(GVAR(FrameWindowStartNumber) isEqualTo 0) then {
	private _numberOfFrames = diag_frameNo - GVAR(FrameWindowStartNumber);
	private _passedTime = diag_tickTime - GVAR(FrameWindowStart);
	
	// calculate FPS and send to server
	[PERF_INFO_RECEIVE, [[getPlayerUID player, "__Server"] select isServer, _numberOfFrames / _passedTime]] call CFUNC(serverEvent);
};

// set varaibles for next run
GVAR(FrameWindowStartNumber) = diag_frameNo;
GVAR(FrameWindowStart) = diag_tickTime;

// schedule for regular sendings
[FUNC(recursiveInfoSending), [CLIENT_WINDOW_SIZE, SERVER_WINDOW_SIZE] select isServer, []] call CFUNC(wait);