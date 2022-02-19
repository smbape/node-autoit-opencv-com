#include "imgproc_extra.h"

template<typename T>
inline const bool common_searchPixel_(Mat& img,
	Mat& templ,
	int csz,
	const std::vector<int>& channels,
	const std::vector<int>& ranges,
	int i, int j)
{

	for (int row = 0; row < templ.rows; row++) {
		for (int col = 0; col < templ.cols; col++) {
			for (int cn = 0; cn < csz; cn++) {
				int k = channels[cn];

				int low = ranges[cn * 2];
				int high = ranges[cn * 2 + 1];

				T* pimg = img.ptr<T>(row + i, col + j);
				T* ptempl = templ.ptr<T>(row, col);

				int diff = pimg[k] - ptempl[k];
				if (diff < low || diff > high) {
					return false;
				}
			}
		}
	}

	return true;
}

template<typename T>
inline const bool common_searchPixelMask_(Mat& img,
	Mat& templ,
	Mat& mask,
	int csz,
	const std::vector<int>& channels,
	const std::vector<int>& ranges,
	int i, int j)
{

	for (int row = 0; row < templ.rows; row++) {
		for (int col = 0; col < templ.cols; col++) {
			for (int cn = 0; cn < csz; cn++) {
				int k = channels[cn];
				float* pmask = mask.ptr<float>(row, col);
				if (pmask[k] != 0) {
					continue;
				}

				int low = ranges[cn * 2];
				int high = ranges[cn * 2 + 1];

				T* pimg = img.ptr<T>(row + i, col + j);
				T* ptempl = templ.ptr<T>(row, col);

				int diff = (int) pimg[k] - (int) ptempl[k];
				if (diff < low || diff > high) {
					return false;
				}
			}
		}
	}

	return true;
}

template<typename T>
inline void common_searchTemplate_(Mat& img,
	Mat& templ,
	Mat& result,
	const std::vector<int>& channels,
	const std::vector<int>& ranges,
	const bool parallel)
{

	int csz = channels.size();

	if (parallel) {
		// auto numThreads = getNumThreads();
		// bool isVSplit = result.cols >= result.rows;
		// int q = (isVSplit ? result.cols : result.rows) / numThreads;

		parallel_for_(Range(0, result.cols * result.rows), [&](const Range& range) {
			for (int r = range.start; r < range.end; r++) {
				// int left, width, top, height;

				// if (isVSplit) {
				// 	left = q * r;
				// 	width = r == numThreads - 1 ? img.cols - left : q + templ.cols;
				// 	top = 0;
				// 	height = img.rows;
				// }
				// else {
				// 	left = 0;
				// 	width = img.cols;
				// 	top = q * r;
				// 	height = r == numThreads - 1 ? img.rows - top : q + templ.rows;
				// }

				// for (int i = 0; i < height - templ.rows + 1; i++) {
				// 	for (int j = 0; j < width - templ.cols + 1; j++) {
				// 		bool has_match = common_searchPixel_<T>(img, templ, csz, channels, ranges, i + top, j + left);
				// 		if (has_match) {
				// 			result.at<float>(i, j) = 1.0;
				// 		}
				// 	}
				// }

				int i = r / result.cols;
				int j = r % result.cols;
				bool has_match = common_searchPixel_<T>(img, templ, csz, channels, ranges, i, j);
				if (has_match) {
					result.at<float>(i, j) = 1.0;
				}
			}
			});
		return;
	}

	for (int i = 0; i < result.rows; i++) {
		for (int j = 0; j < result.cols; j++) {
			bool has_match = common_searchPixel_<T>(img, templ, csz, channels, ranges, i, j);
			if (has_match) {
				result.at<float>(i, j) = 1.0;
			}
		}
	}
}

template<typename T>
inline void common_searchTemplateMask_(Mat& img,
	Mat& templ,
	Mat& result,
	Mat& mask,
	const std::vector<int>& channels,
	const std::vector<int>& ranges,
	const bool parallel)
{
	int csz = channels.size();

	if (parallel) {
		parallel_for_(Range(0, result.cols * result.rows), [&](const Range& range) {
			for (int r = range.start; r < range.end; r++) {
				int i = r / result.cols;
				int j = r % result.cols;
				bool has_match = common_searchPixelMask_<T>(img, templ, mask, csz, channels, ranges, i, j);
				if (has_match) {
					result.at<float>(i, j) = 1.0;
				}
			}
			});
		return;
	}

	for (int i = 0; i < result.rows; i++) {
		for (int j = 0; j < result.cols; j++) {
			bool has_match = common_searchPixelMask_<T>(img, templ, mask, csz, channels, ranges, i, j);
			if (has_match) {
				result.at<float>(i, j) = 1.0;
			}
		}
	}
}

static void common_searchTemplate(Mat& img,
	Mat& templ,
	Mat& result,
	int depth,
	const std::vector<int>& channels,
	const std::vector<int>& ranges,
	const bool parallel)
{
	if (depth == CV_8U) {
		common_searchTemplate_<uchar>(img, templ, result, channels, ranges, parallel);
	}
	else {
		common_searchTemplate_<float>(img, templ, result, channels, ranges, parallel);
	}
}

static void common_searchTemplateMask(Mat& img,
	Mat& templ,
	Mat& result,
	Mat& mask,
	int depth,
	const std::vector<int>& channels,
	const std::vector<int>& ranges,
	const bool parallel)
{
	if (depth == CV_8U) {
		common_searchTemplateMask_<uchar>(img, templ, result, mask, channels, ranges, parallel);
	}
	else {
		common_searchTemplateMask_<float>(img, templ, result, mask, channels, ranges, parallel);
	}
}

static void searchTemplateMask(InputArray _img,
	InputArray _templ,
	OutputArray _result,
	InputArray _mask,
	const std::vector<int>& channels,
	const std::vector<int>& ranges,
	const bool parallel)
{
	CV_Assert(_mask.depth() == CV_8U || _mask.depth() == CV_32F);
	CV_Assert(_mask.channels() == _templ.channels() || _mask.channels() == 1);
	CV_Assert(_templ.size() == _mask.size());

	Mat img = _img.getMat(), templ = _templ.getMat(), mask = _mask.getMat();

	if (mask.depth() == CV_8U)
	{
		// To keep compatibility to other masks in OpenCV: CV_8U masks are binary masks
		threshold(mask, mask, 0/*threshold*/, 1.0/*maxVal*/, THRESH_BINARY);
		mask.convertTo(mask, CV_32F);
	}

	Size corrSize(img.cols - templ.cols + 1, img.rows - templ.rows + 1);
	_result.create(corrSize, CV_32F);
	Mat result = _result.getMat();
	result.setTo(0);

	// If mask has only one channel, we repeat it for every image/template channel
	if (templ.channels() != mask.channels())
	{
		// Assertions above ensured, that depth is the same and only number of channel differ
		std::vector<Mat> maskChannels(templ.channels(), mask);
		merge(maskChannels.data(), templ.channels(), mask);
	}

	int type = _img.type(), depth = CV_MAT_DEPTH(type);
	common_searchTemplateMask(img, templ, result, mask, depth, channels, ranges, parallel);
}

void cv::matchTemplateParallel(InputArray _img, InputArray _templ, OutputArray _result, int method, InputArray _mask)
{
	// in case of OCL possibility, ignore parallel run
	if (_img.dims() <= 2 && _result.isUMat()) {
		cv::matchTemplate(_img, _templ, _result, method, _mask);
		return;
	}

	int type = _img.type(), depth = CV_MAT_DEPTH(type);
	CV_Assert(cv::TemplateMatchModes::TM_SQDIFF <= method && method <= cv::TemplateMatchModes::TM_CCOEFF_NORMED);
	CV_Assert((depth == CV_8U || depth == CV_32F) && type == _templ.type() && _img.dims() <= 2);

	bool needswap = !_mask.empty() && (_img.size().height < _templ.size().height || _img.size().width < _templ.size().width);

	if (needswap) {
		CV_Assert(_img.size().height <= _templ.size().height && _img.size().width <= _templ.size().width);
	}
	else {
		CV_Assert(_img.size().height >= _templ.size().height && _img.size().width >= _templ.size().width);
	}

	Mat img = _img.getMat(), templ = _templ.getMat();
	if (needswap) {
		std::swap(img, templ);
	}

	Size corrSize(img.cols - templ.cols + 1, img.rows - templ.rows + 1);
	_result.create(corrSize, CV_32F);
	Mat result = _result.getMat();

	auto numThreads = getNumThreads();
	bool isVSplit = corrSize.width >= corrSize.height;
	int q = (isVSplit ? corrSize.width : corrSize.height) / numThreads;

	parallel_for_(Range(0, numThreads), [&](const Range& range) {
		for (int r = range.start; r < range.end; r++) {
			int left, width, top, height;

			if (isVSplit) {
				left = q * r;
				width = r == numThreads - 1 ? img.cols - left : q + templ.cols;
				top = 0;
				height = img.rows;
			}
			else {
				left = 0;
				width = img.cols;
				top = q * r;
				height = r == numThreads - 1 ? img.rows - top : q + templ.rows;
			}

			Rect roi_img(left, top, width, height);
			Mat r_img(img, roi_img);

			Rect roi_result(left, top, width - templ.cols + 1, height - templ.rows + 1);
			Mat r_result(result, roi_result);

			matchTemplate(r_img, templ, r_result, method, _mask);
		}
		});
}

void cv::searchTemplate(InputArray _img,
	InputArray _templ,
	OutputArray _result,
	InputArray _mask,
	const std::vector<int>& _channels,
	const std::vector<int>& _ranges,
	const bool parallel) {

	int type = _img.type(), depth = CV_MAT_DEPTH(type), cn = CV_MAT_CN(type);
	CV_Assert((depth == CV_8U || depth == CV_32F) && type == _templ.type() && _img.dims() <= 2);
	CV_Assert(_img.size().height >= _templ.size().height && _img.size().width >= _templ.size().width);

	int rsz = (int)_ranges.size(), csz = (int)_channels.size();
	CV_Assert(csz == 0 || csz <= cn && std::none_of(_channels.begin(), _channels.end(), [&](int channel) { return channel < 0 || channel >= cn; }));
	CV_Assert(rsz == 0 || rsz == csz * 2);

	std::vector<int> def_channels(cn);
	std::vector<int> def_ranges(cn * 2);

	if (csz == 0) {
		for (int i = 0; i < cn; i++) {
			def_channels[i] = i;
			def_ranges[i * 2] = 0;
			def_ranges[i * 2 + 1] = 0;
		}
	}
	else {
		if (rsz == 0) {
			for (int i = 0; i < cn; i++) {
				def_ranges[i * 2] = 0;
				def_ranges[i * 2 + 1] = 0;
			}
		}
	}

	auto& channels = csz == 0 ? def_channels : _channels;
	auto& ranges = rsz == 0 ? def_ranges : _ranges;

	if (!_mask.empty())
	{
		searchTemplateMask(_img, _templ, _result, _mask, channels, ranges, parallel);
		return;
	}

	Mat img = _img.getMat(), templ = _templ.getMat();
	Size corrSize(img.cols - templ.cols + 1, img.rows - templ.rows + 1);
	_result.create(corrSize, CV_32F);
	Mat result = _result.getMat();
	result.setTo(0);

	common_searchTemplate(img, templ, result, depth, channels, ranges, parallel);
}
