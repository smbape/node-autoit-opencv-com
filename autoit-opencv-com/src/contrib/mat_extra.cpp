#include "mat_extra.h"

namespace {
	using namespace cv;

	template<typename _Tm>
	inline std::vector<int> _shape(const _Tm& self) {
		const auto& size = self.size;
		const auto layout = size.layout;
		auto shape = size.vec();
		if (layout != DATA_LAYOUT_NCHW && layout != DATA_LAYOUT_NHWC) {
			shape.push_back(self.channels());
		}
		return shape;
	}

}

namespace cvextra {
	std::vector<int> mat_shape(const cv::Mat& self) {
		return _shape(self);
	}

	std::vector<int> umat_shape(const cv::UMat& self) {
		return _shape(self);
	}
}
