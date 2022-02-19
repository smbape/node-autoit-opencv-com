#pragma once

#include <opencv2/core.hpp>

namespace cv
{
	CV_EXPORTS_W void matchTemplateParallel(InputArray image, InputArray templ,
		OutputArray result, int method, InputArray mask = noArray());

	CV_EXPORTS_W void searchTemplate( InputArray image,
								InputArray templ,
								OutputArray result,
								InputArray mask = noArray(),
								const std::vector<int>& channels = std::vector<int>(),
								const std::vector<int>& ranges = std::vector<int>(),
								const bool parallel = false);
}
