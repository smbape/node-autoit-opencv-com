#pragma once

#include <iostream>
#include <opencv2/dnn/dnn.hpp>
#include <opencv2/features2d.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include "autoitdef.h"

AUTOITAPI(void) calcHist_Demo_draw(
	cv::Mat& histImage,
	int histSize,
	int hist_w,
	int hist_h,
	cv::Mat& b_hist,
	cv::Mat& g_hist,
	cv::Mat& r_hist
);

AUTOITAPI(void) AKAZE_match_ratio_test_filtering(
	std::vector<cv::KeyPoint>& matched1,
	std::vector<cv::KeyPoint>& kpts1,
	std::vector<cv::KeyPoint>& matched2,
	std::vector<cv::KeyPoint>& kpts2,
	std::vector<std::vector<cv::DMatch>>& nn_matches,
	const float nn_match_ratio
);

AUTOITAPI(void) AKAZE_homograpy_check(
	cv::Mat& homography,
	std::vector<cv::KeyPoint>& matched1,
	std::vector<cv::KeyPoint>& inliers1,
	std::vector<cv::KeyPoint>& matched2,
	std::vector<cv::KeyPoint>& inliers2,
	const float inlier_threshold,
	std::vector<cv::DMatch>& good_matches
);

AUTOITAPI(void) yolo_postprocess(
	const int spatial_width,
	const int spatial_height,
	const size_t num_classes,
	const int img_width,
	const int img_height,
	const float scale,
	const std::vector<cv::Mat>& outs,
	const float confidence_threshold,
	const float score_threshold,
	std::vector<int>& class_ids,
	std::vector<float>& scores,
	std::vector<cv::Rect2d>& bboxes
);

AUTOITAPI(void) object_detection_postprocess(
	const cv::dnn::Net& net,
	const int inpWidth,
	const int inpHeight,
	const float imgScale,
	const size_t num_classes,
	const float confidence_threshold,
	const float score_threshold,
	const std::vector<cv::Mat>& outs,
	std::vector<int>& class_ids,
	std::vector<float>& scores,
	std::vector<cv::Rect2d>& bboxes
);

AUTOITAPI(void) DllTestUMat();
