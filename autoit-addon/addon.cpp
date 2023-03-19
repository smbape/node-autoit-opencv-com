#include "addon.h"

using namespace std;
using namespace cv;
using namespace cv::dnn;

void calcHist_Demo_draw(
	cv::Mat& histImage,
	int histSize,
	int hist_w,
	int hist_h,
	cv::Mat& b_hist,
	cv::Mat& g_hist,
	cv::Mat& r_hist
) {
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

void AKAZE_match_ratio_test_filtering(
	std::vector<cv::KeyPoint>& matched1,
	std::vector<cv::KeyPoint>& kpts1,
	std::vector<cv::KeyPoint>& matched2,
	std::vector<cv::KeyPoint>& kpts2,
	std::vector<std::vector<cv::DMatch>>& nn_matches,
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

void AKAZE_homograpy_check(
	Mat& homography,
	vector<cv::KeyPoint>& matched1,
	vector<cv::KeyPoint>& inliers1,
	vector<cv::KeyPoint>& matched2,
	vector<cv::KeyPoint>& inliers2,
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

void yolo_postprocess(
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
) {
	Mat classes_scores(1, 0, CV_32FC1);
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
			if (out.cols == num_classes + 5) {
				// yolo v3
				offset = 5;
			}
			else {
				CV_Error(cv::Error::StsAssert, UNSUPPORTED_YOLO_VERSION);
			}

			// relative coordinates
			scale_x = (float)img_width * scale;
			scale_y = (float)img_height * scale;
		}
		else {
			if (out.size[0] != 1) {
				CV_Error(cv::Error::StsAssert, UNSUPPORTED_YOLO_VERSION " out.size[0] != 1");
			}

			out = out.reshape(1, out.size[1]);
			scale_x = (float)img_width / spatial_width * scale;
			scale_y = (float)img_height / spatial_height * scale;

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
				double centerX = (double)data[0] * scale_x;
				double centerY = (double)data[1] * scale_y;
				double width = (double)data[2] * scale_x;
				double height = (double)data[3] * scale_y;
				double left = centerX - width / 2;
				double top = centerY - height / 2;

				bboxes.push_back(Rect2d(left, top, width, height));
				scores.push_back((float)maxScore);
				class_ids.push_back(maxClassLoc.x);
			}
		}
	}
}

void object_detection_postprocess(
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
)
{
	auto layerNames = net.getLayerNames();
	auto lastLayerId = net.getLayerId(layerNames.back());
	auto lastLayer = net.getLayer(lastLayerId);
	auto outLayerType = lastLayer->type;

	Mat classes_scores(1, 0, CV_32FC1);
	Point maxClassLoc;
	double maxScore;
	float scale_x, scale_y;

	if (outLayerType == "DetectionOutput")
	{
		// Network produces output blob with a shape 1x1xNx7 where N is a number of
		// detections and an every detection is a vector of values
		// [batchId, classId, confidence, left, top, right, bottom]
		CV_Assert(outs.size() > 0);
		for (auto out : outs)
		{
			const auto cols = out.size[3];
			const auto total = out.total();
			float* data = (float*)out.data;

			for (size_t i = 0; i < total; i += cols)
			{
				float confidence = data[i + 2];
				if (confidence <= confidence_threshold)
				{
					continue;
				}

				if (data[i + 5] - data[i + 3] < 1) {
					// relative coordinates
					scale_x = inpWidth * imgScale;
					scale_y = inpHeight * imgScale;
				}
				else {
					// absolute coordinate
					scale_x = imgScale;
					scale_y = imgScale;
				}

				double left = (double)data[i + 3] * scale_x;
				double top = (double)data[i + 4] * scale_y;
				double width = (double)data[i + 5] * scale_x - left + 1;
				double height = (double)data[i + 6] * scale_y - top + 1;

				class_ids.push_back((int)(data[i + 1]));
				bboxes.push_back(Rect2d(left, top, width, height));
				scores.push_back(confidence);
			}
		}
	}
	else if (outLayerType == "Region")
	{
		// relative coordinates
		scale_x = inpWidth * imgScale;
		scale_y = inpHeight * imgScale;

		// Network produces output blob with a shape NxC where N is a number of
		// detected objects and C is a number of classes + 4 where the first 4
		// numbers are [center_x, center_y, width, height]
		for (auto out : outs)
		{
			classes_scores.cols = out.cols - 5;
			float* data = (float*)out.data;

			for (int j = 0; j < out.rows; ++j, data += out.cols)
			{
				if (data[4] < confidence_threshold) {
					continue;
				}

				classes_scores.data = reinterpret_cast<uchar*>(data + 5);

				// Get the value and location of the maximum score
				minMaxLoc(classes_scores, 0, &maxScore, 0, &maxClassLoc);
				if (maxScore <= score_threshold) {
					continue;
				}

				double centerX = (double)data[0] * scale_x;
				double centerY = (double)data[1] * scale_y;
				double width = (double)data[2] * scale_x;
				double height = (double)data[3] * scale_y;
				double left = centerX - width / 2;
				double top = centerY - height / 2;

				bboxes.push_back(Rect2d(left, top, width, height));
				scores.push_back((float)maxScore);
				class_ids.push_back(maxClassLoc.x);
			}
		}
	}
	else if (outLayerType == "Identity") {
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

				// relative coordinates
				scale_x = inpWidth * imgScale;
				scale_y = inpHeight * imgScale;
			}
			else {
				if (out.size[0] != 1) {
					CV_Error(cv::Error::StsAssert, UNSUPPORTED_YOLO_VERSION " out.size[0] != 1");
				}

				out = out.reshape(1, out.size[1]);

				// absolute coordinate
				scale_x = imgScale;
				scale_y = imgScale;

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
					double centerX = (double)data[0] * scale_x;
					double centerY = (double)data[1] * scale_y;
					double width = (double)data[2] * scale_x;
					double height = (double)data[3] * scale_y;
					double left = centerX - width / 2;
					double top = centerY - height / 2;

					bboxes.push_back(Rect2d(left, top, width, height));
					scores.push_back((float)maxScore);
					class_ids.push_back(maxClassLoc.x);
				}
			}
		}
	}
	else {
		CV_Error(Error::StsNotImplemented, "Unknown output layer type: " + outLayerType);
	}
}

void DllTestUMat()
{
	cv::UMat mask(100, 100, CV_8UC1, cv::Scalar::all(0));
	cv::imshow("mask", mask);
	cv::waitKey();
	cv::destroyAllWindows();

	// https://stackoverflow.com/questions/63110817/how-to-ensure-that-gpu-memory-is-actually-deallocated-after-an-opencv-t-api-func
	// It seems that an allocation flushes the cleanup queue!
	auto const cleanupQueueFlusher = cv::UMat::zeros(1, 1, CV_8UC1);
}
