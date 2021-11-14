#include "Cv_Mat_Object.h"

Point2d CCv_Mat_Object::Point_at(int x) {
    switch(this->__self->get()->depth()) {
        case CV_8U:
            return Point2d(this->__self->get()->at<Vec2b>(x)[0], this->__self->get()->at<Vec2b>(x)[1]);
        case CV_8S:
            return Point2d(this->__self->get()->at<Vec<char, 2>>(x)[0], this->__self->get()->at<Vec<char, 2>>(x)[1]);
        case CV_16U:
            return Point2d(this->__self->get()->at<Vec2w>(x)[0], this->__self->get()->at<Vec2w>(x)[1]);
        case CV_16S:
            return Point2d(this->__self->get()->at<Vec2s>(x)[0], this->__self->get()->at<Vec2s>(x)[1]);
        case CV_32S:
            return Point2d(this->__self->get()->at<Vec2i>(x)[0], this->__self->get()->at<Vec2i>(x)[1]);
        case CV_32F:
            return Point2d(this->__self->get()->at<Vec2f>(x)[0], this->__self->get()->at<Vec2f>(x)[1]);
        case CV_64F:
            return Point2d(this->__self->get()->at<Vec2d>(x)[0], this->__self->get()->at<Vec2d>(x)[1]);
        default:
            return Point2d();
    }
}

Point2d CCv_Mat_Object::Point_at(int x, int y) {
    switch(this->__self->get()->depth()) {
        case CV_8U:
            return Point2d(this->__self->get()->at<Vec2b>(x, y)[0], this->__self->get()->at<Vec2b>(x, y)[1]);
        case CV_8S:
            return Point2d(this->__self->get()->at<Vec<char, 2>>(x, y)[0], this->__self->get()->at<Vec<char, 2>>(x, y)[1]);
        case CV_16U:
            return Point2d(this->__self->get()->at<Vec2w>(x, y)[0], this->__self->get()->at<Vec2w>(x, y)[1]);
        case CV_16S:
            return Point2d(this->__self->get()->at<Vec2s>(x, y)[0], this->__self->get()->at<Vec2s>(x, y)[1]);
        case CV_32S:
            return Point2d(this->__self->get()->at<Vec2i>(x, y)[0], this->__self->get()->at<Vec2i>(x, y)[1]);
        case CV_32F:
            return Point2d(this->__self->get()->at<Vec2f>(x, y)[0], this->__self->get()->at<Vec2f>(x, y)[1]);
        case CV_64F:
            return Point2d(this->__self->get()->at<Vec2d>(x, y)[0], this->__self->get()->at<Vec2d>(x, y)[1]);
        default:
            return Point2d();
    }
}

Point2d CCv_Mat_Object::Point_at(Point pt) {
    switch(this->__self->get()->depth()) {
        case CV_8U:
            return Point2d(this->__self->get()->at<Vec2b>(pt)[0], this->__self->get()->at<Vec2b>(pt)[1]);
        case CV_8S:
            return Point2d(this->__self->get()->at<Vec<char, 2>>(pt)[0], this->__self->get()->at<Vec<char, 2>>(pt)[1]);
        case CV_16U:
            return Point2d(this->__self->get()->at<Vec2w>(pt)[0], this->__self->get()->at<Vec2w>(pt)[1]);
        case CV_16S:
            return Point2d(this->__self->get()->at<Vec2s>(pt)[0], this->__self->get()->at<Vec2s>(pt)[1]);
        case CV_32S:
            return Point2d(this->__self->get()->at<Vec2i>(pt)[0], this->__self->get()->at<Vec2i>(pt)[1]);
        case CV_32F:
            return Point2d(this->__self->get()->at<Vec2f>(pt)[0], this->__self->get()->at<Vec2f>(pt)[1]);
        case CV_64F:
            return Point2d(this->__self->get()->at<Vec2d>(pt)[0], this->__self->get()->at<Vec2d>(pt)[1]);
        default:
            return Point2d();
    }
}

double CCv_Mat_Object::at(int x) {
    switch(this->__self->get()->depth()) {
        case CV_8U:
            return this->__self->get()->at<uchar>(x);
        case CV_8S:
            return this->__self->get()->at<char>(x);
        case CV_16U:
            return this->__self->get()->at<ushort>(x);
        case CV_16S:
            return this->__self->get()->at<short>(x);
        case CV_32S:
            return this->__self->get()->at<int>(x);
        case CV_32F:
            return this->__self->get()->at<float>(x);
        case CV_64F:
            return this->__self->get()->at<double>(x);
        default:
            return 0;
    }
}

void CCv_Mat_Object::set_at(int x, double value) {
    switch(this->__self->get()->depth()) {
        case CV_8U:
            this->__self->get()->at<uchar>(x) = static_cast<uchar>(value);
        case CV_8S:
            this->__self->get()->at<char>(x) = static_cast<char>(value);
        case CV_16U:
            this->__self->get()->at<ushort>(x) = static_cast<ushort>(value);
        case CV_16S:
            this->__self->get()->at<short>(x) = static_cast<short>(value);
        case CV_32S:
            this->__self->get()->at<int>(x) = static_cast<int>(value);
        case CV_32F:
            this->__self->get()->at<float>(x) = static_cast<float>(value);
        case CV_64F:
            this->__self->get()->at<double>(x) = value;
        default:
            return;
    }
}

double CCv_Mat_Object::at(int x, int y) {
    switch(this->__self->get()->depth()) {
        case CV_8U:
            return this->__self->get()->at<uchar>(x, y);
        case CV_8S:
            return this->__self->get()->at<char>(x, y);
        case CV_16U:
            return this->__self->get()->at<ushort>(x, y);
        case CV_16S:
            return this->__self->get()->at<short>(x, y);
        case CV_32S:
            return this->__self->get()->at<int>(x, y);
        case CV_32F:
            return this->__self->get()->at<float>(x, y);
        case CV_64F:
            return this->__self->get()->at<double>(x, y);
        default:
            return 0;
    }
}

void CCv_Mat_Object::set_at(int x, int y, double value) {
    switch(this->__self->get()->depth()) {
        case CV_8U:
            this->__self->get()->at<uchar>(x, y) = static_cast<uchar>(value);
        case CV_8S:
            this->__self->get()->at<char>(x, y) = static_cast<char>(value);
        case CV_16U:
            this->__self->get()->at<ushort>(x, y) = static_cast<ushort>(value);
        case CV_16S:
            this->__self->get()->at<short>(x, y) = static_cast<short>(value);
        case CV_32S:
            this->__self->get()->at<int>(x, y) = static_cast<int>(value);
        case CV_32F:
            this->__self->get()->at<float>(x, y) = static_cast<float>(value);
        case CV_64F:
            this->__self->get()->at<double>(x, y) = value;
        default:
            return;
    }
}

double CCv_Mat_Object::at(Point pt) {
    switch(this->__self->get()->depth()) {
        case CV_8U:
            return this->__self->get()->at<uchar>(pt);
        case CV_8S:
            return this->__self->get()->at<char>(pt);
        case CV_16U:
            return this->__self->get()->at<ushort>(pt);
        case CV_16S:
            return this->__self->get()->at<short>(pt);
        case CV_32S:
            return this->__self->get()->at<int>(pt);
        case CV_32F:
            return this->__self->get()->at<float>(pt);
        case CV_64F:
            return this->__self->get()->at<double>(pt);
        default:
            return 0;
    }
}

void CCv_Mat_Object::set_at(Point pt, double value) {
    switch(this->__self->get()->depth()) {
        case CV_8U:
            this->__self->get()->at<uchar>(pt) = static_cast<uchar>(value);
        case CV_8S:
            this->__self->get()->at<char>(pt) = static_cast<char>(value);
        case CV_16U:
            this->__self->get()->at<ushort>(pt) = static_cast<ushort>(value);
        case CV_16S:
            this->__self->get()->at<short>(pt) = static_cast<short>(value);
        case CV_32S:
            this->__self->get()->at<int>(pt) = static_cast<int>(value);
        case CV_32F:
            this->__self->get()->at<float>(pt) = static_cast<float>(value);
        case CV_64F:
            this->__self->get()->at<double>(pt) = value;
        default:
            return;
    }
}
