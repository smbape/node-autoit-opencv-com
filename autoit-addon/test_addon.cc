#include "addon.h"

int main(int argc, char** argv)
{
	cv::Mat image = cv::Mat::zeros(500, 500, CV_8UC3);
	const double low = 0.0;
	const double high = 256.0;
	cv::imshow("before", image);
	cv::randu(image, low, high);
	cv::imshow("after", image);
	cv::waitKey();
	return EXIT_SUCCESS;
}
