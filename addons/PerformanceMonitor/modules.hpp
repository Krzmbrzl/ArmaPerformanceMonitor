#include "\tc\CLib\addons\CLib\ModuleMacros.hpp"

class CfgCLibModules {
    class PerformanceMonitor {
        path = "\rvn\PerformanceMonitor\addons\PerformanceMonitor";

        // Core
        MODULE(Core) {
            dependency[] = {"CLib/Events", "CLib/PerFrame"};
            FNC(clientInit);
            FNC(serverInit);
            FNC(init);
        };
    };
};
