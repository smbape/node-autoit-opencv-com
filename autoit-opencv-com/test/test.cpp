#include "test.h"
#include <semaphore>

template<typename T>
inline auto to_variant_t(T const& in_val) {
	return cv::Ptr<_variant_t>(new _variant_t(in_val));
}

/**
 * [ConvertUtf8ToWide description]
 * @param  str  Pointer to the character string to convert.
 * @param  wstr Pointer to a buffer that receives the converted string.
 * @return      The number of characters written to the buffer pointed to by wstr.
 * @see             https://stackoverflow.com/questions/6693010/how-do-i-use-multibytetowidechar/59617138#59617138
 *                  https://learn.microsoft.com/en-us/windows/win32/api/stringapiset/nf-stringapiset-multibytetowidechar
 */
inline auto ConvertUtf8ToWide(const std::string& str, std::wstring& wstr) {
	int size = MultiByteToWideChar(CP_UTF8, 0, str.c_str(), str.length(), NULL, 0);
	wstr.assign(size, 0);
	return MultiByteToWideChar(CP_UTF8, 0, str.c_str(), str.length(), &wstr[0], size + 1);
}

/**
 * @param in_val  std::string
 * @param out_val _bstr_t
 * @see https://stackoverflow.com/questions/6284524/bstr-to-stdstring-stdwstring-and-vice-versa/6284978#6284978
 */
inline void string_to_bstr(std::string const& in_val, _bstr_t& out_val) {
	std::wstring ws; ConvertUtf8ToWide(in_val, ws);
	BSTR bstr = SysAllocStringLen(ws.data(), ws.size());
	out_val = _bstr_t(bstr);
	SysFreeString(bstr);
}

inline auto _OpenCV_ScalarAll(double val) {
	CComSafeArray<VARIANT> scalar(4UL);
	for (int i = 0; i < 4; i++) {
		scalar.SetAt(i, _variant_t(val));
	}

	auto safeArray = scalar.Detach();
	VARIANT variant = { VT_ARRAY | VT_VARIANT };
	V_ARRAY(&variant) = safeArray;

	return variant;
}

template<typename... T>
inline auto _OpenCV_Tuple(T... args) {

	const int size = sizeof...(args);
	CComSafeArray<VARIANT> arr(size);

	int i = 0;
	for (auto& arg : { args... }) {
		arr.SetAt(i++, _variant_t(arg));
	}

	auto safeArray = arr.Detach();
	VARIANT variant = { VT_ARRAY | VT_VARIANT };
	V_ARRAY(&variant) = safeArray;

	return variant;
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

static _variant_t _vtDefault;
static _variant_t& vtDefault() {
	VariantClear(&_vtDefault);
	V_VT(&_vtDefault) = VT_ERROR;
	V_ERROR(&_vtDefault) = DISP_E_PARAMNOTFOUND;
	return _vtDefault;
}

static _variant_t _vtEmpty;
static _variant_t& vtEmpty() {
	VariantClear(&_vtEmpty);
	return _vtEmpty;
}

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
	auto _mat = cv->imread(to_variant_t(filename), &vtDefault(), &vtDefault());
	assert(V_VT(&_mat) == VT_DISPATCH);
	auto mat = reinterpret_cast<cvLib::ICv_Mat_Object*>(V_DISPATCH(&_mat));

	// test extended val
	CComSafeArray<VARIANT> extended;
	extended.Attach(V_ARRAY(to_variant_t(cv->extended)));

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

	_variant_t vtMissingVar = vtEmpty();
	splitted = cv->split(to_variant_t(mat.GetInterfacePtr()), &vtMissingVar);

	// it should modify out parameter if it is not an array nor & vector
	assert((V_VT(&vtMissingVar) & VT_ARRAY) == VT_ARRAY);
	assert((V_VT(&vtMissingVar) ^ VT_ARRAY) == VT_VARIANT);

	// extended should contains only one output value
	extended.Attach(V_ARRAY(to_variant_t(cv->extended)));
	assert(extended.GetCount() == 1);
	assertSplit(extended.GetAt(0));
	extended.Detach();

	assertSplit(splitted);

	_variant_t vtDefaultVar = vtDefault();
	splitted = cv->split(to_variant_t(mat.GetInterfacePtr()), &vtDefaultVar);

	// it should modify out parameter if it is not an array nor & vector
	assert((V_VT(&vtDefaultVar) & VT_ARRAY) == VT_ARRAY);
	assert((V_VT(&vtDefaultVar) ^ VT_ARRAY) == VT_VARIANT);

	// extended should contains only one output value
	extended.Attach(V_ARRAY(to_variant_t(cv->extended)));
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

	cv->split(to_variant_t(mat.GetInterfacePtr()), &splitted);

	assert((V_VT(&splitted) & VT_ARRAY) == VT_ARRAY);
	assert((V_VT(&splitted) ^ VT_ARRAY) == VT_VARIANT);

	// extended should contains only one output value
	extended.Attach(V_ARRAY(to_variant_t(cv->extended)));
	assert(extended.GetCount() == 1);
	assertSplit(extended.GetAt(0));
	extended.Detach();

	assertSplit(splitted);

	cvLib::IVectorOfMat_ObjectPtr VectorOfMatPtr;
	HRESULT hr = VectorOfMatPtr.CreateInstance(__uuidof(cvLib::VectorOfMat_Object));
	assert(SUCCEEDED(hr));

	auto vector_Mat = VectorOfMatPtr->create();
	cv->split(to_variant_t(mat.GetInterfacePtr()), to_variant_t(vector_Mat.GetInterfacePtr()));
	assert(vector_Mat->size() == 3);

	for (int i = 0; i < vector_Mat->size(); i++) {
		auto plane = vector_Mat->at(to_variant_t(i));
		assertMat(plane, 1);
	}
}

static void testAdd(cvLib::ICv_ObjectPtr cv, cvLib::ICv_Mat_ObjectPtr mat) {
	cvLib::ICv_Mat_ObjectPtr MatPtr;
	auto hr = MatPtr.CreateInstance(__uuidof(cvLib::Cv_Mat_Object));
	assert(SUCCEEDED(hr));

	CComSafeArray<VARIANT> scalar(4UL);
	for (int i = 0; i < 4; i++) {
		scalar.SetAt(i, _variant_t(1));
	}

	auto safeArray = scalar.Detach();
	VARIANT sclarArray = { VT_ARRAY | VT_VARIANT };
	V_ARRAY(&sclarArray) = safeArray;

	auto scalarMat = MatPtr->create(to_variant_t(1), to_variant_t(1), to_variant_t(CV_64F), &sclarArray);

	cv->add(to_variant_t(mat->clone().GetInterfacePtr()), to_variant_t(scalarMat.GetInterfacePtr()), &vtDefault(), &vtDefault(), &vtDefault());

	VariantClear(&sclarArray);
}

static void testResize(cvLib::ICv_ObjectPtr cv) {
	cvLib::ICv_Mat_ObjectPtr MatPtr;
	HRESULT hr = MatPtr.CreateInstance(__uuidof(cvLib::Cv_Mat_Object));
	assert(SUCCEEDED(hr));

	_bstr_t image_path;
	string_to_bstr(samples::findFile("aloeGT.png"), image_path);
	// string_to_bstr(samples::findFile("..\\tutorial_code\\yolo\\scooter-5180947_1920.jpg"), image_path);
	auto _mat = cv->imread(to_variant_t(image_path), &vtDefault(), &vtDefault());
	assert(V_VT(&_mat) == VT_DISPATCH);
	auto mat = reinterpret_cast<cvLib::ICv_Mat_Object*>(V_DISPATCH(&_mat));

	float newWidth = 600;
	float newHeight = 399.6875;

	CComSafeArray<VARIANT> dsize(2UL);
	dsize[0] = _variant_t(newWidth);
	dsize[1] = _variant_t(newHeight);

	VARIANT variant = { VT_ARRAY | VT_VARIANT };
	V_ARRAY(&variant) = dsize.Detach();

	cv->resize(to_variant_t(mat->clone().GetInterfacePtr()), &variant, &vtDefault(), &vtDefault(), &vtDefault(), &vtDefault());

	dsize.Attach(V_ARRAY(&variant));
	V_ARRAY(&variant) = NULL;

	mat->GdiplusResize(to_variant_t(newWidth), to_variant_t(newHeight), to_variant_t(7), to_variant_t(MatPtr->create().GetInterfacePtr()));

	CComSafeArray<VARIANT> color(4UL);
	color[0] = 0x1E;
	color[1] = 0x1D;
	color[2] = 0x13;
	color[3] = 0;

	V_ARRAY(&variant) = color.Detach();
	mat->PixelSearch(&variant);
	dsize.Attach(V_ARRAY(&variant));
	V_ARRAY(&variant) = NULL;

	VariantClear(&variant);

}

static void testSetTo(cvLib::ICv_ObjectPtr cv, cvLib::ICv_Mat_ObjectPtr mat) {
	CComSafeArray<VARIANT> scalar(4UL);
	for (int i = 0; i < 4; i++) {
		scalar[i] = _variant_t(0);
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

	auto variant = AKAZEPtr->Getcreate();

	_bstr_t image_path;

	string_to_bstr(samples::findFile("graf1.png"), image_path);
	auto _img1 = cv->imread(to_variant_t(image_path), to_variant_t(IMREAD_GRAYSCALE), &vtDefault());
	assert(V_VT(&_img1) == VT_DISPATCH);
	auto img1 = reinterpret_cast<cvLib::ICv_Mat_Object*>(V_DISPATCH(&_img1));

	string_to_bstr(samples::findFile("graf3.png"), image_path);
	auto _img2 = cv->imread(to_variant_t(image_path), to_variant_t(IMREAD_GRAYSCALE), &vtDefault());
	assert(V_VT(&_img2) == VT_DISPATCH);
	auto img2 = reinterpret_cast<cvLib::ICv_Mat_Object*>(V_DISPATCH(&_img2));

	assert(V_VT(&variant) == VT_DISPATCH);
	cvLib::ICv_AKAZE_ObjectPtr akaze;
	akaze.Attach(static_cast<cvLib::ICv_AKAZE_Object*>(V_DISPATCH(to_variant_t(variant.Detach()))));

	akaze->detectAndCompute(to_variant_t(img1), to_variant_t(MatPtr->create().GetInterfacePtr()), &vtDefault(), &vtDefault(), &vtDefault());

	CComSafeArray<VARIANT> extended;
	extended.Attach(V_ARRAY(to_variant_t(cv->extended)));
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

	// vMatched1->push_back(to_variant_t(Cv_KeyPointPtr->create().GetInterfacePtr()));
	// assert(vMatched1->size() == 1);

	variant = vMatched1->Getself();
	assert(V_VT(&variant) == VT_UI8);

	auto matched1 = reinterpret_cast<vector<KeyPoint>*>(V_UI8(&variant));
	assert(matched1->size() == 0);
	matched1->push_back(KeyPoint());
}

static void testEnumerateDevices() {
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

static void testContours(cvLib::ICv_ObjectPtr cv) {
	_bstr_t image_path;
	string_to_bstr(samples::findFile("pic1.png"), image_path);
	auto _img = cv->imread(to_variant_t(image_path), &vtDefault(), &vtDefault());
	assert(V_VT(&_img) == VT_DISPATCH);
	auto img = reinterpret_cast<cvLib::ICv_Mat_Object*>(V_DISPATCH(&_img));

	auto img_grey = cv->cvtColor(to_variant_t(img), to_variant_t(COLOR_BGR2GRAY), &vtDefault(), &vtDefault(), &vtDefault());
	cv->threshold(&img_grey, to_variant_t(100), to_variant_t(255), to_variant_t(THRESH_BINARY), &vtDefault());

	CComSafeArray<VARIANT> extended;
	extended.Attach(V_ARRAY(to_variant_t(cv->extended)));
	_variant_t thresh = extended.GetAt(1);
	extended.Detach();
	auto contours = cv->findContours(&thresh, to_variant_t(RETR_TREE), to_variant_t(CHAIN_APPROX_SIMPLE), &vtDefault(), &vtDefault(), &vtDefault());

	CComSafeArray<VARIANT> color(3UL);
	color[0] = _variant_t(0);
	color[1] = _variant_t(0);
	color[2] = _variant_t(255);

	VARIANT color_variant = { VT_ARRAY | VT_VARIANT };
	V_ARRAY(&color_variant) = color.Detach();

	cv->drawContours(to_variant_t(img), &contours, to_variant_t(-1), &color_variant, to_variant_t(2), &vtDefault(), &vtDefault(), &vtDefault(), &vtDefault());

	color.Attach(V_ARRAY(&color_variant));
	V_ARRAY(&color_variant) = NULL;

	cv->imshow(to_variant_t("testContours"), to_variant_t(img));
}

static void testConvertToShow(cvLib::ICv_ObjectPtr cv) {
	_bstr_t image_path;
	string_to_bstr(samples::findFile("pic1.png"), image_path);
	auto _img = cv->imread(to_variant_t(image_path), &vtDefault(), &vtDefault());
	assert(V_VT(&_img) == VT_DISPATCH);
	auto img = reinterpret_cast<cvLib::ICv_Mat_Object*>(V_DISPATCH(&_img));

	cvLib::ICv_Mat_ObjectPtr MatPtr;
	auto hr = MatPtr.CreateInstance(__uuidof(cvLib::Cv_Mat_Object));
	assert(SUCCEEDED(hr));

	auto dst = MatPtr->create(to_variant_t(img->rows), to_variant_t(img->cols), to_variant_t(CV_MAKETYPE(CV_8U, 4)));
	cout << "rows: " << dst->rows << endl;
	cout << "cols: " << dst->cols << endl;
	cout << "width: " << dst->width << endl;
	cout << "height: " << dst->height << endl;
	cout << "channels: " << dst->channels() << endl;

	auto ret = img->convertToShow(to_variant_t(dst.GetInterfacePtr()), &vtDefault());

	assert(img->rows == dst->rows);
	assert(img->cols == dst->cols);
	cv->imshow(to_variant_t("img"), to_variant_t(img));
	cv->imshow(to_variant_t("dst"), to_variant_t(dst.GetInterfacePtr()));
	cv->imshow(to_variant_t("ret"), to_variant_t(ret.GetInterfacePtr()));
}

static void testKalman(cvLib::ICv_ObjectPtr cv) {
	cvLib::ICv_KalmanFilter_ObjectPtr Cv_KalmanFilter_ObjectPtr;
	HRESULT hr = Cv_KalmanFilter_ObjectPtr.CreateInstance(__uuidof(cvLib::Cv_KalmanFilter_Object));
	assert(SUCCEEDED(hr));

	cvLib::ICv_Mat_ObjectPtr MatPtr;
	hr = MatPtr.CreateInstance(__uuidof(cvLib::Cv_Mat_Object));
	assert(SUCCEEDED(hr));

	auto KF = Cv_KalmanFilter_ObjectPtr->Getcreate(to_variant_t(2), to_variant_t(1), to_variant_t(0));

	KF->transitionMatrix = MatPtr->create(to_variant_t(2), to_variant_t(2), to_variant_t(CV_32F));

	KF->transitionMatrix->set_at(to_variant_t(0), to_variant_t(0), to_variant_t(1));
	KF->transitionMatrix->set_at(to_variant_t(0), to_variant_t(1), to_variant_t(1));
	KF->transitionMatrix->set_at(to_variant_t(1), to_variant_t(0), to_variant_t(0));
	KF->transitionMatrix->set_at(to_variant_t(1), to_variant_t(1), to_variant_t(1));

	_variant_t scalar;

	cv->setIdentity(to_variant_t(KF->measurementMatrix.GetInterfacePtr()), &vtDefault());

	scalar = _OpenCV_ScalarAll(1e-5);
	cv->setIdentity(to_variant_t(KF->processNoiseCov.GetInterfacePtr()), &scalar);

	scalar = _OpenCV_ScalarAll(1e-1);
	cv->setIdentity(to_variant_t(KF->measurementNoiseCov.GetInterfacePtr()), &scalar);

	scalar = _OpenCV_ScalarAll(1);
	cv->setIdentity(to_variant_t(KF->errorCovPost.GetInterfacePtr()), &scalar);

	KF->predict();
}

static void testSearchTemplate(cvLib::ICv_ObjectPtr cv) {
	cvLib::ICv_Mat_ObjectPtr MatPtr;
	auto hr = MatPtr.CreateInstance(__uuidof(cvLib::Cv_Mat_Object));
	assert(SUCCEEDED(hr));

	_bstr_t image_path;

	string_to_bstr(samples::findFile("lena_tmpl.jpg"), image_path);
	auto _img = cv->imread(to_variant_t(image_path), &vtDefault(), &vtDefault());
	assert(V_VT(&_img) == VT_DISPATCH);
	auto img = reinterpret_cast<cvLib::ICv_Mat_Object*>(V_DISPATCH(&_img));

	string_to_bstr(samples::findFile("tmpl.png"), image_path);
	auto _templ = cv->imread(to_variant_t(image_path), &vtDefault(), &vtDefault());
	assert(V_VT(&_templ) == VT_DISPATCH);
	auto templ = reinterpret_cast<cvLib::ICv_Mat_Object*>(V_DISPATCH(&_templ));

	string_to_bstr(samples::findFile("mask.png"), image_path);
	auto _mask = cv->imread(to_variant_t(image_path), &vtDefault(), &vtDefault());
	assert(V_VT(&_mask) == VT_DISPATCH);
	auto mask = reinterpret_cast<cvLib::ICv_Mat_Object*>(V_DISPATCH(&_mask));
	// auto mask = MatPtr->create();

	_variant_t channels = _OpenCV_Tuple(0, 1, 2);
	_variant_t ranges = _OpenCV_Tuple(-200, 200, -200, 200, -200, 200);

	auto _result = cv->searchTemplate(to_variant_t(img), to_variant_t(templ), &vtDefault(), to_variant_t(mask), &channels, &ranges, &vtDefault());

	assert(V_VT(&_result) == VT_DISPATCH);
	auto result = static_cast<cvLib::ICv_Mat_Object*>(V_DISPATCH(&_result));
	assert(result->rows == img->rows - templ->rows + 1);
	assert(result->cols == img->cols - templ->cols + 1);
}

static int perform() {
	testEnumerateDevices();

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
	testConvertToShow(cv);
	testKalman(cv);
	testSearchTemplate(cv);

	cvLib::ICv_VideoCapture_ObjectPtr VideoCapturePtr;
	hr = VideoCapturePtr.CreateInstance(__uuidof(cvLib::Cv_VideoCapture_Object));
	assert(SUCCEEDED(hr));

	_variant_t camId(0);
	auto cap = VideoCapturePtr->Getcreate(&camId);
	if (cap->isOpened() == VARIANT_FALSE) {
		std::wcout << L"Error: cannot open the camera.\n";
		return 1;
	}

	const auto CAP_FPS = 60;
	const auto CAP_SPF = int(1000 / CAP_FPS);

	cap->set(to_variant_t(cv::CAP_PROP_FRAME_WIDTH), to_variant_t(1280));
	cap->set(to_variant_t(cv::CAP_PROP_FRAME_HEIGHT), to_variant_t(720));
	cap->set(to_variant_t(cv::CAP_PROP_FPS), to_variant_t(CAP_FPS));

	auto frame = MatPtr->create();
	auto vframe = _variant_t(frame.GetInterfacePtr());
	auto flipped = MatPtr->create();
	auto vflipped = _variant_t(flipped.GetInterfacePtr());

	CComSafeArray<VARIANT> extended;

	VARIANT variant;
	VariantInit(&variant);
	auto vtFlipped = vtMissing;

	while (true) {
		if (waitKey(30) == 27) {
			break;
		}

		auto start = cv->getTickCount();
		if (cap->read(to_variant_t(frame.GetInterfacePtr())) == VARIANT_FALSE) {
			continue;
		}

		extended.Attach(V_ARRAY(to_variant_t(cv->extended)));
		VariantInit(&variant);
		hr = extended.GetAt(1).Detach(&variant);
		assert(SUCCEEDED(hr));
		extended.Detach();

		auto fps = cv->getTickFrequency() / (cv->getTickCount() - start);

		// in/out version
		assert(!frame->empty());

		cv->flip(&vframe, to_variant_t(1), &vflipped);
		assert(!flipped->empty());

		cv->imshow(to_variant_t(L"capture camera"), &vflipped);

		// extended version
		assert(V_VT(&variant) == VT_DISPATCH);
		frame.Attach(static_cast<cvLib::ICv_Mat_Object*>(V_DISPATCH(&variant)));
		assert(!frame->empty());

		// retval, in/out version
		flipped = cv->flip(&vframe, to_variant_t(1), &vtFlipped);
		assert(!flipped->empty());
		assert(V_VT(&vtFlipped) == VT_DISPATCH);

		auto point = _OpenCV_Tuple(10, 30);
		auto color = _OpenCV_Tuple(255, 0, 255);
		_bstr_t label;
		string_to_bstr("FPS : " + std::to_string(int(fps)), label);
		cv->putText(
			&vflipped,
			to_variant_t(label),
			&point,
			to_variant_t(cv::FONT_HERSHEY_PLAIN),
			to_variant_t(2),
			&color,
			to_variant_t(3),
			&vtDefault(),
			&vtDefault()
		);
		cv->imshow(to_variant_t(L"capture camera"), &vflipped);
	}

	return 0;
}

class CoInitializer {
public:
	CoInitializer() {
		m_hr = CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);
		CV_Assert(SUCCEEDED(m_hr));
	}
	~CoInitializer() {
		if (SUCCEEDED(m_hr)) {
			CoUninitialize();
		}
	}
private:
	HRESULT m_hr;
};

class GdiplusInitializer {
public:
	GdiplusInitializer() {
		Gdiplus::GdiplusStartupInput gdiplusStartupInput;
		m_status = Gdiplus::GdiplusStartup(&m_gdiplusToken, &gdiplusStartupInput, NULL);
		CV_Assert(m_status == Gdiplus::Ok);
	}

	~GdiplusInitializer() {
		if (m_status == Gdiplus::Ok) {
			Gdiplus::GdiplusShutdown(m_gdiplusToken);
		}
	}
private:
	Gdiplus::Status m_status;
	ULONG_PTR m_gdiplusToken;
};

#ifdef _DEBUG
#define BUILD_TYPE "Debug"
#define DEBUG_POSTFIX "d"
#else
#define BUILD_TYPE "Release"
#define DEBUG_POSTFIX ""
#endif

class ActCtxInitializer {
public:
	typedef BOOL(*DllActivateManifest_t)();
	typedef BOOL(*DllDeactivateActCtx_t)();

	ActCtxInitializer() {
		m_lib = LoadLibrary("bin\\" BUILD_TYPE "\\autoit_opencv_com4110" DEBUG_POSTFIX ".dll");
		CV_Assert(m_lib != 0);

		m_DllActivateManifest = (DllActivateManifest_t)GetProcAddress(m_lib, "DllActivateManifest");
		m_Activated = m_DllActivateManifest();
		CV_Assert(m_Activated);

		m_DllDeactivateActCtx = (DllDeactivateActCtx_t)GetProcAddress(m_lib, "DllDeactivateActCtx");
	}

	~ActCtxInitializer() {
		if (m_Activated) {
			CV_Assert(m_DllDeactivateActCtx());
		}

		if (m_lib != 0) {
			FreeLibrary(m_lib);
		}
	}
private:
	HMODULE m_lib = 0;
	BOOL m_Activated = false;
	DllActivateManifest_t m_DllActivateManifest;
	DllDeactivateActCtx_t m_DllDeactivateActCtx;
};

int main(int argc, char* argv[])
{
	CoInitializer coInitializer;
	GdiplusInitializer gdiplusInitializer;
	ActCtxInitializer ActCtxInitializer;
	return perform();
}
