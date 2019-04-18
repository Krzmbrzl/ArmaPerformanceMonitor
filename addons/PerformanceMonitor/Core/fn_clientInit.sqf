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

[
	"missionStarted",
	{		
		// delay according to sender group -> Space out client-server communication as evenly as possible
		private _delay = diag_tickTime random SENDER_GROUP_COUNT;
		
		[
			{
				// toggle performance monitoring on
				[] call FUNC(togglePerformanceInfoSending),
			},
			_delay,
			[]
		] call CFUNC(wait);
	}
] call CFUNC(addEventHandler);