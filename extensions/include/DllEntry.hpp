#ifndef CLIB_DllEntry
#define CLIB_DllEntry

#ifdef WINDOWS
    #define ARMA_API extern "C" __declspec (dllexport)
#else
    #define ARMA_API extern "C" __attribute__((visibility("default")))
#endif

/**
 * Entry point for getting the version of this entry on extension load
 */
ARMA_API void RVExtensionVersion(char *armaOutput, int outputSize);

/**
 * Entry point for STRING callExtension STRING
 */
ARMA_API void RVExtension(char *armaOutput, int outputSize, const char *in);

#endif