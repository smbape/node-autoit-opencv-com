#include "imgproc_extra.h"

using namespace cv;

template<typename T>
inline const bool common_searchPixel_(Mat& img,
	Mat& templ,
	int csz,
	const std::vector<int>& channels,
	const std::vector<float>& ranges,
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

				float diff = pimg[k] - ptempl[k];
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
	const std::vector<float>& ranges,
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

				float diff = pimg[k] - ptempl[k];
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
	const std::vector<float>& ranges,
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
	const std::vector<float>& ranges,
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

namespace {
	void common_searchTemplate(Mat& img,
		Mat& templ,
		Mat& result,
		int depth,
		const std::vector<int>& channels,
		const std::vector<float>& ranges,
		const bool parallel)
	{
		if (depth == CV_8U) {
			common_searchTemplate_<uchar>(img, templ, result, channels, ranges, parallel);
		}
		else {
			common_searchTemplate_<float>(img, templ, result, channels, ranges, parallel);
		}
	}

	void common_searchTemplateMask(Mat& img,
		Mat& templ,
		Mat& result,
		Mat& mask,
		int depth,
		const std::vector<int>& channels,
		const std::vector<float>& ranges,
		const bool parallel)
	{
		if (depth == CV_8U) {
			common_searchTemplateMask_<uchar>(img, templ, result, mask, channels, ranges, parallel);
		}
		else {
			common_searchTemplateMask_<float>(img, templ, result, mask, channels, ranges, parallel);
		}
	}

	void searchTemplateMask(InputArray _img,
		InputArray _templ,
		OutputArray _result,
		InputArray _mask,
		const std::vector<int>& channels,
		const std::vector<float>& ranges,
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
}

void cv::matchTemplateParallel(InputArray _img, InputArray _templ, OutputArray _result, int method, InputArray _mask)
{
	// parallel run only for Mat.
	// GpuMat and UMat will use the native matchTemplate func
	if (!_img.isMat() || !_templ.empty() && !_templ.isMat() || !_mask.empty() && !_mask.isMat()) {
		matchTemplate(_img, _templ, _result, method, _mask);
		return;
	}

	int type = _img.type(), depth = CV_MAT_DEPTH(type);
	CV_Assert(TemplateMatchModes::TM_SQDIFF <= method && method <= TemplateMatchModes::TM_CCOEFF_NORMED);
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
				width = r == numThreads - 1 ? img.cols - left : q + templ.cols - 1;
				top = 0;
				height = img.rows;
			}
			else {
				left = 0;
				width = img.cols;
				top = q * r;
				height = r == numThreads - 1 ? img.rows - top : q + templ.rows - 1;
			}

			Rect roi_img(left, top, width, height);
			Mat r_img(img, roi_img);

			Rect roi_result(left, top, width - templ.cols + 1, height - templ.rows + 1);

			if (_result.isUMat()) {
				UMat r_result(_result.getUMat(), roi_result);
				matchTemplate(r_img, templ, r_result, method, _mask);
			}
			else if (_result.isGpuMat()) {
				cuda::GpuMat r_result(_result.getGpuMat(), roi_result);
				matchTemplate(r_img, templ, r_result, method, _mask);
			}
			else {
				Mat r_result(result, roi_result);
				matchTemplate(r_img, templ, r_result, method, _mask);
			}
		}
		});
}

void cv::searchTemplate(InputArray _img,
	InputArray _templ,
	OutputArray _result,
	InputArray _mask,
	const std::vector<int>& _channels,
	const std::vector<float>& _ranges,
	const bool parallel) {

	int type = _img.type(), depth = CV_MAT_DEPTH(type), cn = CV_MAT_CN(type);
	CV_Assert((depth == CV_8U || depth == CV_32F) && type == _templ.type() && _img.dims() <= 2);
	CV_Assert(_img.size().height >= _templ.size().height && _img.size().width >= _templ.size().width);

	int csz = (int)_channels.size();
	CV_Assert(csz == 0 || csz <= cn && std::none_of(_channels.begin(), _channels.end(), [&](int channel) { return channel < 0 || channel >= cn; }));

	int rsz = (int)_ranges.size();
	CV_Assert(rsz == 0 || rsz == csz * 2);

	std::vector<int> def_channels(cn);
	std::vector<float> def_ranges(cn * 2);

	if (csz == 0) {
		for (int i = 0; i < cn; i++) {
			def_channels[i] = i;
		}
	}

	if (rsz == 0) {
		for (int i = 0; i < cn; i++) {
			def_ranges[i * 2] = 0;
			def_ranges[i * 2 + 1] = 0;
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

namespace {
	double compareHistImageTemplate(
		InputArray image,
		InputArray templ,
		InputArray mask,
		const std::vector<int>& channels,
		const std::vector<int>& histSize,
		const std::vector<float>& ranges,
		int method,
		bool accumulate) {

		// calcHist modifies the mask
		// avoid modifying empty masks
		// because it could be noArray()
		// making noArray() no longer an empty array
		_InputArray emptyMask;
		UMat emptyMask_UMat;
		cuda::GpuMat emptyMask_GpuMat;
		Mat emptyMask_Mat;

		if (image.isUMat()) {
			emptyMask = emptyMask_UMat;
		}
		else if (image.isGpuMat()) {
			emptyMask = emptyMask_GpuMat;
		}
		else {
			emptyMask = emptyMask_Mat;
		}

		// image images, hist
		_InputArray images;
		_InputOutputArray imageHist;

		std::vector<UMat> images_UMat;
		std::vector<cuda::GpuMat> images_GpuMat;
		std::vector<Mat> images_Mat;

		UMat imageHist_UMat;
		cuda::GpuMat imageHist_GpuMat;
		Mat imageHist_Mat;

		if (image.isUMat()) {
			imageHist = imageHist_UMat;
			images_UMat.push_back(image.getUMat());
			images = images_UMat;
		}
		else if (image.isGpuMat()) {
			imageHist = imageHist_GpuMat;
			images_GpuMat.push_back(image.getGpuMat());
			images = images_GpuMat;
		}
		else {
			imageHist = imageHist_Mat;
			images_Mat.push_back(image.getMat());
			images = images_Mat;
		}
		cv::calcHist(images, channels, mask.empty() ? emptyMask : mask, imageHist, histSize, ranges, accumulate);
		cv::normalize(imageHist, imageHist, 0, 1, cv::NORM_MINMAX);

		// templ images, hist
		_InputArray templs;
		_InputOutputArray templHist;

		std::vector<UMat> templs_UMat;
		std::vector<cuda::GpuMat> templs_GpuMat;
		std::vector<Mat> templs_Mat;

		UMat templHist_UMat;
		cuda::GpuMat templHist_GpuMat;
		Mat templHist_Mat;

		if (templ.isUMat()) {
			templHist = templHist_UMat;
			templs_UMat.push_back(templ.getUMat());
			templs = templs_UMat;
		}
		else if (templ.isGpuMat()) {
			templHist = templHist_GpuMat;
			templs_GpuMat.push_back(templ.getGpuMat());
			templs = templs_GpuMat;
		}
		else {
			templHist = templHist_Mat;
			templs_Mat.push_back(templ.getMat());
			templs = templs_Mat;
		}
		cv::calcHist(templs, channels, mask.empty() ? emptyMask : mask, templHist, histSize, ranges, accumulate);
		cv::normalize(templHist, templHist, 0, 1, cv::NORM_MINMAX);

		return cv::compareHist(imageHist, templHist, method);
	}
}

void cv::findTemplate(
	InputArray image,
	InputArray templ,
	std::vector<std::tuple<Point, double>>& results,
	double threshold,
	int methodMatch,
	InputArray mask,
	int limit,
	int code,
	float overlapping,
	std::vector<int> channels,
	std::vector<int> histSize,
	std::vector<float> ranges,
	int methodCompareHist,
	int dstCn,
	bool accumulate) {

	if (code >= 0) {
		// TODO : implement cvtColor with Mat/UMat respect
	}

	if (channels.empty()) {
		channels.resize(image.channels());
		for (int i = 0; i < image.channels(); i++) {
			channels[i] = i;
		}
	}

	if (histSize.empty()) {
		histSize.resize(image.channels());
		for (int i = 0; i < image.channels(); i++) {
			histSize[i] = methodMatch == -1 ? i : 32;
		}
	}

	if (ranges.empty()) {
		ranges.resize(image.channels() * 2);
		for (int i = 0; i < image.channels(); i++) {
			ranges[i * 2] = methodMatch == -1 ? -(1 - threshold) * 256 : 0;
			ranges[i * 2 + 1] = methodMatch == -1 ? -(1 - threshold) * 256 : 256;
		}
	}

	if (limit < 0) {
		limit = 0;
	}

	int width = image.cols();
	int height = image.rows();

	int w = templ.cols();
	int h = templ.rows();

	int rw = width - w + 1;
	int rh = height - h + 1;

	results.clear();

	if (rw <= 0 || rh <= 0) {
		return;
	}

	bool methodAcceptsMask = methodMatch == -1 || methodMatch == cv::TM_SQDIFF || methodMatch == cv::TM_CCORR_NORMED;

	_InputOutputArray result;
	UMat result_UMat;
	cuda::GpuMat result_GpuMat;
	Mat result_Mat;

	if (image.isUMat()) {
		result = result_UMat;
	}
	else if (image.isGpuMat()) {
		result = result_GpuMat;
	}
	else {
		result = result_Mat;
	}

	if (methodMatch == -1) {
		cv::searchTemplate(image, templ, result, methodAcceptsMask ? mask : noArray(), channels, ranges);
	}
	else if (width * height > 500 * 500) {
		cv::matchTemplateParallel(image, templ, result, methodMatch, methodAcceptsMask ? mask : noArray());
	}
	else {
		cv::matchTemplate(image, templ, result, methodMatch, methodAcceptsMask ? mask : noArray());
	}

	bool isNormed = methodMatch == -1 || methodMatch == cv::TM_SQDIFF_NORMED || methodMatch == cv::TM_CCORR_NORMED || methodMatch == cv::TM_CCOEFF_NORMED;
	if (!isNormed) {
		cv::normalize(result, result, 0, 1, cv::NORM_MINMAX);
	}

	// there are rh rows and rw cols in the result matrix
	// create a mask with the same number of rows and cols
	_InputArray resultMask;
	UMat resultMask_UMat;
	cuda::GpuMat resultMask_GpuMat;
	Mat resultMask_Mat;

	if (image.isUMat()) {
		resultMask_UMat = UMat::ones(rh, rw, CV_8UC1);
		resultMask = resultMask_UMat;
	}
	else if (image.isGpuMat()) {
		resultMask_GpuMat = cuda::GpuMat(rh, rw, CV_8UC1);
		resultMask_GpuMat.setTo(1.0);
		resultMask = resultMask_GpuMat;
	}
	else {
		resultMask_Mat = Mat::ones(rh, rw, CV_8UC1);
		resultMask = resultMask_Mat;
	}

	Rect matchRect(0, 0, w, h);
	double minVal, maxVal;
	Point minLoc, maxLoc;

	_InputOutputArray imageMatch;
	UMat imageMatch_UMat;
	cuda::GpuMat imageMatch_GpuMat;
	Mat imageMatch_Mat;
	bool compareHistAcceptMask = !mask.empty() && mask.channels() == 1;

	Point matchLoc;
	double histScore = 1;
	double score = 0;
	int found = 0;

	while (limit > 0) {
		limit--;

		cv::minMaxLoc(result, &minVal, &maxVal, &minLoc, &maxLoc, resultMask);

		// For SQDIFF and SQDIFF_NORMED, the best matches are lower values. For all the other methods, the higher the better
		if (methodMatch == cv::TM_SQDIFF || methodMatch == cv::TM_SQDIFF_NORMED) {
			matchLoc = minLoc;
			score = 1 - minVal;
		}
		else {
			matchLoc = maxLoc;
			score = maxVal;
		}

		if (!isNormed && found == 0) {
			matchRect.x = matchLoc.x;
			matchRect.y = matchLoc.y;

			if (image.isUMat()) {
				imageMatch_UMat = UMat(image.getUMat(), matchRect);
				imageMatch = imageMatch_UMat;
			}
			else if (image.isGpuMat()) {
				imageMatch_GpuMat = cuda::GpuMat(image.getGpuMat(), matchRect);
				imageMatch = imageMatch_GpuMat;
			}
			else {
				imageMatch_Mat = Mat(image.getMat(), matchRect);
				imageMatch = imageMatch_Mat;
			}

			histScore = compareHistImageTemplate(imageMatch, templ, compareHistAcceptMask ? mask : noArray(), channels, histSize, ranges, methodCompareHist, accumulate);
		}

		score *= histScore;

		if (score < threshold) {
			break;
		}

		results.push_back({ matchLoc, score });
		found++;

		auto tw = std::max(1, (int)std::ceil(overlapping * w));
		auto th = std::max(1, (int)std::ceil(overlapping * h));
		auto x = std::max(0, matchLoc.x - tw / 2);
		auto y = std::max(0, matchLoc.y - th / 2);

		// ensure that the template stays within the mask
		if (x + tw > rw) {
			tw = rw - x;
		}

		if (y + th > rh) {
			th = rh - y;
		}

		// mask the locations that should not be matched again
		Rect maskedRect(x, y, tw, th);

		if (image.isUMat()) {
			auto matMaskedRect = UMat(resultMask.getUMat(), maskedRect);
			matMaskedRect.setTo(0.0);
		}
		else if (image.isGpuMat()) {
			auto matMaskedRect = cuda::GpuMat(resultMask.getGpuMat(), maskedRect);
			matMaskedRect.setTo(0.0);
		}
		else {
			auto matMaskedRect = Mat(resultMask.getMat(), maskedRect);
			matMaskedRect.setTo(0.0);
		}
	}
}
