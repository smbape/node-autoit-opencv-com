#include "impl_cv.h"

_variant_t cv::variant(void* ptr) {
	return _variant_t(static_cast<VARIANT*>(ptr));
}

const std::string cv::_format(const cv::InputArray& mtx, cv::Formatter::FormatType fmt) {
	std::string ouput;
	ouput << cv::format(mtx, fmt);
	return ouput;
}
