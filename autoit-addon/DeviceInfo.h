#pragma once
#ifndef DeviceInfo_H
#define DeviceInfo_H

#include <windows.h>
#include <dshow.h>
#include <vector>
#include <iostream>
#include "autoitdef.h"

#pragma comment(lib, "strmiids")

using namespace std;

namespace AUTOIT_MODULE_NAME {
    class AUTOIT_EXPORTS DeviceInfo {
        public:
            DeviceInfo();
            DeviceInfo(const DeviceInfo& other);
            DeviceInfo& operator=(const DeviceInfo& device);
            ~DeviceInfo();

            LONG WaveInID = -1;
            WCHAR* FriendlyName = NULL;
            SIZE_T FriendlyNameLen = 0;
            WCHAR* DevicePath = NULL;
            SIZE_T DevicePathLen = 0;

            // internal usage
            bool releaseFriendlyName = false;
            bool releaseDevicePath = false;
    };

    AUTOITAPI(void) enumerateVideoDevices(std::vector<DeviceInfo> &videoDevices);
    AUTOITAPI(void) enumerateAudioDevices(std::vector<DeviceInfo> &audioDevices);
    AUTOITAPI(void) enumerateDevices(std::vector<DeviceInfo> &videoDevices, std::vector<DeviceInfo> &audioDevices);
}

#endif
