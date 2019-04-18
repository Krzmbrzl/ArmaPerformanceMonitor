#include "macros.hpp"
/**
 * PerformanceMonitir - togglePerformanceInfoSending
 * 
 * Author: Raven
 * 
 * Description:
 * Toggles the performance-sending. If this client is currently sending performance information, this will stop it and vice versa.
 * 
 * Parameter(s):
 * 0: None <Any>
 * 
 * Return Value:
 * None <Any>
 * 
 */

if (GVAR(isSendingPerformanceInfo)) then {
	// turn sending off
	GVAR(isSendingPerformanceInfo) = false;
} else {
	// turn sending on
	GVAR(isSendingPerformanceInfo) = true;
	
	[] call FUNC(recursiveInfoSending);
};