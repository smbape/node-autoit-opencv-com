#include "cv_extra.h"
#include <algorithm>

using byte = unsigned char;

namespace cv {
	double randu() {
		return cv::theRNG().gaussian(1.0);
	}

	void randu(int rows, int cols, cv::InputOutputArray dst, int type) {
		dst.create(rows, cols, type);
		cv::theRNG().fill(dst, cv::RNG::UNIFORM, 0, 1);
	}

	void randu(cv::Size size, cv::InputOutputArray dst, int type) {
		dst.create(size, type);
		cv::theRNG().fill(dst, cv::RNG::UNIFORM, 0, 1);
	}

	void randu(const std::vector<int>& sizes, cv::InputOutputArray dst, int type) {
		dst.create(sizes.size(), sizes.data(), type);
		cv::theRNG().fill(dst, cv::RNG::UNIFORM, 0, 1);
	}

	double randn() {
		return cv::theRNG().uniform(0.0, 1.0);
	}

	void randn(int rows, int cols, cv::InputOutputArray dst, int type) {
		dst.create(rows, cols, type);
		cv::theRNG().fill(dst, cv::RNG::NORMAL, 0, 1);
	}

	void randn(cv::Size size, cv::InputOutputArray dst, int type) {
		dst.create(size, type);
		cv::theRNG().fill(dst, cv::RNG::NORMAL, 0, 1);
	}

	void randn(const std::vector<int>& sizes, cv::InputOutputArray dst, int type) {
		dst.create(sizes.size(), sizes.data(), type);
		cv::theRNG().fill(dst, cv::RNG::NORMAL, 0, 1);
	}

	int argmax(InputArray _src, bool lastIndex) {
		const auto src = _src.getMat().reshape(_src.channels(), _src.total());
		Mat dst;
		cv::reduceArgMax(src, dst, 0, lastIndex);
		return dst.at<int>(0, 0);
	}

	std::variant<std::shared_ptr<Mat>, int> argmax(InputArray src, int axis, bool lastIndex) {
		const auto is1D = src.dims() == 1 || src.dims() == 2 && (src.rows() == 1 || src.cols() == 1);

		Mat dst;
		cv::reduceArgMax(src, dst, axis == 0 && is1D && src.dims() == 2 ? 1 : axis, lastIndex);

		if (is1D) {
			return dst.at<int>(0, 0);
		}

		return std::make_shared<cv::Mat>(dst);
	}

	void bincount(InputArray _x, OutputArray out, InputArray _weights, int minlength) {
		// minlength must not be negative
		CV_Assert(minlength >= 0);

		const Mat x = _x.getMat();

		// x must be 1-dimensional
		CV_Assert(x.dims <= 2 && x.channels() == 1 && x.depth() == CV_32S);
		CV_Assert(x.dims == 1 || x.rows == 1 || x.cols == 1);

		const Mat weights = _weights.getMat();
		if (!weights.empty()) {
			// weights must be 1-dimensional
			CV_Assert(weights.dims <= 2 && weights.channels() == 1);
			CV_Assert(weights.dims == 1 || weights.rows == 1 || weights.cols == 1);

			// x and weights must have the same size
			CV_Assert(x.total() == weights.total());
		}

		double min_x_val = 0, max_x_val = 0;
		minMaxLoc(x, &min_x_val, &max_x_val);

		// x must not contains elements with negative values
		CV_Assert(min_x_val >= 0);

		std::vector<double> bins(std::max((int)max_x_val + 1, minlength));
		const auto total = x.total();

		if (weights.empty()) {
			for (int i = 0; i < total; i++) {
				bins[x.at<int>(i)] += 1;
			}
		}
		else {
			for (int i = 0; i < total; i++) {
				switch (weights.depth()) {
				case CV_8U:
					bins[x.at<int>(i)] += weights.at<byte>(i);
					break;
				case CV_8S:
					bins[x.at<int>(i)] += weights.at<char>(i);
					break;
				case CV_16U:
					bins[x.at<int>(i)] += weights.at<ushort>(i);
					break;
				case CV_16S:
					bins[x.at<int>(i)] += weights.at<short>(i);
					break;
				case CV_32S:
					bins[x.at<int>(i)] += weights.at<int>(i);
					break;
				case CV_32F:
					bins[x.at<int>(i)] += weights.at<float>(i);
					break;
				case CV_64F:
					bins[x.at<int>(i)] += weights.at<double>(i);
					break;
				default:
					cv::error(cv::Error::StsAssert, "depth must be one of CV_8U CV_8S CV_16U CV_16S CV_32S CV_32F CV_64F", CV_Func, __FILE__, __LINE__);
				}
			}
		}

		Mat _bins(Size(bins.size(), 1), CV_64F, static_cast<void*>(const_cast<double*>(bins.data())));
		_bins.copyTo(out);
	}

	void ravel(const cv::Mat& src, cv::Mat& out) {
		if (src.isContinuous()) {
			out = src.reshape(src.channels(), src.total());
		} else {
			out = src.clone().reshape(src.channels(), src.total());
		}
	}
}
