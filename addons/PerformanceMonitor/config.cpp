#include "macros.hpp"
class CfgPatches {
    class PerformanceMonitor {
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.70;
        author = "Raven";
        authors[] = {"Raven"};
        authorUrl = "";
        version = VERSION;
        versionStr = QUOTE(VERSION);
        versionAr[] = {VERSION_AR};
        requiredAddons[] = {"CLib"};
    };
};

#include "modules.hpp"
#include "loadouts.hpp"
