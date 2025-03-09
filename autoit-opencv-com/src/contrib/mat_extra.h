#pragma once
#include <opencv2/core/mat.hpp>

// CV_EXPORTS_W : include this file in autoit_bridge_generated

namespace cvextra {
    std::vector<int> mat_shape(const cv::Mat& self);
    std::vector<int> umat_shape(const cv::UMat& self);
}