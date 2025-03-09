#include "mat_extra.h"

namespace cvextra {
	std::vector<int> mat_shape(const cv::Mat& self) {
		const auto dims = self.size.dims();
		std::vector<int> shape(self.size.p, self.size.p + dims);
		const auto channels = self.channels();
		if (channels != 1) {
			shape.push_back(channels);
		}
		return shape;
	}

	std::vector<int> umat_shape(const cv::UMat& self) {
		const auto dims = self.size.dims();
		std::vector<int> shape(self.size.p, self.size.p + dims);
		const auto channels = self.channels();
		if (channels != 1) {
			shape.push_back(channels);
		}
		return shape;
	}
}
