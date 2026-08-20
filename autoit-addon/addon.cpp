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

#define STR_EQUAL(a, b) (strncmp(a, b, sizeof(b) - 1) == 0)
#define UNSUPPORTED_YOLO_VERSION "Unsupported yolo version. Supported versions are v3, v4, v5, v6, v7, v8."

void yolo_postprocess(
	const int spatial_width,
	const int spatial_height,
	const size_t num_labels,
	const int img_width,
	const int img_height,
	const float scale,
	const std::vector<cv::Mat>& outs,
	const float confThreshold,
	const float score_threshold,
	std::vector<int>& classIds,
	std::vector<float>& scores,
	std::vector<cv::Rect2d>& boxes
) {
	Mat classes_scores(1, 0, CV_32FC1);
	Point maxClassLoc;
	double maxScore;

	for (auto out : outs)
	{
		int offset;
		float box_scale_w, box_scale_h;

		if (out.dims != 2 && out.dims != 3) {
			CV_Error(cv::Error::StsAssert, UNSUPPORTED_YOLO_VERSION " out.dims != 2 && out.dims != 3");
		}

		if (out.dims == 2) {
			if (out.cols == num_labels + 5) {
				// yolo v3
				offset = 5;
			}
			else {
				CV_Error(cv::Error::StsAssert, UNSUPPORTED_YOLO_VERSION);
			}

			// relative coordinates
			box_scale_w = (float)img_width * scale;
			box_scale_h = (float)img_height * scale;
		}
		else {
			if (out.size[0] != 1) {
				CV_Error(cv::Error::StsAssert, UNSUPPORTED_YOLO_VERSION " out.size[0] != 1");
			}

			out = out.reshape(1, out.size[1]);
			box_scale_w = (float)img_width / spatial_width * scale;
			box_scale_h = (float)img_height / spatial_height * scale;

			// yolov5 has an output of shape (batchSize, 25200, 85) (Num classes + box[x,y,w,h] + confidence[c])
			// yolov8 has an output of shape (batchSize, 84,  8400) (Num classes + box[x,y,w,h])
			if (out.rows == num_labels + 4) {
				// yolo v8
				offset = 4;
				cv::transpose(out, out);
			}
			else if (out.cols == num_labels + 5) {
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

		float* detection = (float*)out.data;

		for (int i = 0; i < out.rows; ++i, detection += out.cols)
		{
			if (offset == 5 && detection[4] < confThreshold) {
				continue;
			}

			classes_scores.data = reinterpret_cast<uchar*>(detection + offset);

			// Get the value and location of the maximum score
			minMaxLoc(classes_scores, 0, &maxScore, 0, &maxClassLoc);

			if (maxScore >= score_threshold)
			{
				double centerX = (double)detection[0] * box_scale_w;
				double centerY = (double)detection[1] * box_scale_h;
				double width = (double)detection[2] * box_scale_w;
				double height = (double)detection[3] * box_scale_h;
				double left = centerX - width / 2;
				double top = centerY - height / 2;

				boxes.push_back(Rect2d(left, top, width, height));
				scores.push_back((float)maxScore);
				classIds.push_back(maxClassLoc.x);
			}
		}
	}
}

namespace {
	void object_detection_postprocess_yolo(
		const float box_scale_w,
		const float box_scale_h,
		const float confThreshold,
		const cv::Mat& out,
		cv::Mat& classes_scores,
		std::vector<int>& classIds,
		std::vector<float>& confidences,
		std::vector<cv::Rect2d>& boxes,
		const int background_label_id,
		const char* postprocessing
	)
	{
		int offset = STR_EQUAL(postprocessing, "yolov8") ? 4 : 5;
		classes_scores.cols = out.cols - offset;

		// Scan through all the bounding boxes output from the network and keep only the
		// ones with high confidence scores. Assign the box's class label as the class
		// with the highest score for the box.

		float* detection = (float*)out.data;

		for (int i = 0; i < out.rows; ++i, detection += out.cols)
		{
			float obj_conf = STR_EQUAL(postprocessing, "yolov8") ? 1 : detection[4];

			classes_scores.data = reinterpret_cast<uchar*>(detection + offset);

			// Get the value and location of the maximum score
			double confidence;
			Point maxClassLoc;
			minMaxLoc(classes_scores, 0, &confidence, 0, &maxClassLoc);
			if (confidence * obj_conf <= confThreshold) {
				continue;
			}

			double centerX = (double)detection[0] * box_scale_w;
			double centerY = (double)detection[1] * box_scale_h;
			double width = (double)detection[2] * box_scale_w;
			double height = (double)detection[3] * box_scale_h;
			double left = centerX - width / 2;
			double top = centerY - height / 2;

			classIds.push_back(maxClassLoc.x);
			confidences.push_back((float)confidence * obj_conf);
			boxes.push_back(Rect2d(left, top, width, height));
		}
	}
}

void object_detection_postprocess(
	const cv::dnn::Net& net,
	const int inpWidth,
	const int inpHeight,
	const float imgScale,
	const size_t num_labels,
	const int background_label_id,
	const float confThreshold,
	const std::vector<cv::Mat>& outs,
	const std::vector<std::string>& outBlobNames,
	std::vector<int>& classIds,
	std::vector<float>& confidences,
	std::vector<cv::Rect2d>& boxes,
	const char* postprocessing
)
{
	Mat classes_scores(1, 0, CV_32FC1);
	float box_scale_w, box_scale_h;

	if (STR_EQUAL(postprocessing, "ssd"))
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
				if (confidence <= confThreshold)
				{
					continue;
				}

				if (data[i + 5] - data[i + 3] < 1) {
					// relative coordinates
					box_scale_w = inpWidth * imgScale;
					box_scale_h = inpHeight * imgScale;
				}
				else {
					// absolute coordinate
					box_scale_w = imgScale;
					box_scale_h = imgScale;
				}

				double left = (double)data[i + 3] * box_scale_w;
				double top = (double)data[i + 4] * box_scale_h;
				double width = (double)data[i + 5] * box_scale_w - left + 1;
				double height = (double)data[i + 6] * box_scale_h - top + 1;

				int class_id = (int)(data[i + 1]);
				if (background_label_id >= 0 && background_label_id <= class_id) {
					class_id--; // Skip background label
				}
				classIds.push_back(class_id);
				confidences.push_back(confidence);
				boxes.push_back(Rect2d(left, top, width, height));
			}
		}
	}
	else if (STR_EQUAL(postprocessing, "yolov4") || STR_EQUAL(postprocessing, "yolov3"))
	{
		// relative coordinates
		box_scale_w = inpWidth * imgScale;
		box_scale_h = inpHeight * imgScale;

		// boxes[b,N,1,4]+confs[b,N,classes] (normalized) or boxes[b,N,4]+scores[b,N]+classIdx[b,N] (model-px)
		bool isBoxConfsFormat = (outs.size() == 2 && outs[0].dims == 4 && outs[0].size[outs[0].dims - 1] == 4);
		bool isBoxScoresIdxFormat = (outs.size() == 3 && outs[0].dims == 3 && outs[0].size[2] == 4);
		if (isBoxScoresIdxFormat)
		{
			size_t boxesIndex = 0;
			size_t scoresIndex = 1;
			size_t classIdxIndex = 2;
			for (size_t i = 0; i < outBlobNames.size(); i++) {
				const auto name = outBlobNames[i];
				if (name == "boxes") {
					boxesIndex = i;
				}
				else if (name == "scores") {
					scoresIndex = i;
				}
				else if (name == "class_idx") {
					classIdxIndex = i;
				}
				else {
					CV_Error(Error::StsNotImplemented, "Unsupported outLayerName: " + name);
				}
			}
			int N = outs[0].size[1];
			const float* boxesPtr = outs[boxesIndex].ptr<float>(0);
			const float* scoresPtr = outs[scoresIndex].ptr<float>(0);
			const float* classIdxPtr = outs[classIdxIndex].ptr<float>(0);
			for (int j = 0; j < N; ++j)
			{
				float score = scoresPtr[j];
				if (score > confThreshold)
				{
					float x1 = boxesPtr[j * 4 + 0] * imgScale;
					float y1 = boxesPtr[j * 4 + 1] * imgScale;
					float x2 = boxesPtr[j * 4 + 2] * imgScale;
					float y2 = boxesPtr[j * 4 + 3] * imgScale;
					boxes.push_back(Rect2d(x1, y1, (x2 - x1), (y2 - y1)));
					confidences.push_back(score);
					classIds.push_back((int)classIdxPtr[j]);
				}
			}
		}
		else if (isBoxConfsFormat)
		{
			Mat boxesMat = outs[0];
			Mat confsMat = outs[1];
			int numBoxes = (int)(boxesMat.total() / 4);
			boxesMat = boxesMat.reshape(1, numBoxes);
			confsMat = confsMat.reshape(1, numBoxes);
			for (int j = 0; j < numBoxes; ++j)
			{
				Point maxLoc;
				double confidence;
				minMaxLoc(confsMat.row(j), 0, &confidence, 0, &maxLoc);
				if (confidence > confThreshold)
				{
					const float* box = boxesMat.ptr<float>(j);
					boxes.push_back(Rect2d(box[0] * box_scale_w, box[1] * box_scale_h,
						(box[2] - box[0]) * box_scale_w, (box[3] - box[1]) * box_scale_h));
					confidences.push_back((float)confidence);
					classIds.push_back(maxLoc.x);
				}
			}
		}
		else
		{
			CV_Error(Error::StsNotImplemented, "Unsupported YOLO ONNX output format");
		}
	}
	else if (STR_EQUAL(postprocessing, "yolov8") || STR_EQUAL(postprocessing, "yolov7") || STR_EQUAL(postprocessing, "yolov6") || STR_EQUAL(postprocessing, "yolov5")) {
		for (auto out : outs)
		{
			float box_scale_w, box_scale_h;

			if (out.dims == 3) {
				if (out.size[0] != 1) {
					CV_Error(cv::Error::StsAssert, UNSUPPORTED_YOLO_VERSION " out.size[0] != 1");
				}

				out = out.reshape(1, out.size[1]);

				// absolute coordinate
				box_scale_w = imgScale;
				box_scale_h = imgScale;

				if (out.cols == num_labels + 5) {
					// yolo v5, v6, v7 has an output of shape (batchSize, 25200, 85) (Num classes + box[x,y,w,h] + confidence[c])
				}
				else if (out.rows == num_labels + 4) {
					// yolo v8 has an output of shape (batchSize, 84,  8400) (Num classes + box[x,y,w,h])
					cv::transpose(out, out);
				}
				else {
					CV_Error(cv::Error::StsAssert, UNSUPPORTED_YOLO_VERSION " out.rows != num_labels + 4 && out.cols != num_labels + 5");
				}
			}
			else {
				CV_Error(cv::Error::StsAssert, UNSUPPORTED_YOLO_VERSION " out.dims != 3");
			}

			object_detection_postprocess_yolo(
				box_scale_w,
				box_scale_h,
				confThreshold,
				out,
				classes_scores,
				classIds,
				confidences,
				boxes,
				background_label_id,
				postprocessing
			);
		}
	}
	else {
		CV_Error(Error::StsNotImplemented, "postprocessing method: " + std::string(postprocessing));
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
