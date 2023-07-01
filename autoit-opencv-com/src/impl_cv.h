#pragma once

#include <comutil.h>
#include <opencv2/core/mat.hpp>
#include <opencv2/core/operations.hpp>

namespace cv {
	CV_EXPORTS_W _variant_t variant(void* ptr);
	CV_EXPORTS_AS(format) const std::string _format(const cv::InputArray& mtx, cv::Formatter::FormatType fmt = cv::Formatter::FMT_NUMPY);
}
