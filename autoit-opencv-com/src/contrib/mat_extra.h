#pragma once
#include <opencv2/core/mat.hpp>

// CV_EXPORTS_W : include this file in lua_generated_include

namespace cvextra {
    std::vector<int> mat_shape(const cv::Mat& self);
    std::vector<int> umat_shape(const cv::UMat& self);
}