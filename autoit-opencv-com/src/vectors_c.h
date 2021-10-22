#pragma once

#include <vector>

template <class _Tp> 
void VectorPushMulti(std::vector<_Tp>* v, _Tp* values, size_t count) {
	if (count > 0) {
		size_t oldSize = v->size();
		v->resize(oldSize + count);
		memcpy(&(*v)[oldSize], values, count * sizeof(_Tp));
	}
}
