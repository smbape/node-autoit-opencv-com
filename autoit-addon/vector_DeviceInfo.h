#pragma once
#ifndef VECTOR_DeviceInfo_H
#define VECTOR_DeviceInfo_H

#include "DeviceInfo.h"

template <class dataType> 
void VectorPushMulti(std::vector<dataType>* v, dataType* values, size_t count)
{
    if (count > 0)
    {
        size_t oldSize = v->size();
        v->resize(oldSize + count);
        memcpy(&(*v)[oldSize], values, count * sizeof(dataType));
    }
}

template <class dataType> 
void VectorCopyData(std::vector<dataType>* v, dataType* data)
{
    if (!v->empty())
        memcpy(data, &(*v)[0], v->size() * sizeof(dataType));
}

//----------------------------------------------------------------------------
//
//  Vector of AUTOIT_MODULE_NAME::DeviceInfo
//
//----------------------------------------------------------------------------
AUTOITAPI(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >*) VectorOfDeviceInfoCreate();

AUTOITAPI(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >*) VectorOfDeviceInfoCreateSize(int size);

AUTOITAPI(size_t) VectorOfDeviceInfoGetSize(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* v);

AUTOITAPI(void) VectorOfDeviceInfoPush(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* v, AUTOIT_MODULE_NAME::DeviceInfo* value);

AUTOITAPI(void) VectorOfDeviceInfoPushMulti(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* v, AUTOIT_MODULE_NAME::DeviceInfo* values, size_t count);

AUTOITAPI(void) VectorOfDeviceInfoPushVector(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* v, std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* other);

AUTOITAPI(void) VectorOfDeviceInfoClear(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* v);

AUTOITAPI(void) VectorOfDeviceInfoRelease(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >** v);

AUTOITAPI(void) VectorOfDeviceInfoCopyData(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* v,  AUTOIT_MODULE_NAME::DeviceInfo* data);

AUTOITAPI(AUTOIT_MODULE_NAME::DeviceInfo*) VectorOfDeviceInfoGetStartAddress(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* v);

AUTOITAPI(void*) VectorOfDeviceInfoGetEndAddress(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* v);

AUTOITAPI(void) VectorOfDeviceInfoGetItem(std::vector<  AUTOIT_MODULE_NAME::DeviceInfo >* vec, int index,  AUTOIT_MODULE_NAME::DeviceInfo* element);

AUTOITAPI(void) VectorOfDeviceInfoGetItemPtr(std::vector<  AUTOIT_MODULE_NAME::DeviceInfo >* vec, int index,  AUTOIT_MODULE_NAME::DeviceInfo** element);

AUTOITAPI(int) VectorOfDeviceInfoSizeOfItemInBytes();

#endif
