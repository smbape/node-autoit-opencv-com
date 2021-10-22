#include "vector_DeviceInfo.h"

std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* VectorOfDeviceInfoCreate() 
{ 
    return new std::vector< AUTOIT_MODULE_NAME::DeviceInfo >(); 
}

std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* VectorOfDeviceInfoCreateSize(int size) 
{ 
    return new std::vector< AUTOIT_MODULE_NAME::DeviceInfo >(size); 
}

size_t VectorOfDeviceInfoGetSize(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* v)
{
    return v->size();
}

void VectorOfDeviceInfoPush(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* v, AUTOIT_MODULE_NAME::DeviceInfo* value)
{
    v->push_back(*value);
}

void VectorOfDeviceInfoPushMulti(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* v, AUTOIT_MODULE_NAME::DeviceInfo* values, size_t count)
{
    VectorPushMulti< AUTOIT_MODULE_NAME::DeviceInfo >(v, values, count);
}

void VectorOfDeviceInfoPushVector(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* v, std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* other)
{  
    VectorOfDeviceInfoPushMulti(v,  &(*other)[0], other->size());
}

void VectorOfDeviceInfoClear(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* v)
{
    v->clear();
}

void VectorOfDeviceInfoRelease(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >** v)
{
    delete *v;
    *v = 0;
}

void VectorOfDeviceInfoCopyData(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* v, AUTOIT_MODULE_NAME::DeviceInfo* data)
{
    VectorCopyData< AUTOIT_MODULE_NAME::DeviceInfo >(v, data);
}

AUTOIT_MODULE_NAME::DeviceInfo* VectorOfDeviceInfoGetStartAddress(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* v)
{
    return v->empty() ? NULL : &(*v)[0];
}

void* VectorOfDeviceInfoGetEndAddress(std::vector< AUTOIT_MODULE_NAME::DeviceInfo >* v)
{
    if (v->empty()) return NULL;
    return (void*) &(*v)[v->size()];
}

void VectorOfDeviceInfoGetItem(std::vector<  AUTOIT_MODULE_NAME::DeviceInfo >* vec, int index, AUTOIT_MODULE_NAME::DeviceInfo * element)
{
    *element = vec->at(index);
}

void VectorOfDeviceInfoGetItemPtr(std::vector<  AUTOIT_MODULE_NAME::DeviceInfo >* vec, int index, AUTOIT_MODULE_NAME::DeviceInfo** element)
{ 
    *element = &vec->at(index);
}

int VectorOfDeviceInfoSizeOfItemInBytes()
{
    return sizeof(AUTOIT_MODULE_NAME::DeviceInfo);
}
