#ifndef NOMINMAX
#define NOMINMAX
#endif

#ifndef STRICT
#define STRICT
#endif

#import "cvLib.tlb"

#include <atlbase.h>
#include <atlcom.h>
#include <atlctl.h>
#include <atlsafe.h>
#include <iostream>
#include <OleAuto.h>
#include <string>
#include <comutil.h>
#include <codecvt>
#include <assert.h>
#include <windows.h>
#include <dshow.h>
#include <locale>
#include <codecvt>
#include <string>
#include <gdiplus.h>
#include "generated_include.h"

#pragma comment(lib, "strmiids")
#pragma comment(lib, "gdiplus.lib")

void string_to_bstr(const std::string& in_val, _bstr_t& out_val) {
	std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
	std::wstring ws = converter.from_bytes(in_val);

	BSTR bstr = SysAllocStringLen(ws.data(), ws.size());
	out_val = _bstr_t(bstr);
	SysFreeString(bstr);
}

HRESULT EnumerateDevices(REFGUID category, IEnumMoniker** ppEnum)
{
	// Create the System Device Enumerator.
	ICreateDevEnum* pDevEnum;
	HRESULT hr = CoCreateInstance(CLSID_SystemDeviceEnum, NULL,
		CLSCTX_INPROC_SERVER, IID_PPV_ARGS(&pDevEnum));

	if (SUCCEEDED(hr))
	{
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

void DisplayDeviceInformation(IEnumMoniker* pEnum)
{
	IMoniker* pMoniker = NULL;

	while (pEnum->Next(1, &pMoniker, NULL) == S_OK)
	{
		IPropertyBag* pPropBag;
		HRESULT hr = pMoniker->BindToStorage(0, 0, IID_PPV_ARGS(&pPropBag));
		if (FAILED(hr))
		{
			pMoniker->Release();
			continue;
		}

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
			printf("FriendlyName: %S\n", var.bstrVal);
			VariantClear(&var);
		}

		hr = pPropBag->Write(L"FriendlyName", &var);

		// WaveInID applies only to audio capture devices.
		hr = pPropBag->Read(L"WaveInID", &var, 0);
		if (SUCCEEDED(hr))
		{
			printf("WaveIn ID: %d\n", var.lVal);
			VariantClear(&var);
		}

		hr = pPropBag->Read(L"DevicePath", &var, 0);
		if (SUCCEEDED(hr))
		{
			// The device path is not intended for display.
			printf("Device path: %S\n", var.bstrVal);
			VariantClear(&var);
		}

		pPropBag->Release();
		pMoniker->Release();
	}
}

using namespace std;
using namespace cv;

static _variant_t vtDefault;
static _variant_t vtEmpty;

static void assertMat(cvLib::ICv_Mat_ObjectPtr mat, int channels) {
	assert(!mat->empty());
	assert(mat->channels() == channels);
	assert(mat->rows == 512);
	assert(mat->cols == 512);
	assert(mat->width == 512);
	assert(mat->height == 512);

	cout << "rows: " << mat->rows << endl;
	cout << "cols: " << mat->cols << endl;
	cout << "width: " << mat->width << endl;
	cout << "height: " << mat->height << endl;
	cout << "channels: " << mat->channels() << endl;
}

static void assertSplit(_variant_t splitted) {
	CComSafeArray<VARIANT> vSafeArray;

	// out parameter should not be modified if it is not an array or a vector
	assert((V_VT(&splitted) & VT_ARRAY) == VT_ARRAY);
	assert((V_VT(&splitted) ^ VT_ARRAY) == VT_VARIANT);

	vSafeArray.Attach(V_ARRAY(&splitted));
	assert(vSafeArray.GetCount() == 3);

	LONG lLower = vSafeArray.GetLowerBound();
	LONG lUpper = vSafeArray.GetUpperBound();

	for (LONG i = lLower; i <= lUpper; ++i) {
		VARIANT& v = vSafeArray.GetAt(i);

		// output value should be an ICv_Mat_Object
		cout << "type: " << V_VT(&v) << endl;
		assert(V_VT(&v) == VT_DISPATCH);

		auto mat_object = reinterpret_cast<cvLib::ICv_Mat_Object*>(V_DISPATCH(&v));

		// output should be a valid ICv_Mat_Object
		auto plane = cvLib::ICv_Mat_ObjectPtr(mat_object, true);
		assertMat(plane, 1);
	}

	vSafeArray.Detach();
}

static cvLib::ICv_Mat_ObjectPtr testRead(cvLib::ICv_ObjectPtr cv, BSTR filename) {
	// test retval
	auto mat = cv->imread(&_variant_t(filename));

	// test extended val
	CComSafeArray<VARIANT> extended;
	extended.Attach(V_ARRAY(&cv->extended));

	// extended should contains only one output value
	assert(extended.GetCount() == 1);

	VARIANT& v = extended.GetAt(0);
	extended.Detach();

	// output value should be an ICv_Mat_Object
	cout << "type: " << V_VT(&v) << endl;
	assert(V_VT(&v) == VT_DISPATCH);

	auto mat_object = reinterpret_cast<cvLib::ICv_Mat_Object*>(V_DISPATCH(&v));

	// output should be a valid ICv_Mat_Object
	auto ext_mat = cvLib::ICv_Mat_ObjectPtr(mat_object, true);
	assertMat(ext_mat, 3);

	// retval should be a valid ICv_Mat_Object
	assertMat(mat, 3);
	return mat;
}

static void testSpit(cvLib::ICv_ObjectPtr cv, cvLib::ICv_Mat_ObjectPtr mat) {
	_variant_t splitted;
	CComSafeArray<VARIANT> extended;

	splitted = cv->split(&_variant_t(mat.GetInterfacePtr()), &vtEmpty);

	// it should not modify out parameter if it is not an array nor & vector
	assert(V_VT(&vtEmpty) == VT_EMPTY);

	// extended should contains only one output value
	extended.Attach(V_ARRAY(&cv->extended));
	assert(extended.GetCount() == 1);
	assertSplit(extended.GetAt(0));
	extended.Detach();

	assertSplit(splitted);

	splitted = cv->split(&_variant_t(mat.GetInterfacePtr()), &vtDefault);

	// it should not modify out parameter if it is not an array nor & vector
	assert(V_VT(&vtDefault) == VT_ERROR);
	assert(V_ERROR(&vtDefault) == DISP_E_PARAMNOTFOUND);

	// extended should contains only one output value
	extended.Attach(V_ARRAY(&cv->extended));
	assert(extended.GetCount() == 1);
	assertSplit(extended.GetAt(0));
	extended.Detach();

	assertSplit(splitted);

	CComSafeArray<VARIANT> _splitted(0UL);
	CComVariant wrapper(_splitted);
	VARIANT variant, * pDest = &variant;
	VariantInit(pDest);
	wrapper.Detach(pDest);
	splitted = pDest;
	VariantClear(pDest);

	cv->split(&_variant_t(mat.GetInterfacePtr()), &splitted);

	assert((V_VT(&splitted) & VT_ARRAY) == VT_ARRAY);
	assert((V_VT(&splitted) ^ VT_ARRAY) == VT_VARIANT);

	// extended should contains only one output value
	extended.Attach(V_ARRAY(&cv->extended));
	assert(extended.GetCount() == 1);
	assertSplit(extended.GetAt(0));
	extended.Detach();

	assertSplit(splitted);

	cvLib::IVectorOfMat_ObjectPtr VectorOfMatPtr;
	HRESULT hr = VectorOfMatPtr.CreateInstance(__uuidof(cvLib::VectorOfMat_Object));
	assert(SUCCEEDED(hr));

	auto vector_Mat = VectorOfMatPtr->create();
	cv->split(&_variant_t(mat.GetInterfacePtr()), &_variant_t(vector_Mat.GetInterfacePtr()));
	assert(vector_Mat->size() == 3);

	for (int i = 0; i < vector_Mat->size(); i++) {
		auto plane = vector_Mat->at(&_variant_t(i));
		assertMat(plane, 1);
	}
}

static void testAdd(cvLib::ICv_ObjectPtr cv, cvLib::ICv_Mat_ObjectPtr mat) {
	CComSafeArray<VARIANT> scalar(4UL);
	for (int i = 0; i < 4; i++) {
		scalar.SetAt(i, _variant_t(1));
	}

	auto safeArray = scalar.Detach();
	VARIANT variant = { VT_ARRAY | VT_VARIANT };
	V_ARRAY(&variant) = safeArray;

	cv->add(&_variant_t(mat->clone().GetInterfacePtr()), &variant);

	VariantClear(&variant);
}

static void testResize(cvLib::ICv_ObjectPtr cv) {
	_bstr_t image_path;
	// string_to_bstr(samples::findFile("aloeGT.png"), image_path);
	string_to_bstr("E:\\development\\git\\node-autoit-opencv-com\\samples\\tutorial_code\\yolo\\scooter-5180947_1920.jpg", image_path);
	auto mat = cv->imread(&_variant_t(image_path));

	float newWidth = 600;
	float newHeight = 399.6875;

	CComSafeArray<VARIANT> dsize(2UL);
	dsize.SetAt(0, _variant_t(newWidth));
	dsize.SetAt(1, _variant_t(newHeight));

	auto safeArray = dsize.Detach();
	VARIANT variant = { VT_ARRAY | VT_VARIANT };
	V_ARRAY(&variant) = safeArray;

	cv->resize(&_variant_t(mat->clone().GetInterfacePtr()), &variant);
	mat->GdiplusResize(&_variant_t(newWidth), &_variant_t(newHeight), &_variant_t(7));

	VariantClear(&variant);
}

static void testSetTo(cvLib::ICv_ObjectPtr cv, cvLib::ICv_Mat_ObjectPtr mat) {
	CComSafeArray<VARIANT> scalar(4UL);
	for (int i = 0; i < 4; i++) {
		scalar.SetAt(i, _variant_t(0));
	}

	auto safeArray = scalar.Detach();
	VARIANT variant = { VT_ARRAY | VT_VARIANT };
	V_ARRAY(&variant) = safeArray;

	mat->clone()->setTo(&variant);

	VariantClear(&variant);
}

static void testAKAZE(cvLib::ICv_ObjectPtr cv) {
	cvLib::ICv_AKAZE_ObjectPtr AKAZEPtr;
	HRESULT hr = AKAZEPtr.CreateInstance(__uuidof(cvLib::Cv_AKAZE_Object));
	assert(SUCCEEDED(hr));

	cvLib::ICv_Mat_ObjectPtr MatPtr;
	hr = MatPtr.CreateInstance(__uuidof(cvLib::Cv_Mat_Object));
	assert(SUCCEEDED(hr));

	auto variant = AKAZEPtr->create();

	_bstr_t image_path;

	string_to_bstr(samples::findFile("graf1.png"), image_path);
	auto img1 = cv->imread(&_variant_t(image_path), &_variant_t(IMREAD_GRAYSCALE));

	string_to_bstr(samples::findFile("graf3.png"), image_path);
	auto img2 = cv->imread(&_variant_t(image_path), &_variant_t(IMREAD_GRAYSCALE));

	assert(V_VT(&variant) == VT_DISPATCH);
	cvLib::ICv_AKAZE_ObjectPtr akaze;
	akaze.Attach(static_cast<cvLib::ICv_AKAZE_Object*>(V_DISPATCH(&variant.Detach())));
	akaze->detectAndCompute(&_variant_t(img1.GetInterfacePtr()), &_variant_t(MatPtr->create().GetInterfacePtr()));

	CComSafeArray<VARIANT> extended;
	extended.Attach(V_ARRAY(&cv->extended));
	auto kpts1 = extended.GetAt(0);
	auto desc1 = extended.GetAt(1);
	extended.Detach();

	assert((V_VT(&kpts1) & VT_ARRAY) == VT_ARRAY);
	assert((V_VT(&kpts1) ^ VT_ARRAY) == VT_VARIANT);

	CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(&kpts1));
	cvLib::ICv_KeyPoint_ObjectPtr keypoint;
	keypoint.Attach(static_cast<cvLib::ICv_KeyPoint_Object*>(V_DISPATCH(&vArray.GetAt(0))));
	vArray.Detach();

	auto pt = keypoint->Getpt();
	printf("%hu", V_VT(&pt));
	keypoint.Detach();

	cvLib::IVectorOfKeyPoint_ObjectPtr VectorOfKeyPointPtr;
	hr = VectorOfKeyPointPtr.CreateInstance(__uuidof(cvLib::VectorOfKeyPoint_Object));
	assert(SUCCEEDED(hr));

	cvLib::ICv_KeyPoint_ObjectPtr Cv_KeyPointPtr;
	hr = Cv_KeyPointPtr.CreateInstance(__uuidof(cvLib::Cv_KeyPoint_Object));
	assert(SUCCEEDED(hr));

	auto vMatched1 = VectorOfKeyPointPtr->create();

	// vMatched1->push_back(&_variant_t(Cv_KeyPointPtr->create().GetInterfacePtr()));
	// assert(vMatched1->size() == 1);

	variant = vMatched1->Getself();
	assert(V_VT(&variant) == VT_UI8);

	auto matched1 = reinterpret_cast<vector<KeyPoint>*>(V_UI8(&variant));
	assert(matched1->size() == 0);
	matched1->push_back(KeyPoint());
}

void testEnumerateDevices() {
	IEnumMoniker* pEnum;

	HRESULT hr = EnumerateDevices(CLSID_VideoInputDeviceCategory, &pEnum);
	if (SUCCEEDED(hr))
	{
		DisplayDeviceInformation(pEnum);
		pEnum->Release();
	}

	hr = EnumerateDevices(CLSID_AudioInputDeviceCategory, &pEnum);
	if (SUCCEEDED(hr))
	{
		DisplayDeviceInformation(pEnum);
		pEnum->Release();
	}
}

void testContours(cvLib::ICv_ObjectPtr cv) {
	cvLib::IVectorOfVectorOfPoint_ObjectPtr VectorOfVectorOfPointPtr;
	HRESULT hr = VectorOfVectorOfPointPtr.CreateInstance(__uuidof(cvLib::VectorOfVectorOfPoint_Object));
	assert(SUCCEEDED(hr));

	_bstr_t image_path;
	string_to_bstr(samples::findFile("pic1.png"), image_path);
	auto img = cv->imread(&_variant_t(image_path));
	auto gray = cv->cvtColor(&_variant_t(img.GetInterfacePtr()), &_variant_t(COLOR_BGR2GRAY));
	auto contours = cv->findContours(&gray, &_variant_t(RETR_EXTERNAL), &_variant_t(CHAIN_APPROX_SIMPLE));

	// cv->contourArea(&contours->at(&_variant_t(0)));
}

static int perform() {
	testEnumerateDevices();

	V_VT(&vtDefault) = VT_ERROR;
	V_ERROR(&vtDefault) = DISP_E_PARAMNOTFOUND;

	VariantInit(&vtEmpty);

	cvLib::ICv_ObjectPtr cv;
	HRESULT hr = cv.CreateInstance(__uuidof(cvLib::Cv_Object));
	assert(SUCCEEDED(hr));

	cvLib::ICv_Mat_ObjectPtr MatPtr;
	hr = MatPtr.CreateInstance(__uuidof(cvLib::Cv_Mat_Object));
	assert(SUCCEEDED(hr));

	_bstr_t image_path;
	string_to_bstr(samples::findFile("lena.jpg"), image_path);

	auto mat = testRead(cv, image_path);
	testSpit(cv, mat);
	testAKAZE(cv);
	testAdd(cv, mat);
	testResize(cv);
	testSetTo(cv, mat);
	testContours(cv);

	cvLib::ICv_VideoCapture_ObjectPtr VideoCapturePtr;
	hr = VideoCapturePtr.CreateInstance(__uuidof(cvLib::Cv_VideoCapture_Object));
	assert(SUCCEEDED(hr));

	_variant_t camId(0);
	auto cap = VideoCapturePtr->create(&camId);
	if (cap->isOpened() == VARIANT_FALSE) {
		std::wcout << L"Error: cannot open the camera.\n";
		return 1;
	}

	auto frame = MatPtr->create();
	auto vframe = _variant_t(frame.GetInterfacePtr());
	auto flipped = MatPtr->create();
	auto vflipped = _variant_t(flipped.GetInterfacePtr());

	CComSafeArray<VARIANT> extended;

	VARIANT variant;
	VariantInit(&variant);

	while (true) {
		if (waitKey(30) == 27) {
			break;
		}

		if (cap->read(&_variant_t(frame.GetInterfacePtr())) == VARIANT_TRUE) {
			extended.Attach(V_ARRAY(&cv->extended));
			VariantInit(&variant);
			hr = extended.GetAt(1).Detach(&variant);
			assert(SUCCEEDED(hr));
			extended.Detach();

			// in/out version
			assert(!frame->empty());

			cv->flip(&vframe, &_variant_t(1), &vflipped);
			assert(!flipped->empty());

			cv->imshow(&_variant_t(L"capture camera"), &vflipped);

			// extended version
			assert(V_VT(&variant) == VT_DISPATCH);
			frame.Attach(static_cast<cvLib::ICv_Mat_Object*>(V_DISPATCH(&variant)));
			assert(!frame->empty());

			flipped = cv->flip(&vframe, &_variant_t(1), &vtDefault);
			assert(!flipped->empty());
			assert(V_VT(&vtDefault) == VT_ERROR);
			assert(V_ERROR(&vtDefault) == DISP_E_PARAMNOTFOUND);

			cv->imshow(&_variant_t(L"capture camera"), &vflipped);
		}
	}

	return 0;
}

int main(int argc, char* argv[])
{
	using namespace Gdiplus;
	GdiplusStartupInput gdiplusStartupInput;
	ULONG_PTR gdiplusToken;
	auto status = GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);
	CV_Assert(status == Ok);

	HRESULT hr = CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);
	if (FAILED(hr)) {
		std::wcout << L"could not initialize COM\n";
		return 1;
	}

	int code = perform();

	CoUninitialize();
	GdiplusShutdown(gdiplusToken);

	return code;
}
