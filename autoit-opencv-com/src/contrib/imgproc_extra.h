#pragma once

#include <opencv2/imgproc.hpp>

namespace cv
{
	CV_EXPORTS_W void matchTemplateParallel(InputArray image, InputArray templ,
		OutputArray result, int method, InputArray mask = noArray());

	CV_EXPORTS_W void searchTemplate(InputArray image,
		InputArray templ,
		OutputArray result,
		InputArray mask = noArray(),
		const std::vector<int>& channels = std::vector<int>(),
		const std::vector<float>& ranges = std::vector<float>(),
		const bool parallel = false);

	CV_EXPORTS_W void findTemplate(
		InputArray image,
		InputArray templ,
		CV_OUT std::vector<std::tuple<Point, double>>& results,
		double threshold = 0.95,
		int methodMatch = cv::TM_CCOEFF_NORMED,
		InputArray mask = noArray(),
		int limit = 20,
		int code = -1,
		float overlapping = 2.0,
		std::vector<int> channels = std::vector<int>(),
		std::vector<int> histSize = std::vector<int>(),
		std::vector<float> ranges = std::vector<float>(),
		int methodCompareHist = cv::HISTCMP_CORREL,
		int dstCn = 0,
		bool accumulate = false);
}
