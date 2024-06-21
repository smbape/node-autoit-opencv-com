#pragma once
#include <opencv2/core.hpp>
#include <variant>

// CV_EXPORTS_W : include this file in lua_generated_include

namespace cv {
	CV_EXPORTS_W double randu();
	CV_EXPORTS_W void randu(int rows, int cols, InputOutputArray dst = Mat(), int type = CV_32F);
	CV_EXPORTS_W void randu(Size size, InputOutputArray dst = Mat(), int type = CV_32F);
	CV_EXPORTS_W void randu(const std::vector<int>& sizes, InputOutputArray dst = Mat(), int type = CV_32F);

	CV_EXPORTS_W double randn();
	CV_EXPORTS_W void randn(int rows, int cols, InputOutputArray dst = Mat(), int type = CV_32F);
	CV_EXPORTS_W void randn(Size size, InputOutputArray dst = Mat(), int type = CV_32F);
	CV_EXPORTS_W void randn(const std::vector<int>& sizes, InputOutputArray dst = Mat(), int type = CV_32F);

	CV_EXPORTS_W int argmax(InputArray src, bool lastIndex = false);
	CV_EXPORTS_W std::variant<std::shared_ptr<Mat>, int> argmax(InputArray src, int axis, bool lastIndex = false);

	CV_EXPORTS_W void bincount(InputArray x, OutputArray out, InputArray weights = noArray(), int minlength = 0);
	CV_EXPORTS_W void ravel(const cv::Mat& src, CV_OUT cv::Mat& out);
}
