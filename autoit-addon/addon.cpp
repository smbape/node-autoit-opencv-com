#include <opencv2/features2d.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>
#include <iostream>
#include "autoitdef.h"

using namespace std;
using namespace cv;

AUTOITAPI(void) calcHist_Demo_draw(Mat &histImage, int histSize, int hist_w, int hist_h, Mat &b_hist, Mat &g_hist, Mat &r_hist) {
	int bin_w = cvRound((double)hist_w / histSize);

	//! [Draw for each channel]
	for (int i = 1; i < histSize; i++)
	{
		line( histImage, Point( bin_w*(i-1), hist_h - cvRound(b_hist.at<float>(i-1)) ),
			  Point( bin_w*(i), hist_h - cvRound(b_hist.at<float>(i)) ),
			  Scalar( 255, 0, 0), 2, 8, 0  );
		line( histImage, Point( bin_w*(i-1), hist_h - cvRound(g_hist.at<float>(i-1)) ),
			  Point( bin_w*(i), hist_h - cvRound(g_hist.at<float>(i)) ),
			  Scalar( 0, 255, 0), 2, 8, 0  );
		line( histImage, Point( bin_w*(i-1), hist_h - cvRound(r_hist.at<float>(i-1)) ),
			  Point( bin_w*(i), hist_h - cvRound(r_hist.at<float>(i)) ),
			  Scalar( 0, 0, 255), 2, 8, 0  );
	}
	//! [Draw for each channel]
}

AUTOITAPI(void) AKAZE_match_ratio_test_filtering(
	vector<KeyPoint> &matched1,
	vector<KeyPoint> &kpts1,
	vector<KeyPoint> &matched2,
	vector<KeyPoint> &kpts2,
	vector<vector<DMatch>> &nn_matches,
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
	Mat &homography,
	vector<KeyPoint> &matched1,
	vector<KeyPoint> &inliers1,
	vector<KeyPoint> &matched2,
	vector<KeyPoint> &inliers2,
	const float inlier_threshold,
	vector<DMatch> &good_matches
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

// Remove the bounding boxes with low confidence using non-maxima suppression
AUTOITAPI(void) yolo_postprocess(
	Mat& frame,
	const vector<Mat>& outs,
	const float confThreshold,
	const float nmsThreshold,
	vector<int>& classIds,
	vector<float>& confidences,
	vector<Rect2d>& boxes
) {
	for (size_t i = 0; i < outs.size(); ++i)
	{
		// Scan through all the bounding boxes output from the network and keep only the
		// ones with high confidence scores. Assign the box's class label as the class
		// with the highest score for the box.
		float* data = (float*)outs[i].data;
		for (int j = 0; j < outs[i].rows; ++j, data += outs[i].cols)
		{
			Mat scores = outs[i].row(j).colRange(5, outs[i].cols);
			Point classIdPoint;
			double confidence;
			// Get the value and location of the maximum score
			minMaxLoc(scores, 0, &confidence, 0, &classIdPoint);
			if (confidence > confThreshold)
			{
				int centerX = (int)(data[0] * frame.cols);
				int centerY = (int)(data[1] * frame.rows);
				int width = (int)(data[2] * frame.cols);
				int height = (int)(data[3] * frame.rows);
				int left = centerX - width / 2;
				int top = centerY - height / 2;

				classIds.push_back(classIdPoint.x);
				confidences.push_back((float)confidence);
				boxes.push_back(Rect2d(left, top, width, height));
			}
		}
	}
}
