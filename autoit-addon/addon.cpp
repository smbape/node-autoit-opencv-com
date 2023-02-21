#include <opencv2/features2d.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>
#include <iostream>
#include "autoitdef.h"

using namespace std;
using namespace cv;

AUTOITAPI(void) calcHist_Demo_draw(Mat& histImage, int histSize, int hist_w, int hist_h, Mat& b_hist, Mat& g_hist, Mat& r_hist) {
	int bin_w = cvRound((double)hist_w / histSize);

	//! [Draw for each channel]
	for (int i = 1; i < histSize; i++)
	{
		line(histImage, Point(bin_w * (i - 1), hist_h - cvRound(b_hist.at<float>(i - 1))),
			Point(bin_w * (i), hist_h - cvRound(b_hist.at<float>(i))),
			Scalar(255, 0, 0), 2, 8, 0);
		line(histImage, Point(bin_w * (i - 1), hist_h - cvRound(g_hist.at<float>(i - 1))),
			Point(bin_w * (i), hist_h - cvRound(g_hist.at<float>(i))),
			Scalar(0, 255, 0), 2, 8, 0);
		line(histImage, Point(bin_w * (i - 1), hist_h - cvRound(r_hist.at<float>(i - 1))),
			Point(bin_w * (i), hist_h - cvRound(r_hist.at<float>(i))),
			Scalar(0, 0, 255), 2, 8, 0);
	}
	//! [Draw for each channel]
}

AUTOITAPI(void) AKAZE_match_ratio_test_filtering(
	vector<KeyPoint>& matched1,
	vector<KeyPoint>& kpts1,
	vector<KeyPoint>& matched2,
	vector<KeyPoint>& kpts2,
	vector<vector<DMatch>>& nn_matches,
	const float nn_match_ratio
) {
	//! [ratio test filtering]
	for (size_t i = 0; i < nn_matches.size(); i++) {
		DMatch first = nn_matches[i][0];
		float dist1 = nn_matches[i][0].distance;
		float dist2 = nn_matches[i][1].distance;

		if (dist1 < nn_match_ratio * dist2) {
			matched1.push_back(kpts1[first.queryIdx]);
			matched2.push_back(kpts2[first.trainIdx]);
		}
	}
	//! [ratio test filtering]
}

AUTOITAPI(void) AKAZE_homograpy_check(
	Mat& homography,
	vector<KeyPoint>& matched1,
	vector<KeyPoint>& inliers1,
	vector<KeyPoint>& matched2,
	vector<KeyPoint>& inliers2,
	const float inlier_threshold,
	vector<DMatch>& good_matches
) {
	for (size_t i = 0; i < matched1.size(); i++) {
		Mat col = Mat::ones(3, 1, CV_64F);
		col.at<double>(0) = matched1[i].pt.x;
		col.at<double>(1) = matched1[i].pt.y;

		col = homography * col;
		col /= col.at<double>(2);
		double dist = sqrt(pow(col.at<double>(0) - matched2[i].pt.x, 2) +
			pow(col.at<double>(1) - matched2[i].pt.y, 2));

		if (dist < inlier_threshold) {
			int new_i = static_cast<int>(inliers1.size());
			inliers1.push_back(matched1[i]);
			inliers2.push_back(matched2[i]);
			good_matches.push_back(DMatch(new_i, new_i, 0));
		}
	}
}

#define UNSUPPORTED_YOLO_VERSION "Unsupported yolo version. Supported versions are v3, v5, v8."

AUTOITAPI(void) yolo_postprocess(
	const int spatial_width,
	const int spatial_height,
	const size_t num_classes,
	Mat& image,
	const float scale,
	const vector<Mat>& outs,
	const float confidence_threshold,
	const float score_threshold,
	vector<int>& class_ids,
	vector<float>& scores,
	vector<Rect2d>& bboxes
) {
	cv::Mat classes_scores(1, 0, CV_32FC1);
	Point maxClassLoc;
	double maxScore;

	for (auto out : outs)
	{
		int offset;
		float scale_x, scale_y;

		if (out.dims != 2 && out.dims != 3) {
			CV_Error(cv::Error::StsAssert, UNSUPPORTED_YOLO_VERSION " out.dims != 2 && out.dims != 3");
		}

		if (out.dims == 2) {
			// yolo v3
			offset = 5;
			scale_x = (float)image.cols;
			scale_y = (float)image.rows;
		}
		else {
			if (out.size[0] != 1) {
				CV_Error(cv::Error::StsAssert, UNSUPPORTED_YOLO_VERSION " out.size[0] != 1");
			}

			out = out.reshape(1, out.size[1]);
			scale_x = (float)image.cols / spatial_width;
			scale_y = (float)image.rows / spatial_height;

			// yolov5 has an output of shape (batchSize, 25200, 85) (Num classes + box[x,y,w,h] + confidence[c])
			// yolov8 has an output of shape (batchSize, 84,  8400) (Num classes + box[x,y,w,h])
			if (out.rows == num_classes + 4) {
				// yolo v8
				offset = 4;
				cv::transpose(out, out);
			}
			else if (out.cols == num_classes + 5) {
				// yolo v5
				offset = 5;
			}
			else {
				CV_Error(cv::Error::StsAssert, UNSUPPORTED_YOLO_VERSION);
			}
		}

		classes_scores.cols = out.cols - offset;

		// Scan through all the bounding boxes output from the network and keep only the
		// ones with high confidence scores. Assign the box's class label as the class
		// with the highest score for the box.

		float* data = (float*)out.data;

		for (int i = 0; i < out.rows; ++i, data += out.cols)
		{
			if (offset == 5 && data[4] < confidence_threshold) {
				continue;
			}

			classes_scores.data = reinterpret_cast<uchar*>(data + offset);

			// Get the value and location of the maximum score
			minMaxLoc(classes_scores, 0, &maxScore, 0, &maxClassLoc);

			if (maxScore >= score_threshold)
			{
				double centerX = (double)data[0] * scale_x * scale;
				double centerY = (double)data[1] * scale_y * scale;
				double width = (double)data[2] * scale_x * scale;
				double height = (double)data[3] * scale_y * scale;
				double left = centerX - width / 2;
				double top = centerY - height / 2;

				bboxes.push_back(Rect2d(left, top, width, height));
				scores.push_back((float)maxScore);
				class_ids.push_back(maxClassLoc.x);
			}
		}
	}

}
