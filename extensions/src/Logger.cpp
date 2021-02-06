/*
 * Logger.cpp
 *
 *  Created on: 16 Feb 2019
 *      Author: Raven
 */

#include "DllEntry.hpp"
#include <string>
#ifdef EXPERIMENTAL_FILESYSTEM
	#include <experimental/filesystem>
#else
	#include <filesystem>
#endif
#include <iostream>
#include <chrono>
#include <ctime>
#include <fstream>

// Linux-specific
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>

void RVExtensionVersion(char *armaOutput, int outputSize) {
	std::string("1.0").copy(armaOutput, 4);
}

/**
 * Gets the directory in which the executable of this process is located
 * @param bufSize (otpional) The size of the path-buffer to use
 *
 * @return The path to the respective directory or an empty string if something went wrong
 */
std::string getExecutableDirectory(int bufSize=1024) {
    std::string path;
    #ifdef WINDOWS
        #error getExecutableDirectory not yet implemented for Windows!
    #else
        char buffer[bufSize];

        int size = readlink("/proc/self/exe", buffer, bufSize);

        if(size <= 0) {
            return std::string();
        }

        for(int i=0; i<size; i++) {
            path += buffer[i];
        }

        // remove executable name but leave trailing FILE_SEP
        int index = path.find_last_of('/');
        if(index > 0) {
            path = path.substr(0,index + 1);
        }

        return path;
    #endif
}

std::string logFilePath;
#define PATH_SEP '/'

void RVExtension(char *armaOutput, int outputSize, const char *in) {
	static bool initialized = false;

	if (!initialized) {
		std::string currentPath = getExecutableDirectory();

		time_t rawtime;
		struct tm * timeinfo;
		char buffer[80];

		time(&rawtime);
		timeinfo = localtime(&rawtime);

		strftime(buffer,sizeof(buffer),"%Y-%m-%d_%H:%M:%S", timeinfo);
		std::string strTime(buffer);

		logFilePath = currentPath + "performanceLogs";

		// make sure directory exists
		mkdir(logFilePath.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);

		logFilePath = logFilePath + PATH_SEP + strTime + ".log";
	}

	static std::ofstream logStream(logFilePath, std::ios_base::app);

	// cretea timestamp
	time_t rawtime;
	struct tm * timeinfo;
	char buffer[80];

	time(&rawtime);
	timeinfo = localtime(&rawtime);

	strftime(buffer,sizeof(buffer),"%Y-%m-%d %H:%M:%S", timeinfo);
	std::string strTime(buffer);

	logStream << strTime << "\t" << in << std::endl;
}
