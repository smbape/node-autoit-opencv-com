#include <iostream>
#include<string>
#include "DeviceInfo.h"

using namespace std;

namespace AUTOIT_MODULE_NAME {
    DeviceInfo::DeviceInfo() {
        // Nothing to do
    }

    DeviceInfo::DeviceInfo(const DeviceInfo& other) {
        operator=(other);
    }

    DeviceInfo& DeviceInfo::operator=(const DeviceInfo& device) {
        if( this == &device ) {
            return *this;
        }

        WaveInID = device.WaveInID;
        FriendlyName = device.FriendlyName;
        FriendlyNameLen = device.FriendlyNameLen;
        DevicePath = device.DevicePath;
        DevicePathLen = device.DevicePathLen;
        releaseFriendlyName = device.releaseFriendlyName;
        releaseDevicePath = device.releaseDevicePath;

        if (device.releaseFriendlyName && FriendlyNameLen != 0) {
            FriendlyName = new WCHAR[FriendlyNameLen + 1];
            wcscpy_s(FriendlyName, FriendlyNameLen + 1, device.FriendlyName);
        }

        if (device.releaseDevicePath && DevicePathLen != 0) {
            DevicePath = new WCHAR[DevicePathLen + 1];
            wcscpy_s(DevicePath, DevicePathLen + 1, device.DevicePath);
        }

        return *this;
    }

    DeviceInfo::~DeviceInfo() {
        if (releaseFriendlyName && FriendlyName) {
            delete FriendlyName;
            FriendlyName = NULL;
        }

        if (releaseDevicePath && DevicePath) {
            delete DevicePath;
            DevicePath = NULL;
        }
    }

    /**
     * @see https://docs.microsoft.com/en-us/windows/win32/directshow/selecting-a-capture-device
     */
    HRESULT EnumerateDevices(REFGUID category, IEnumMoniker** ppEnum) {
        // Create the System Device Enumerator.
        ICreateDevEnum* pDevEnum;
        HRESULT hr = CoCreateInstance(CLSID_SystemDeviceEnum, NULL,
            CLSCTX_INPROC_SERVER, IID_PPV_ARGS(&pDevEnum));

        if (SUCCEEDED(hr)) {
            // Create an enumerator for the category.
            hr = pDevEnum->CreateClassEnumerator(category, ppEnum, 0);
            if (hr == S_FALSE)
            {
                hr = VFW_E_NOT_FOUND;  // The category is empty. Treat as an error.
            }
            pDevEnum->Release();
        }

        return hr;
    }

    /**
     * @see https://docs.microsoft.com/en-us/windows/win32/directshow/selecting-a-capture-device
     */
    void PushDevices(IEnumMoniker* pEnum, std::vector<DeviceInfo>& devices) {
        IMoniker* pMoniker = NULL;
        devices.clear();

        while (pEnum->Next(1, &pMoniker, NULL) == S_OK) {
            IPropertyBag* pPropBag;
            HRESULT hr = pMoniker->BindToStorage(0, 0, IID_PPV_ARGS(&pPropBag));
            if (FAILED(hr))
            {
                pMoniker->Release();
                continue;
            }

            DeviceInfo device;
            VARIANT var;
            VariantInit(&var);

            // Get description or friendly name.
            hr = pPropBag->Read(L"Description", &var, 0);
            if (FAILED(hr))
            {
                hr = pPropBag->Read(L"FriendlyName", &var, 0);
            }
            if (SUCCEEDED(hr))
            {
                size_t slen = wcslen(var.bstrVal);
                device.FriendlyName = new WCHAR[slen + 1];
                wcscpy_s(device.FriendlyName, slen + 1, var.bstrVal);
                device.FriendlyNameLen = slen;
                device.releaseFriendlyName = true;

                VariantClear(&var);
            }

            hr = pPropBag->Write(L"FriendlyName", &var);

            // WaveInID applies only to audio capture devices.
            hr = pPropBag->Read(L"WaveInID", &var, 0);
            if (SUCCEEDED(hr))
            {
                device.WaveInID = var.lVal;
                VariantClear(&var);
            }

            hr = pPropBag->Read(L"DevicePath", &var, 0);
            if (SUCCEEDED(hr))
            {
                size_t slen = wcslen(var.bstrVal);
                device.DevicePath = new WCHAR[slen + 1];
                wcscpy_s(device.DevicePath, slen + 1, var.bstrVal);
                device.DevicePathLen = slen;
                device.releaseDevicePath = true;

                // The device path is not intended for display.
                VariantClear(&var);
            }

            pPropBag->Release();
            pMoniker->Release();

            devices.push_back(device);
        }
    }

    /**
     * @see https://docs.microsoft.com/en-us/windows/win32/directshow/selecting-a-capture-device
     */
    void enumerateVideoDevices(std::vector<DeviceInfo> &videoDevices) {
        IEnumMoniker* pEnum;

        HRESULT hr = EnumerateDevices(CLSID_VideoInputDeviceCategory, &pEnum);
        if (SUCCEEDED(hr)) {
            PushDevices(pEnum, videoDevices);
            pEnum->Release();
        }
    }

    /**
     * @see https://docs.microsoft.com/en-us/windows/win32/directshow/selecting-a-capture-device
     */
    void enumerateAudioDevices(std::vector<DeviceInfo> &audioDevices) {
        IEnumMoniker* pEnum;

        HRESULT hr = EnumerateDevices(CLSID_AudioInputDeviceCategory, &pEnum);
        if (SUCCEEDED(hr)) {
            PushDevices(pEnum, audioDevices);
            pEnum->Release();
        }
    }

    /**
     * @see https://docs.microsoft.com/en-us/windows/win32/directshow/selecting-a-capture-device
     */
    void enumerateDevices(std::vector<DeviceInfo> &videoDevices, std::vector<DeviceInfo> &audioDevices) {
        enumerateVideoDevices(videoDevices);
        enumerateAudioDevices(audioDevices);
    }
}
