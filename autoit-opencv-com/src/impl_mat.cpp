#include <array>
#include <cstdint>
#include <gdiplus.h>
#include <numeric>
#include <windows.h>

#include <opencv2/imgproc.hpp>
#include "Cv_Object.h"
#include "cvextra.h"
#include "autoit_bridge.h"

#pragma comment(lib, "gdiplus.lib")

const HRESULT autoit_from(cv::MatExpr& in_val, ICv_Mat_Object**& out_val) {
	return autoit_from(cv::Mat(in_val), out_val);
}

const bool is_variant_scalar(VARIANT const* const& in_val) {
	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return false;
	}

	cv::Scalar out_val;
	return SUCCEEDED(autoit_to(in_val, out_val));
}

const bool is_array_from(VARIANT const* const& in_val, bool is_optional) {
	if (PARAMETER_NULL(in_val)) {
		return true;
	}

	if (PARAMETER_NOT_FOUND(in_val)) {
		return is_optional;
	}

	if (V_VT(in_val) != VT_DISPATCH) {
		return is_variant_scalar(in_val);
	}

	return dynamic_cast<IVariantArray*>(getRealIDispatch(in_val)) != NULL;
}

const bool is_arrays_from(VARIANT const* const& in_val, bool is_optional) {
	if (PARAMETER_NULL(in_val)) {
		return true;
	}

	if (PARAMETER_NOT_FOUND(in_val)) {
		return is_optional;
	}

	if (V_VT(in_val) != VT_DISPATCH) {
		return false;
	}

	return dynamic_cast<IVariantArrays*>(getRealIDispatch(in_val)) != NULL;
}

namespace Gdiplus {
	class BitmapLock {
	private:
		bool isOk = false;

	public:
		BitmapLock(
			Bitmap& in_bitmap,
			IN const Rect* rect,
			IN UINT flags,
			IN PixelFormat format
		) : bitmap(in_bitmap) {
			CV_Assert(bitmap.LockBits(rect, flags, format, &data) == Gdiplus::Ok);
			isOk = true;
		}

		BitmapLock(
			Bitmap& in_bitmap,
			IN UINT flags,
			IN PixelFormat format
		) : bitmap(in_bitmap) {
			auto rect = Gdiplus::Rect(0, 0, bitmap.GetWidth(), bitmap.GetHeight());
			CV_Assert(bitmap.LockBits(&rect, flags, format, &data) == Gdiplus::Ok);
			isOk = true;
		}

		BitmapLock(
			Bitmap& in_bitmap,
			IN UINT flags
		) : bitmap(in_bitmap) {
			auto rect = Gdiplus::Rect(0, 0, bitmap.GetWidth(), bitmap.GetHeight());
			CV_Assert(bitmap.LockBits(&rect, flags, bitmap.GetPixelFormat(), &data) == Gdiplus::Ok);
			isOk = true;
		}

		~BitmapLock() {
			if (isOk) {
				CV_Assert(bitmap.UnlockBits(&data) == Gdiplus::Ok);
			}
		}

		Bitmap& bitmap;
		BitmapData data;
	};


	class CvBitmap : public Bitmap {
	public:
		CvBitmap() : Bitmap((GpBitmap*)NULL) {}
		CvBitmap(GpBitmap* nativeBitmap) : Bitmap(nativeBitmap) {}

		CvBitmap(
			_In_ INT width,
			_In_ INT height,
			_In_ INT format
		) : Bitmap(width, height, format) {}

		CvBitmap(
			_In_ INT width,
			_In_ INT height,
			_In_ size_t stride,
			_In_ PixelFormat format,
			_In_reads_opt_(_Inexpressible_("height * stride")) BYTE* scan0
		) : Bitmap(width, height, stride, format, scan0) {}

		GpBitmap* GetNativeImage() {
			return static_cast<GpBitmap*>(nativeImage);
		}

		void Attach(GpImage* newNativeImage) {
			Bitmap::SetNativeImage(newNativeImage);
		}

		GpBitmap* Detach() {
			auto oldNativeImage = static_cast<GpBitmap*>(nativeImage);
			Bitmap::SetNativeImage(NULL);
			return oldNativeImage;
		}

		GpBitmap* CloneNativeImage() {
			int x = 0;
			int y = 0;
			auto width = GetWidth();
			auto height = GetHeight();
			auto format = GetPixelFormat();

			GpBitmap* gpdstBitmap = NULL;
			auto status = DllExports::GdipCloneBitmapAreaI(
				x,
				y,
				width,
				height,
				format,
				static_cast<GpBitmap*>(nativeImage),
				&gpdstBitmap
			);
			CV_Assert(status == Gdiplus::Ok);

			return gpdstBitmap;
		}
	};
}

/**
 *
 * @param bitmap
 * @param mat
 * @param copy   use the same data when possible, otherwise, make a copy
 * @see https://github.com/emgucv/emgucv/blob/4.5.4/Emgu.CV.Platform/Emgu.CV.Bitmap/BitmapExtension.cs#L300
 */
inline void createMatFromBitmap_(Gdiplus::Bitmap& bitmap, cv::Mat& mat, bool copy) {
	using namespace cv;
	using namespace Gdiplus;

	auto width = bitmap.GetWidth();
	auto height = bitmap.GetHeight();
	auto format = bitmap.GetPixelFormat();

	Gdiplus::Rect rect(0, 0, width, height);

	BitmapLock lock(bitmap, &rect, ImageLockModeRead, format);
	BitmapData& data = lock.data;

	if (format == PixelFormat32bppARGB) {
		Mat tmp(height, width, CV_8UC4, data.Scan0, data.Stride);
		if (copy) {
			tmp.copyTo(mat);
		}
		else {
			mat = tmp;
		}
	}
	else if (format == PixelFormat32bppRGB) {
		Mat tmp(height, width, CV_8UC4, data.Scan0, data.Stride);
		mixChannels(tmp, mat, { 0, 0, 1, 1, 2, 2 });
	}
	else if (format == PixelFormat24bppRGB) {
		Mat tmp(height, width, CV_8UC3, data.Scan0, data.Stride);
		if (copy) {
			tmp.copyTo(mat);
		}
		else {
			mat = tmp;
		}
	}
	else if (format == PixelFormat8bppIndexed) {
		Mat bTable(1, 256, CV_8U);
		Mat gTable(1, 256, CV_8U);
		Mat rTable(1, 256, CV_8U);
		Mat aTable(1, 256, CV_8U);

		auto bData = bTable.ptr();
		auto gData = gTable.ptr();
		auto rData = rTable.ptr();
		auto aData = aTable.ptr();

		Gdiplus::ColorPalette palette;
		bitmap.GetPalette(&palette, bitmap.GetPaletteSize());
		for (UINT i = 0; i < palette.Count; i++) {
			Gdiplus::Color color(palette.Entries[i]);
			bData[i] = color.GetBlue();
			gData[i] = color.GetGreen();
			rData[i] = color.GetRed();
			aData[i] = color.GetAlpha();
		}

		Mat indexValue(height, width, CV_8UC1, data.Scan0, data.Stride);

		Mat b, g, r, a;

		cv::LUT(indexValue, bTable, b);
		cv::LUT(indexValue, gTable, g);
		cv::LUT(indexValue, rTable, r);
		cv::LUT(indexValue, aTable, a);

		VectorOfMat mv = { b, g, r, a };
		cv::merge(mv, mat);
	}
	else {
		cv::error(cv::Error::StsAssert, "Unsupported bitmap format", CV_Func, __FILE__, __LINE__);
	}
}

cv::Mat cv::createMatFromBitmap(void* ptr, bool copy) {
	using namespace Gdiplus;

	auto nativeBitmap = static_cast<GpBitmap*>(ptr);

	// Attach nativeBitmap
	CvBitmap bitmap(nativeBitmap);
	CV_Assert(bitmap.GetLastStatus() == Gdiplus::Ok);

	Mat mat; createMatFromBitmap_(bitmap, mat, copy);

	// Detach nativeBitmap
	bitmap.Detach();

	return copy ? mat.clone() : Mat(mat);
}

namespace {
	Gdiplus::ColorPalette* GenerateGrayscalePalette() {
		using namespace Gdiplus;

		static Gdiplus::ColorPalette* palette = NULL;
		if (palette) {
			return palette;
		}

		Bitmap image(1, 1, PixelFormat8bppIndexed);
		int palsize = image.GetPaletteSize();
		palette = reinterpret_cast<Gdiplus::ColorPalette*>(new BYTE[palsize]);
		image.GetPalette(palette, palsize);

		for (int i = 0; i < 256; i++) {
			palette->Entries[i] = Gdiplus::Color(i, i, i).GetValue();
		}

		return palette;
	}

	void RawDataToBitmap(cv::Mat& image, int dstColorType, int channels, int srcDepth, Gdiplus::CvBitmap& dst) {
		using namespace Gdiplus;

		auto scan0 = image.ptr();
		auto step = image.step1();
		auto size = image.size();

		// The value passed to stride parameter must be a multiple of four.
		if (step % 4 == 0) {
			if (dstColorType == CV_8UC1 && srcDepth == CV_8U) {
				CvBitmap bmpGray(
					size.width,
					size.height,
					step,
					PixelFormat8bppIndexed,
					scan0
				);

				CV_Assert(bmpGray.GetLastStatus() == Gdiplus::Ok);

				bmpGray.SetPalette(GenerateGrayscalePalette());

				dst.Attach(bmpGray.Detach());
				return;
			}
			else if (dstColorType == CV_8UC3 && srcDepth == CV_8U) {
				CvBitmap bmp(
					size.width,
					size.height,
					step,
					PixelFormat24bppRGB,
					scan0
				);

				CV_Assert(bmp.GetLastStatus() == Gdiplus::Ok);

				dst.Attach(bmp.Detach());
				return;
			}
			else if (dstColorType == CV_8UC4 && srcDepth == CV_8U) {
				CvBitmap bmp(
					size.width,
					size.height,
					step,
					PixelFormat32bppARGB,
					scan0
				);

				CV_Assert(bmp.GetLastStatus() == Gdiplus::Ok);

				dst.Attach(bmp.Detach());
				return;
			}
		}

		PixelFormat format;

		if (dstColorType == CV_8UC1) { // if this is a gray scale image
			format = PixelFormat8bppIndexed;
		}
		else if (dstColorType == CV_8UC4) { // if this is Bgra image
			format = PixelFormat32bppARGB;
		}
		else if (dstColorType == CV_8UC3) { // if this is a Bgr image
			format = PixelFormat24bppRGB;
		}
		else { // convert to a 3 channels matrix
			cv::Mat m(size.height, size.width, CV_MAKETYPE(srcDepth, channels), scan0, step);
			cv::Mat m2;
			cv::cvtColor(m, m2, dstColorType, CV_8UC3);
			RawDataToBitmap(m2, CV_8UC3, 3, srcDepth, dst);
			return;
		}

		CvBitmap bmp(size.width, size.height, format);
		CV_Assert(bmp.GetLastStatus() == Gdiplus::Ok);

		{
			// Block to ensure unlocks before detach
			auto rect = Gdiplus::Rect(0, 0, size.width, size.height);
			BitmapLock lock(bmp, &rect, ImageLockModeWrite, format);
			BitmapData& data = lock.data;
			cv::Mat bmpMat(size.height, size.width, CV_MAKETYPE(CV_8U, channels), data.Scan0, data.Stride);
			cv::Mat srcMat(size.height, size.width, CV_MAKETYPE(srcDepth, channels), scan0, step);

			if (srcDepth == CV_8U) {
				srcMat.copyTo(bmpMat);
			}
			else {
				double scale = 1.0, shift = 0.0;
				double minVal = 0, maxVal = 0;
				cv::Point minLoc, maxLoc;
				if (channels == 1) {
					minMaxLoc(srcMat, &minVal, &maxVal, &minLoc, &maxLoc);
				}
				else {
					minMaxLoc(srcMat.reshape(1), &minVal, &maxVal, &minLoc, &maxLoc);
				}

				scale = (float)maxVal == (float)minVal ? 0.0 : 255.0 / (maxVal - minVal);
				shift = scale == 0 ? minVal : -minVal * scale;

				srcMat.convertTo(bmpMat, CV_8U, scale, shift);
			}
		}

		if (format == PixelFormat8bppIndexed) {
			bmp.SetPalette(GenerateGrayscalePalette());
		}

		dst.Attach(bmp.Detach());
	}
}

/**
 * @param image [description]
 * @param dst   [description]
 * @param toRGB [description]
 * @see https://github.com/opencv/opencv/blob/4.7.0/modules/highgui/src/precomp.hpp#L152
 */
void autoit::cvextra::convertToShow(cv::InputArray image, cv::Mat& dst, bool toRGB) {
	cv::Mat src = image.getMat();

	double scale = 1.0, shift = 0.0;
	double minVal = 0, maxVal = 0;
	cv::Point minLoc, maxLoc;

	const int src_depth = src.depth();
	CV_Assert(src_depth != CV_16F && src_depth != CV_32S);
	cv::Mat tmp;

	switch (src_depth)
	{
	case CV_8U:
		tmp = src;
		break;
	case CV_8S:
		cv::convertScaleAbs(src, tmp, 1, 127);
		break;
	case CV_16S:
		cv::convertScaleAbs(src, tmp, 1 / 255., 127);
		break;
	case CV_16U:
		cv::convertScaleAbs(src, tmp, 1 / 255.);
		break;
	case CV_32F:
	case CV_64F:
		if (src.channels() == 1) {
			cv::minMaxLoc(src, &minVal, &maxVal, &minLoc, &maxLoc);
		}
		else {
			cv::minMaxLoc(src.reshape(1), &minVal, &maxVal, &minLoc, &maxLoc);
		}

		scale = (float)maxVal == (float)minVal ? 0.0 : 255.0 / (maxVal - minVal);
		shift = scale == 0 ? minVal : -minVal * scale;

		src.convertTo(tmp, CV_8U, scale, shift);

		break;
	default:
		cv::error(cv::Error::StsAssert, "Unsupported mat type", CV_Func, __FILE__, __LINE__);
	}

	cv::cvtColor(tmp, dst, toRGB ? cv::COLOR_BGR2RGB : cv::COLOR_BGRA2BGR, dst.channels());
}

/**
 * [CCv_Mat_Object::convertToBitmap description]
 * @param copy   use the same data when possible, otherwise, make a copy
 * @param hr
 * @return   a pointer to a GpBitmap with Mat data copied
 * @see https://github.com/emgucv/emgucv/blob/4.5.4/Emgu.CV.Platform/Emgu.CV.Bitmap/BitmapExtension.cs#L206
 */
const void* autoit::cvextra::convertToBitmap(cv::InputArray image, bool copy) {
	using namespace Gdiplus;
	cv::Mat src = image.getMat();

	if (src.dims > 3 || src.empty()) {
		return NULL;
	}

	auto channels = src.channels();
	int colorType = CV_MAKETYPE(CV_8U, channels);

	if (channels == 1) {
		if ((src.cols | 3) != 0) { //handle the special case where width is not a multiple of 4
			CvBitmap bitmap(src.cols, src.rows, PixelFormat8bppIndexed);
			CV_Assert(bitmap.GetLastStatus() == Gdiplus::Ok);

			bitmap.SetPalette(GenerateGrayscalePalette());
			{
				// Block to ensure unlocks before detach
				auto rect = Gdiplus::Rect(0, 0, bitmap.GetWidth(), bitmap.GetHeight());
				BitmapLock lock(bitmap, &rect, ImageLockModeWrite, PixelFormat8bppIndexed);
				BitmapData& bitmapData = lock.data;
				cv::Mat dst(src.size(), CV_8UC1, bitmapData.Scan0, bitmapData.Stride);
				src.copyTo(dst);
			}

			return bitmap.Detach();
		}
	}
	else if (channels != 3 && channels != 4) {
		cv::error(cv::Error::StsAssert, "Unknown color type", CV_Func, __FILE__, __LINE__);
	}

	CvBitmap dst;
	RawDataToBitmap(src, colorType, channels, src.depth(), dst);
	return copy ? dst.CloneNativeImage() : dst.Detach();
}

void autoit::cvextra::GdiplusResize(cv::InputArray image, cv::Mat& dst, float newWidth, float newHeight, int interpolation) {
	using namespace Gdiplus;

	GpBitmap* nativeBitmap = static_cast<GpBitmap*>(const_cast<void*>(convertToBitmap(image, true)));
	CvBitmap bitmap(nativeBitmap);
	CV_Assert(bitmap.GetLastStatus() == Gdiplus::Ok);

	CvBitmap hBitmap(static_cast<int>(newWidth), static_cast<int>(newHeight), bitmap.GetPixelFormat());
	CV_Assert(hBitmap.GetLastStatus() == Gdiplus::Ok);

	Gdiplus::Graphics hBmpCtxt(&hBitmap);
	CV_Assert(hBmpCtxt.GetLastStatus() == Gdiplus::Ok);

	CV_Assert(hBmpCtxt.SetInterpolationMode(static_cast<Gdiplus::InterpolationMode>(interpolation)) == Gdiplus::Ok);

	if (interpolation == Gdiplus::InterpolationMode::InterpolationModeHighQuality ||
		interpolation == Gdiplus::InterpolationMode::InterpolationModeHighQualityBicubic ||
		interpolation == Gdiplus::InterpolationMode::InterpolationModeHighQualityBilinear) {
		CV_Assert(hBmpCtxt.SetPixelOffsetMode(Gdiplus::PixelOffsetMode::PixelOffsetModeHighQuality) == Gdiplus::Ok);
	}

	Gdiplus::ImageAttributes hIA;
	hIA.SetWrapMode(Gdiplus::WrapModeTileFlipXY, Gdiplus::Color(0xFF, 0, 0, 0));
	Gdiplus::RectF rect(0.0, 0.0, newWidth, newHeight);
	CV_Assert(hBmpCtxt.DrawImage(&bitmap, rect, 0, 0, bitmap.GetWidth(), bitmap.GetHeight(), Gdiplus::UnitPixel, &hIA) == Gdiplus::Ok);

	createMatFromBitmap_(hBitmap, dst, true);
}

template<typename _Tp>
static const std::string join(_Tp* elements, size_t size, const std::string& separator = ",") {
	std::ostringstream o;
	for (size_t i = 0; i < size; i++) {
		if (i != 0) {
			o << separator;
		}
		o << elements[i];
	}
	return o.str();
}

static int _inferDepth(ATL::CComSafeArray<VARIANT>& vArray, HRESULT& hr) {
	const UINT uDims = vArray.GetDimensions();
	LONG* lSizes = new LONG[uDims * 3];
	LONG size = 1;

	for (UINT uDim = 0; uDim < uDims; uDim++) {
		auto lLower = vArray.GetLowerBound(uDim);
		auto lUpper = vArray.GetUpperBound(uDim);
		auto count = lUpper - lLower + 1;

		lSizes[uDim * 3] = count;
		lSizes[uDim * 3 + 1] = lLower;
		lSizes[uDim * 3 + 2] = size;

		size *= count;
	}

	LONG* aIndex = new LONG[uDims];
	LONGLONG minVal = 0;
	ULONGLONG maxVal = 0;
	VARIANT v;
	VariantInit(&v);

	bool has_char = false;
	bool has_byte = false;
	bool has_short = false;
	bool has_ushort = false;
	bool has_int = false;
	bool has_uint = false;
	bool has_long = false;
	bool has_ulong = false;
	bool has_int64 = false;
	bool has_uint64 = false;
	bool has_float = false;
	bool has_double = false;

	for (LONG i = 0; !has_double && i < size; i++) {
		LONG index = i;

		for (UINT uDim = 0; uDim < uDims; uDim++) {
			auto usDim = uDims - uDim - 1;
			auto d = lSizes[3 * usDim + 2];
			auto r = index % d;
			auto q = (index - r) / d;

			aIndex[usDim] = q;
			index -= q * d;
		}

		AUTOIT_ASSERT_THROW(SUCCEEDED(vArray.MultiDimGetAt(aIndex, v)), "Failed get element at [" << join(aIndex, uDims, "][") << "]");

		switch (V_VT(&v)) {
		case VT_I1:
			has_char = true;
			minVal = minVal > V_I1(&v) ? V_I1(&v) : minVal;
			maxVal = V_I1(&v) > 0 && maxVal < V_I1(&v) ? V_I1(&v) : maxVal;
			break;
		case VT_I2:
			has_short = true;
			minVal = minVal > V_I2(&v) ? V_I2(&v) : minVal;
			maxVal = V_I2(&v) > 0 && maxVal < V_I2(&v) ? V_I2(&v) : maxVal;
			break;
		case VT_INT:
			has_int = true;
			minVal = minVal > V_INT(&v) ? V_INT(&v) : minVal;
			maxVal = V_INT(&v) > 0 && maxVal < V_INT(&v) ? V_INT(&v) : maxVal;
			break;
		case VT_I4:
			has_long = true;
			minVal = minVal > V_I4(&v) ? V_I4(&v) : minVal;
			maxVal = V_I4(&v) > 0 && maxVal < V_I4(&v) ? V_I4(&v) : maxVal;
			break;
		case VT_I8:
			has_int64 = true;
			minVal = minVal > V_I8(&v) ? V_I8(&v) : minVal;
			maxVal = V_I8(&v) > 0 && maxVal < V_I8(&v) ? V_I8(&v) : maxVal;
			break;
		case VT_UI1:
			has_byte = true;
			maxVal = maxVal < V_UI1(&v) ? V_UI1(&v) : maxVal;
			break;
		case VT_UI2:
			has_ushort = true;
			maxVal = maxVal < V_UI2(&v) ? V_UI2(&v) : maxVal;
			break;
		case VT_UINT:
			has_uint = true;
			maxVal = maxVal < V_UINT(&v) ? V_UINT(&v) : maxVal;
			break;
		case VT_UI4:
			has_ulong = true;
			maxVal = maxVal < V_UI4(&v) ? V_UI4(&v) : maxVal;
			break;
		case VT_UI8:
			has_uint64 = true;
			maxVal = maxVal < V_UI8(&v) ? V_UI8(&v) : maxVal;
			break;
		case VT_R4:
			has_float = true;
			break;
		case VT_R8:
			has_double = true;
			break;
		default:
			hr = E_INVALIDARG;
			i = size - 1;
		}
	}

	delete[] aIndex;

	if (has_double || has_int64 || has_uint64) {
		return CV_64F;
	}

	if (has_float || (has_int && has_uint && maxVal > ((1 << 31) - 1)) || (has_long && has_ulong && maxVal > ((1 << 31) - 1))) {
		return CV_32F;
	}

	if (has_int || has_long || has_ushort) {
		return CV_32S;
	}

	if (has_short) {
		return CV_16S;
	}

	if (has_byte) {
		return CV_8U;
	}

	return CV_8S;
}

template<typename _Tp>
const void _createFromArray(ATL::CComSafeArray<VARIANT>& vArray, int depth, HRESULT& hr, cv::Mat& result) {
	const UINT uDims = vArray.GetDimensions();
	_Tp value;

	if (uDims == 3) {
		LONG rowsLower = vArray.GetLowerBound(2);
		LONG rowsUpper = vArray.GetUpperBound(2);
		auto rows = rowsUpper - rowsLower + 1;

		LONG colsLower = vArray.GetLowerBound(1);
		LONG colsUpper = vArray.GetUpperBound(1);
		auto cols = colsUpper - colsLower + 1;

		LONG channelsLower = vArray.GetLowerBound(0);
		LONG channelsUpper = vArray.GetUpperBound(0);
		auto channels = channelsUpper - channelsLower + 1;

		result = cv::Mat(rows, cols, CV_MAKETYPE(depth, channels));

		LONG aIndex[3];
		VARIANT v;
		VariantInit(&v);

		for (LONG i = 0; i < rows; i++) {
			aIndex[2] = i + rowsLower;
			for (LONG j = 0; j < cols; j++) {
				aIndex[1] = j + colsLower;
				for (LONG k = 0; k < channels; k++) {
					aIndex[0] = k + channelsLower;
					AUTOIT_ASSERT_THROW(SUCCEEDED(vArray.MultiDimGetAt(aIndex, v)), "Failed get element at [" << join(aIndex, uDims, "][") << "]");
					VARIANT* pv = &v;

					hr = autoit_to(pv, value);
					if (FAILED(hr)) {
						AUTOIT_ERROR("element at [" << i << "][" << j << "][" << k << "] is not of type " << typeid(_Tp).name());
						return;
					}

					result.ptr<_Tp>(i, j)[k] = value;
				}
			}
		}
	}
	else if (uDims == 2) {
		LONG rowsLower = vArray.GetLowerBound(1);
		LONG rowsUpper = vArray.GetUpperBound(1);
		auto rows = rowsUpper - rowsLower + 1;

		LONG colsLower = vArray.GetLowerBound(0);
		LONG colsUpper = vArray.GetUpperBound(0);
		auto cols = colsUpper - colsLower + 1;

		result = cv::Mat(rows, cols, CV_MAKETYPE(depth, 1));

		LONG aIndex[2];
		VARIANT v;
		VariantInit(&v);

		for (LONG i = 0; i < rows; i++) {
			aIndex[1] = i + rowsLower;
			for (LONG j = 0; j < cols; j++) {
				aIndex[0] = j + colsLower;
				AUTOIT_ASSERT_THROW(SUCCEEDED(vArray.MultiDimGetAt(aIndex, v)), "Failed get element at [" << join(aIndex, uDims, "][") << "]");
				VARIANT* pv = &v;

				hr = autoit_to(pv, value);
				if (FAILED(hr)) {
					AUTOIT_ERROR("element at [" << i << "][" << j << "] is not of type " << typeid(_Tp).name() << "; type = " << V_VT(pv));
					return;
				}

				result.at<_Tp>(i, j) = value;
			}
		}
	}
	else if (uDims == 1) {
		LONG colsLower = vArray.GetLowerBound();
		LONG colsUpper = vArray.GetUpperBound();
		auto cols = colsUpper - colsLower + 1;

		result = cv::Mat(1, cols, CV_MAKETYPE(depth, 1));

		for (LONG i = 0; i < cols; i++) {
			auto& v = vArray.GetAt(i + colsLower);
			VARIANT* pv = &v;

			hr = autoit_to(pv, value);
			if (FAILED(hr)) {
				AUTOIT_ERROR("element at [" << i << "] is not of type " << typeid(_Tp).name());
				return;
			}

			result.at<_Tp>(i) = value;
		}
	}
	else {
		hr = E_INVALIDARG;
	}
}

const cv::Mat CCv_Mat_Object::createFromArray(_variant_t& array, int depth, HRESULT& hr) {
	VARIANT* in_val = &array;
	cv::Mat result;

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		hr = E_INVALIDARG;
		return result;
	}

	ATL::CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(in_val));

	if (vArray.GetDimensions() > 3) {
		vArray.Detach();
		hr = E_INVALIDARG;
		return result;
	}

	if (depth == -1) {
		depth = _inferDepth(vArray, hr);
		if (FAILED(hr)) {
			vArray.Detach();
			return result;
		}
	}

	switch (depth) {
	case CV_8U:
		_createFromArray<byte>(vArray, depth, hr, result);
		break;
	case CV_8S:
		_createFromArray<char>(vArray, depth, hr, result);
		break;
	case CV_16U:
		_createFromArray<ushort>(vArray, depth, hr, result);
		break;
	case CV_16S:
		_createFromArray<short>(vArray, depth, hr, result);
		break;
	case CV_32S:
		_createFromArray<int>(vArray, depth, hr, result);
		break;
	case CV_32F:
		_createFromArray<float>(vArray, depth, hr, result);
		break;
	case CV_64F:
		_createFromArray<double>(vArray, depth, hr, result);
		break;
	default:
		AUTOIT_ERROR("depth must be one of CV_8U CV_8S CV_16U CV_16S CV_32S CV_32F CV_64F");
		hr = E_INVALIDARG;
		break;
	}

	vArray.Detach();

	return result;
}

template<typename _Tp>
static LPSAFEARRAY _asArray(const cv::Mat& mat) {
	auto rows = mat.rows;
	auto cols = mat.cols;
	auto channels = mat.channels();

	UINT uDims;
	if (channels == 1) {
		uDims = cols == 1 ? 1 : 2;
	}
	else if (cols == 1) {
		uDims = 2;
	}
	else {
		uDims = 3;
	}

	// Define the array bound structure
	CComSafeArrayBound* bound = new CComSafeArrayBound[uDims];

	if (uDims == 1) {
		bound[0].SetCount(rows * cols * channels);
		bound[0].SetLowerBound(0);
	}
	else if (uDims == 2) {
		bound[1].SetCount(rows);
		bound[1].SetLowerBound(0);
		bound[0].SetCount(cols * channels);
		bound[0].SetLowerBound(0);
	}
	else if (uDims == 3) {
		bound[2].SetCount(rows);
		bound[2].SetLowerBound(0);
		bound[1].SetCount(cols);
		bound[1].SetLowerBound(0);
		bound[0].SetCount(channels);
		bound[0].SetLowerBound(0);
	}

	ATL::CComSafeArray<VARIANT> vArray(bound, uDims);
	LONG* aIndex = new LONG[uDims];
	VARIANT v;
	VARIANT* pv = &v;
	VariantInit(pv);

	if (uDims == 3) {
		for (LONG i = 0; i < rows; i++) {
			aIndex[2] = i;
			for (LONG j = 0; j < cols; j++) {
				aIndex[1] = j;
				for (LONG k = 0; k < channels; k++) {
					aIndex[0] = k;
					AUTOIT_ASSERT_THROW(SUCCEEDED(autoit_from(mat.ptr<_Tp>(i, j)[k], pv)), "Failed get element at [" << join(aIndex, uDims, "][") << "]");
					AUTOIT_ASSERT_THROW(SUCCEEDED(vArray.MultiDimSetAt(aIndex, v)), "Failed set element at [" << join(aIndex, uDims, "][") << "]");
					VariantClear(pv);
				}
			}
		}
	}
	else if (uDims == 2) {
		for (LONG i = 0; i < rows; i++) {
			aIndex[1] = i;
			for (LONG j = 0; j < cols; j++) {
				for (LONG k = 0; k < channels; k++) {
					aIndex[0] = j * channels + k;
					AUTOIT_ASSERT_THROW(SUCCEEDED(autoit_from(mat.ptr<_Tp>(i, j)[k], pv)), "Failed get element at [" << join(aIndex, uDims, "][") << "]");
					AUTOIT_ASSERT_THROW(SUCCEEDED(vArray.MultiDimSetAt(aIndex, v)), "Failed set element at [" << join(aIndex, uDims, "][") << "]");
					VariantClear(pv);
				}
			}
		}
	}
	else {
		for (LONG i = 0; i < rows; i++) {
			for (LONG j = 0; j < cols; j++) {
				for (LONG k = 0; k < channels; k++) {
					AUTOIT_ASSERT_THROW(SUCCEEDED(autoit_from(mat.ptr<_Tp>(i, j)[k], pv)), "Failed get element at [" << join(aIndex, uDims, "][") << "]");
					AUTOIT_ASSERT_THROW(SUCCEEDED(vArray.SetAt((i * cols + j) * channels + k, v)), "Failed set element at [" << join(aIndex, uDims, "][") << "]");
					VariantClear(pv);
				}
			}
		}
	}

	delete[] bound;
	delete[] aIndex;

	return vArray.Detach();
}

const _variant_t CCv_Mat_Object::asArray(HRESULT& hr) {
	_variant_t res;
	VariantInit(&res);
	VARIANT* out_val = &res;

	const auto& mat = *__self->get();

	if (mat.dims > 2) {
		AUTOIT_ERROR("mat dimension must be at most 2");
		hr = E_INVALIDARG;
		return res;
	}

	V_VT(out_val) = VT_ARRAY | VT_VARIANT;

	switch (mat.depth()) {
	case CV_8U:
		V_ARRAY(out_val) = _asArray<byte>(mat);
		break;
	case CV_8S:
		V_ARRAY(out_val) = _asArray<char>(mat);
		break;
	case CV_16U:
		V_ARRAY(out_val) = _asArray<ushort>(mat);
		break;
	case CV_16S:
		V_ARRAY(out_val) = _asArray<short>(mat);
		break;
	case CV_32S:
		V_ARRAY(out_val) = _asArray<int>(mat);
		break;
	case CV_32F:
		V_ARRAY(out_val) = _asArray<float>(mat);
		break;
	case CV_64F:
		V_ARRAY(out_val) = _asArray<double>(mat);
		break;
	default:
		AUTOIT_ERROR("depth must be one of CV_8U CV_8S CV_16U CV_16S CV_32S CV_32F CV_64F");
		hr = E_INVALIDARG;
		break;
	}

	return res;
}

const _variant_t CCv_Mat_Object::PixelSearch(cv::Scalar& color, int left, int top, int right, int bottom, uchar shade_variation, int step, HRESULT& hr) {
	using namespace cv;

	auto& src = *__self->get();

	// accept only char type matrices
	CV_Assert(src.depth() == CV_8U);

	// Support NOMINMAX by defining local min max macros 
#define PIXELSEARCH_MIN(a,b) (((a) < (b)) ? (a) : (b))
#define PIXELSEARCH_MAX(a,b) (((a) > (b)) ? (a) : (b))

	left = PIXELSEARCH_MAX(0, left);
	right = PIXELSEARCH_MIN(src.cols - 1, right);
	top = PIXELSEARCH_MAX(0, top);
	bottom = PIXELSEARCH_MIN(src.rows - 1, bottom);

#pragma warning( push )
#pragma warning( disable : 4244)
	int min_blue = PIXELSEARCH_MAX(0, color[0] - shade_variation);
	int min_green = PIXELSEARCH_MAX(0, color[1] - shade_variation);
	int min_red = PIXELSEARCH_MAX(0, color[2] - shade_variation);

	int max_blue = PIXELSEARCH_MIN(0xFF, color[0] + shade_variation);
	int max_green = PIXELSEARCH_MIN(0xFF, color[1] + shade_variation);
	int max_red = PIXELSEARCH_MIN(0xFF, color[2] + shade_variation);
#pragma warning( pop )

	int hstep = step == 0 ? 1 : left > right ? -step : step;
	int vstep = step == 0 ? 1 : top > bottom ? -step : step;

#undef PIXELSEARCH_MIN
#undef PIXELSEARCH_MAX

	_variant_t res;
	VariantInit(&res);
	VARIANT* out_val = &res;

	switch (src.channels()) {
	case 1:
	{
		for (int i = top; (vstep > 0 ? i <= bottom : i >= bottom); i += vstep) {
			for (int j = left; (hstep > 0 ? j <= right : j >= right); j += hstep) {
				if (min_blue <= src.at<uchar>(i, j) && src.at<uchar>(i, j) <= max_blue) {
					hr = autoit_from(cv::Point(j, i), out_val);
					goto end_swith;
				}
			}
		}
		break;
	}
	case 3:
	case 4:
	{
		for (int i = top; (vstep > 0 ? i <= bottom : i >= bottom); i += vstep) {
			for (int j = left; (hstep > 0 ? j <= right : j >= right); j += hstep) {
				auto& pixel = src.at<Vec3b>(i, j);
				BYTE blue = pixel[0];
				BYTE green = pixel[1];
				BYTE red = pixel[2];

				if (
					min_blue <= blue && blue <= max_blue &&
					min_green <= green && green <= max_green &&
					min_red <= red && red <= max_red
					) {
					hr = autoit_from(cv::Point(j, i), out_val);
					goto end_swith;
				}
			}
		}
		break;
	}
	}

	V_VT(&res) = VT_NULL;

end_swith:
	return _variant_t(res);
}

const _variant_t CCv_Mat_Object::PixelSearch(cv::Scalar& color, cv::Rect& rect, uchar shade_variation, int step, HRESULT& hr) {
	return PixelSearch(color, rect.x, rect.y, rect.x + rect.width - 1, rect.y + rect.height - 1, shade_variation, step, hr);
}

const std::uint_fast32_t MOD_ADLER = 65521;

const std::uint_fast32_t adler32(cv::Mat& src, const int left, const int top, const int right, const int bottom, const int hstep, const int vstep) {
	std::uint_fast32_t a = 1, b = 0;

	int channels = src.channels();

	for (int i = top; (vstep > 0 ? i <= bottom : i >= bottom); i += vstep) {
		for (int j = left; (hstep > 0 ? j <= right : j >= right); j += hstep) {
			uchar* data = src.ptr<uchar>(i, j);
			for (int k = 0; k < channels; k++) {
				a = (a + data[k]) % MOD_ADLER;
				b = (b + a) % MOD_ADLER;
			}
		}
	}

	return (b << 16) | a;
}

/**
 * Generates a lookup table for the checksums of all 8-bit values.
 * @see https://rosettacode.org/wiki/CRC-32#C.2B.2B
 */
std::array<std::uint_fast32_t, 256> generate_crc_lookup_table() noexcept {
	auto const reversed_polynomial = std::uint_fast32_t{ 0xEDB88320uL };

	// This is a function object that calculates the checksum for a value,
	// then increments the value, starting from zero.
	struct byte_checksum {
		std::uint_fast32_t operator()() noexcept {
			auto checksum = static_cast<std::uint_fast32_t>(n++);

			for (auto i = 0; i < 8; ++i)
				checksum = (checksum >> 1) ^ ((checksum & 0x1u) ? reversed_polynomial : 0);

			return checksum;
		}

		unsigned n = 0;
	};

	auto table = std::array<std::uint_fast32_t, 256>{};
	std::generate(table.begin(), table.end(), byte_checksum{});

	return table;
}

const std::uint_fast32_t crc32(cv::Mat& src, const int left, const int top, const int right, const int bottom, const int hstep, const int vstep) {
	// Generate lookup table only on first use then cache it - this is thread-safe.
	static auto const table = generate_crc_lookup_table();

	std::uint_fast32_t checksum = ~std::uint_fast32_t{ 0 } &std::uint_fast32_t{ 0xFFFFFFFFuL };

	int channels = src.channels();

	for (int i = top; (vstep > 0 ? i <= bottom : i >= bottom); i += vstep) {
		for (int j = left; (hstep > 0 ? j <= right : j >= right); j += hstep) {
			uchar* data = src.ptr<uchar>(i, j);
			for (int k = 0; k < channels; k++) {
				std::uint_fast8_t value = data[k];
				checksum = table[(checksum ^ value) & 0xFFu] ^ (checksum >> 8);
			}
		}
	}

	return ~checksum;
}

const size_t CCv_Mat_Object::PixelChecksum(int left, int top, int right, int bottom, int step, int mode, HRESULT& hr) {
	auto& src = *__self->get();

	// accept only char type matrices
	CV_Assert(src.depth() == CV_8U);

	// Support NOMINMAX by defining local min max macros 
#define PIXELSEARCH_MIN(a,b) (((a) < (b)) ? (a) : (b))
#define PIXELSEARCH_MAX(a,b) (((a) > (b)) ? (a) : (b))

	left = PIXELSEARCH_MAX(0, left);
	right = PIXELSEARCH_MIN(src.cols - 1, right);
	top = PIXELSEARCH_MAX(0, top);
	bottom = PIXELSEARCH_MIN(src.rows - 1, bottom);

	int hstep = step == 0 ? 1 : left > right ? -step : step;
	int vstep = step == 0 ? 1 : top > bottom ? -step : step;

#undef PIXELSEARCH_MIN
#undef PIXELSEARCH_MAX

	return mode == 1 ? crc32(src, left, top, right, bottom, hstep, vstep) : adler32(src, left, top, right, bottom, hstep, vstep);
}

const size_t CCv_Mat_Object::PixelChecksum(cv::Rect& rect, int step, int mode, HRESULT& hr) {
	return PixelChecksum(rect.x, rect.y, rect.x + rect.width - 1, rect.y + rect.height - 1, step, mode, hr);
}
