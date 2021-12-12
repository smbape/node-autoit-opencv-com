#pragma once

#include "opencv2/core/mat.hpp"

namespace cv {
	CV_EXPORTS_W Mat createMatFromBitmap(void* ptr, bool copy = true);
}
