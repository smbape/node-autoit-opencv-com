#include "Cv_Object.h"
#include <array>
#include <cstdint>
#include <numeric>
#include <gdiplus.h>
#pragma comment(lib, "gdiplus.lib")

const Point2d CCv_Mat_Object::Point_at(int x, HRESULT& hr) {
	switch (this->__self->get()->depth()) {
	case CV_8U:
		return Point2d(this->__self->get()->at<Vec2b>(x)[0], this->__self->get()->at<Vec2b>(x)[1]);
	case CV_8S:
		return Point2d(this->__self->get()->at<Vec<char, 2>>(x)[0], this->__self->get()->at<Vec<char, 2>>(x)[1]);
	case CV_16U:
		return Point2d(this->__self->get()->at<Vec2w>(x)[0], this->__self->get()->at<Vec2w>(x)[1]);
	case CV_16S:
		return Point2d(this->__self->get()->at<Vec2s>(x)[0], this->__self->get()->at<Vec2s>(x)[1]);
	case CV_32S:
		return Point2d(this->__self->get()->at<Vec2i>(x)[0], this->__self->get()->at<Vec2i>(x)[1]);
	case CV_32F:
		return Point2d(this->__self->get()->at<Vec2f>(x)[0], this->__self->get()->at<Vec2f>(x)[1]);
	case CV_64F:
		return Point2d(this->__self->get()->at<Vec2d>(x)[0], this->__self->get()->at<Vec2d>(x)[1]);
	default:
		return Point2d();
	}
}

const Point2d CCv_Mat_Object::Point_at(int x, int y, HRESULT& hr) {
	switch (this->__self->get()->depth()) {
	case CV_8U:
		return Point2d(this->__self->get()->at<Vec2b>(x, y)[0], this->__self->get()->at<Vec2b>(x, y)[1]);
	case CV_8S:
		return Point2d(this->__self->get()->at<Vec<char, 2>>(x, y)[0], this->__self->get()->at<Vec<char, 2>>(x, y)[1]);
	case CV_16U:
		return Point2d(this->__self->get()->at<Vec2w>(x, y)[0], this->__self->get()->at<Vec2w>(x, y)[1]);
	case CV_16S:
		return Point2d(this->__self->get()->at<Vec2s>(x, y)[0], this->__self->get()->at<Vec2s>(x, y)[1]);
	case CV_32S:
		return Point2d(this->__self->get()->at<Vec2i>(x, y)[0], this->__self->get()->at<Vec2i>(x, y)[1]);
	case CV_32F:
		return Point2d(this->__self->get()->at<Vec2f>(x, y)[0], this->__self->get()->at<Vec2f>(x, y)[1]);
	case CV_64F:
		return Point2d(this->__self->get()->at<Vec2d>(x, y)[0], this->__self->get()->at<Vec2d>(x, y)[1]);
	default:
		return Point2d();
	}
}

const Point2d CCv_Mat_Object::Point_at(Point& pt, HRESULT& hr) {
	switch (this->__self->get()->depth()) {
	case CV_8U:
		return Point2d(this->__self->get()->at<Vec2b>(pt)[0], this->__self->get()->at<Vec2b>(pt)[1]);
	case CV_8S:
		return Point2d(this->__self->get()->at<Vec<char, 2>>(pt)[0], this->__self->get()->at<Vec<char, 2>>(pt)[1]);
	case CV_16U:
		return Point2d(this->__self->get()->at<Vec2w>(pt)[0], this->__self->get()->at<Vec2w>(pt)[1]);
	case CV_16S:
		return Point2d(this->__self->get()->at<Vec2s>(pt)[0], this->__self->get()->at<Vec2s>(pt)[1]);
	case CV_32S:
		return Point2d(this->__self->get()->at<Vec2i>(pt)[0], this->__self->get()->at<Vec2i>(pt)[1]);
	case CV_32F:
		return Point2d(this->__self->get()->at<Vec2f>(pt)[0], this->__self->get()->at<Vec2f>(pt)[1]);
	case CV_64F:
		return Point2d(this->__self->get()->at<Vec2d>(pt)[0], this->__self->get()->at<Vec2d>(pt)[1]);
	default:
		return Point2d();
	}
}

const double CCv_Mat_Object::at(int x, HRESULT& hr) {
	switch (this->__self->get()->depth()) {
	case CV_8U:
		return this->__self->get()->at<uchar>(x);
	case CV_8S:
		return this->__self->get()->at<char>(x);
	case CV_16U:
		return this->__self->get()->at<ushort>(x);
	case CV_16S:
		return this->__self->get()->at<short>(x);
	case CV_32S:
		return this->__self->get()->at<int>(x);
	case CV_32F:
		return this->__self->get()->at<float>(x);
	case CV_64F:
		return this->__self->get()->at<double>(x);
	default:
		return 0;
	}
}

void CCv_Mat_Object::set_at(int x, double value, HRESULT& hr) {
	switch (this->__self->get()->depth()) {
	case CV_8U:
		this->__self->get()->at<uchar>(x) = static_cast<uchar>(value);
		break;
	case CV_8S:
		this->__self->get()->at<char>(x) = static_cast<char>(value);
		break;
	case CV_16U:
		this->__self->get()->at<ushort>(x) = static_cast<ushort>(value);
		break;
	case CV_16S:
		this->__self->get()->at<short>(x) = static_cast<short>(value);
		break;
	case CV_32S:
		this->__self->get()->at<int>(x) = static_cast<int>(value);
		break;
	case CV_32F:
		this->__self->get()->at<float>(x) = static_cast<float>(value);
		break;
	case CV_64F:
		this->__self->get()->at<double>(x) = value;
		break;
	}
}

const double CCv_Mat_Object::at(int x, int y, HRESULT& hr) {
	switch (this->__self->get()->depth()) {
	case CV_8U:
		return this->__self->get()->at<uchar>(x, y);
	case CV_8S:
		return this->__self->get()->at<char>(x, y);
	case CV_16U:
		return this->__self->get()->at<ushort>(x, y);
	case CV_16S:
		return this->__self->get()->at<short>(x, y);
	case CV_32S:
		return this->__self->get()->at<int>(x, y);
	case CV_32F:
		return this->__self->get()->at<float>(x, y);
	case CV_64F:
		return this->__self->get()->at<double>(x, y);
	default:
		return 0;
	}
}

void CCv_Mat_Object::set_at(int x, int y, double value, HRESULT& hr) {
	switch (this->__self->get()->depth()) {
	case CV_8U:
		this->__self->get()->at<uchar>(x, y) = static_cast<uchar>(value);
		break;
	case CV_8S:
		this->__self->get()->at<char>(x, y) = static_cast<char>(value);
		break;
	case CV_16U:
		this->__self->get()->at<ushort>(x, y) = static_cast<ushort>(value);
		break;
	case CV_16S:
		this->__self->get()->at<short>(x, y) = static_cast<short>(value);
		break;
	case CV_32S:
		this->__self->get()->at<int>(x, y) = static_cast<int>(value);
		break;
	case CV_32F:
		this->__self->get()->at<float>(x, y) = static_cast<float>(value);
		break;
	case CV_64F:
		this->__self->get()->at<double>(x, y) = value;
		break;
	}
}

const double CCv_Mat_Object::at(Point& pt, HRESULT& hr) {
	switch (this->__self->get()->depth()) {
	case CV_8U:
		return this->__self->get()->at<uchar>(pt);
	case CV_8S:
		return this->__self->get()->at<char>(pt);
	case CV_16U:
		return this->__self->get()->at<ushort>(pt);
	case CV_16S:
		return this->__self->get()->at<short>(pt);
	case CV_32S:
		return this->__self->get()->at<int>(pt);
	case CV_32F:
		return this->__self->get()->at<float>(pt);
	case CV_64F:
		return this->__self->get()->at<double>(pt);
	default:
		return 0;
	}
}

void CCv_Mat_Object::set_at(Point& pt, double value, HRESULT& hr) {
	switch (this->__self->get()->depth()) {
	case CV_8U:
		this->__self->get()->at<uchar>(pt) = static_cast<uchar>(value);
		break;
	case CV_8S:
		this->__self->get()->at<char>(pt) = static_cast<char>(value);
		break;
	case CV_16U:
		this->__self->get()->at<ushort>(pt) = static_cast<ushort>(value);
		break;
	case CV_16S:
		this->__self->get()->at<short>(pt) = static_cast<short>(value);
		break;
	case CV_32S:
		this->__self->get()->at<int>(pt) = static_cast<int>(value);
		break;
	case CV_32F:
		this->__self->get()->at<float>(pt) = static_cast<float>(value);
		break;
	case CV_64F:
		this->__self->get()->at<double>(pt) = value;
		break;
	}
}

namespace Gdiplus {
	class BitmapLock {
	private:
		bool isOk = false;

	public:
		BitmapLock(
			Bitmap& bitmap,
			IN const Rect* rect,
			IN UINT flags,
			IN PixelFormat format
		) : bitmap_(bitmap) {
			CV_Assert(bitmap_.LockBits(rect, flags, format, &data) == Ok);
			isOk = true;
		}

		BitmapLock(
			Bitmap& bitmap,
			IN UINT flags,
			IN PixelFormat format
		) : BitmapLock(bitmap, &Gdiplus::Rect(0, 0, bitmap.GetWidth(), bitmap.GetHeight()), flags, format) {}

		BitmapLock(
			Bitmap& bitmap,
			IN UINT flags
		) : BitmapLock(bitmap, &Gdiplus::Rect(0, 0, bitmap.GetWidth(), bitmap.GetHeight()), flags, bitmap.GetPixelFormat()) {}

		~BitmapLock() {
			if (isOk) {
				CV_Assert(bitmap_.UnlockBits(&data) == Ok);
			}
		}

		Bitmap& bitmap_;
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
			CV_Assert(status == Ok);

			{
				// There is a bug in gdiplus.
				// When cloned size is the same as original size
				// a shallow copy is made,
				// keeping reference to the original data.
				// As a consquence, if the original data
				// is destroyed before the cloned data,
				// the cloned data now have an invalid memory.
				// BitmapLock(CvBitmap(gpdstBitmap), ImageLockModeRead);
			}

			return gpdstBitmap;
		}
	};
}

/**
 *
 * @param bitmap
 * @param mat
 * @param copy   use the same data when possible, otherwise, make a copy
 * @param hr
 * @see https://github.com/emgucv/emgucv/blob/4.5.4/Emgu.CV.Platform/Emgu.CV.Bitmap/BitmapExtension.cs#L300
 */
inline void createMatFromBitmap_(Gdiplus::Bitmap& bitmap, Mat& mat, bool copy, HRESULT& hr) {
	using namespace Gdiplus;

	auto width = bitmap.GetWidth();
	auto height = bitmap.GetHeight();
	auto format = bitmap.GetPixelFormat();

	Gdiplus::Rect rect(0, 0, width, height);

	BitmapLock lock(bitmap, &rect, ImageLockModeRead, format);
	BitmapData& data = lock.data;

	if (format == PixelFormat32bppARGB) {
		cv::Mat tmp(height, width, CV_8UC4, data.Scan0, data.Stride);
		if (copy) {
			tmp.copyTo(mat);
		}
		else {
			mat = tmp;
		}
	}
	else if (format == PixelFormat32bppRGB) {
		cv::Mat tmp(height, width, CV_8UC4, data.Scan0, data.Stride);
		mixChannels(tmp, mat, { 0, 0, 1, 1, 2, 2 });
	}
	else if (format == PixelFormat24bppRGB) {
		cv::Mat tmp(height, width, CV_8UC3, data.Scan0, data.Stride);
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

const Mat CCv_Object::createMatFromBitmap(void* ptr, bool copy, HRESULT& hr) {
	using namespace Gdiplus;

	auto nativeBitmap = static_cast<GpBitmap*>(ptr);

	// Attach nativeBitmap
	CvBitmap bitmap(nativeBitmap);
	CV_Assert(bitmap.GetLastStatus() == Ok);

	Mat mat; createMatFromBitmap_(bitmap, mat, copy, hr);

	// Detach nativeBitmap
	bitmap.Detach();

	return copy ? mat.clone() : Mat(mat);
}

/**
 *
 * @param src
 * @param dst
 * @see https://github.com/opencv/opencv/blob/4.5.4/modules/highgui/src/precomp.hpp#L152
 */
const Mat CCv_Mat_Object::convertToShow(Mat& dst, bool toRGB, HRESULT& hr) {
	auto& src = *this->__self->get();

	double scale = 1.0, shift = 0.0;
	double minVal = 0, maxVal = 0;
	cv::Point minLoc, maxLoc;

	const int src_depth = src.depth();
	CV_Assert(src_depth != CV_16F && src_depth != CV_32S);
	Mat tmp;
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

	return dst;
}

static Gdiplus::ColorPalette* GenerateGrayscalePalette() {
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

// static Gdiplus::ColorPalette* GrayscalePalette = GenerateGrayscalePalette();

static void RawDataToBitmap(uchar* scan0, size_t step, cv::Size size, int dstColorType, int channels, int srcDepth, Gdiplus::CvBitmap& dst) {
	using namespace Gdiplus;

	if (dstColorType == CV_8UC1 && srcDepth == CV_8U) {
		CvBitmap bmpGray(
			size.width,
			size.height,
			step,
			PixelFormat8bppIndexed,
			scan0
		);

		CV_Assert(bmpGray.GetLastStatus() == Ok);

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
		CV_Assert(bmp.GetLastStatus() == Ok);
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
		CV_Assert(bmp.GetLastStatus() == Ok);
		dst.Attach(bmp.Detach());
		return;
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
		RawDataToBitmap(m2.ptr(), m2.step1(), m2.size(), CV_8UC3, 3, srcDepth, dst);
		return;
	}

	CvBitmap bmp(size.width, size.height, format);
	CV_Assert(bmp.GetLastStatus() == Ok);

	{
		// Block to ensure unlocks before detach
		BitmapLock lock(bmp, &Gdiplus::Rect(0, 0, size.width, size.height), ImageLockModeWrite, format);
		BitmapData& data = lock.data;
		cv::Mat bmpMat(size.height, size.width, CV_MAKETYPE(CV_8U, channels), data.Scan0, data.Stride);
		Mat srcMat(size.height, size.width, CV_MAKETYPE(srcDepth, channels), scan0, step);

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

/**
 * [CCv_Mat_Object::convertToBitmap description]
 * @param copy   use the same data when possible, otherwise, make a copy
 * @param hr
 * @return   a pointer to a GpBitmap with Mat data copied
 * @see https://github.com/emgucv/emgucv/blob/4.5.4/Emgu.CV.Platform/Emgu.CV.Bitmap/BitmapExtension.cs#L206
 */
const void* CCv_Mat_Object::convertToBitmap(bool copy, HRESULT& hr) {
	using namespace Gdiplus;
	auto& src = *this->__self->get();

	if (src.dims > 3 || src.empty()) {
		return NULL;
	}

	auto channels = src.channels();
	int colorType = CV_MAKETYPE(CV_8U, channels);

	if (channels == 1) {
		if ((src.cols | 3) != 0) { //handle the special case where width is not a multiple of 4
			CvBitmap bitmap(src.cols, src.rows, PixelFormat8bppIndexed);
			CV_Assert(bitmap.GetLastStatus() == Ok);

			bitmap.SetPalette(GenerateGrayscalePalette());
			{
				// Block to ensure unlocks before detach
				BitmapLock lock(bitmap, &Gdiplus::Rect(0, 0, bitmap.GetWidth(), bitmap.GetHeight()), ImageLockModeWrite, PixelFormat8bppIndexed);
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
	RawDataToBitmap(src.ptr(), src.step1(), src.size(), colorType, channels, src.depth(), dst);
	return copy ? dst.CloneNativeImage() : dst.Detach();
}

const Mat CCv_Mat_Object::GdiplusResize(float newWidth, float newHeight, int interpolation, HRESULT& hr) {
	using namespace Gdiplus;

	GpBitmap* nativeBitmap = static_cast<GpBitmap*>(const_cast<void*>(convertToBitmap(true, hr)));
	CvBitmap bitmap(nativeBitmap);
	CV_Assert(bitmap.GetLastStatus() == Ok);

	CvBitmap hBitmap(static_cast<int>(newWidth), static_cast<int>(newHeight), bitmap.GetPixelFormat());
	CV_Assert(hBitmap.GetLastStatus() == Ok);

	Gdiplus::Graphics hBmpCtxt(&hBitmap);
	CV_Assert(hBmpCtxt.GetLastStatus() == Ok);

	CV_Assert(hBmpCtxt.SetInterpolationMode(static_cast<Gdiplus::InterpolationMode>(interpolation)) == Ok);
	CV_Assert(hBmpCtxt.DrawImage(&bitmap, 0.0, 0.0, newWidth, newHeight) == Ok);

	Mat mat; createMatFromBitmap_(hBitmap, mat, true, hr);

	return mat.clone();
}

const _variant_t CCv_Mat_Object::PixelSearch(cv::Scalar& color, int left, int top, int right, int bottom, uchar shade_variation, int step, HRESULT& hr) {
	auto& src = *this->__self->get();

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
					hr = autoit_opencv_from(Point(j, i), out_val);
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
					hr = autoit_opencv_from(Point(j, i), out_val);
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

const std::uint_fast32_t adler32(Mat& src, const int left, const int top, const int right, const int bottom, const int hstep, const int vstep) {
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

const std::uint_fast32_t crc32(Mat& src, const int left, const int top, const int right, const int bottom, const int hstep, const int vstep) {
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
	auto& src = *this->__self->get();

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
