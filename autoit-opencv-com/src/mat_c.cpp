#include "Cv_Mat_Object.h"

STDMETHODIMP CCv_Mat_Object::get_step(ULONGLONG* pVal) {
	*pVal = static_cast<ULONGLONG>(this->__self->get()->step);
	return S_OK;
}


int CCv_Mat_Object::int_at(int x) {
	return this->__self->get()->at<int>(x);
}

void CCv_Mat_Object::int_set_at(int x, int value) {
	this->__self->get()->at<int>(x) = value;
}

int CCv_Mat_Object::int_at(int x, int y) {
	return this->__self->get()->at<int>(x, y);
}

void CCv_Mat_Object::int_set_at(int x, int y, int value) {
	this->__self->get()->at<int>(x, y) = value;
}

int CCv_Mat_Object::int_at(Point pt) {
	return this->__self->get()->at<int>(pt);
}

void CCv_Mat_Object::int_set_at(Point pt, int value) {
	this->__self->get()->at<int>(pt) = value;
}


float CCv_Mat_Object::float_at(int x) {
	return this->__self->get()->at<float>(x);
}

void CCv_Mat_Object::float_set_at(int x, float value) {
	this->__self->get()->at<float>(x) = value;
}

float CCv_Mat_Object::float_at(int x, int y) {
	return this->__self->get()->at<float>(x, y);
}

void CCv_Mat_Object::float_set_at(int x, int y, float value) {
	this->__self->get()->at<float>(x, y) = value;
}

float CCv_Mat_Object::float_at(Point pt) {
	return this->__self->get()->at<float>(pt);
}

void CCv_Mat_Object::float_set_at(Point pt, float value) {
	this->__self->get()->at<float>(pt) = value;
}


double CCv_Mat_Object::double_at(int x) {
	return this->__self->get()->at<double>(x);
}

void CCv_Mat_Object::double_set_at(int x, double value) {
	this->__self->get()->at<double>(x) = value;
}

double CCv_Mat_Object::double_at(int x, int y) {
	return this->__self->get()->at<double>(x, y);
}

void CCv_Mat_Object::double_set_at(int x, int y, double value) {
	this->__self->get()->at<double>(x, y) = value;
}

double CCv_Mat_Object::double_at(Point pt) {
	return this->__self->get()->at<double>(pt);
}

void CCv_Mat_Object::double_set_at(Point pt, double value) {
	this->__self->get()->at<double>(pt) = value;
}
