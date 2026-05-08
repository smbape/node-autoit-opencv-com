#include "autoit_bridge_common.h"

// ================================
// T if std::is_enum_v<T>
// ================================

template<typename T>
inline std::enable_if_t<std::is_enum_v<T>, const bool> is_assignable_from(T& out_val, VARIANT const* in_val, bool is_optional) {
	int value = 0;
	return is_assignable_from(value, in_val, is_optional);
}

template<typename T>
inline std::enable_if_t<std::is_enum_v<T>, const HRESULT> autoit_to(VARIANT const* in_val, T& out_val) {
	if (PARAMETER_MISSING(in_val)) {
		return S_OK;
	}
	int value = 0;
	HRESULT hr = autoit_to(in_val, value);
	if (SUCCEEDED(hr)) {
		out_val = static_cast<T>(value);
	}
	return hr;
}

template<typename T>
inline std::enable_if_t<std::is_enum_v<T>, const HRESULT> autoit_from(T const& in_val, VARIANT*& out_val) {
	return autoit_from(static_cast<int>(in_val), out_val);
}

// ================================

// ================================
// std::optional
// ================================

template<typename T>
const bool is_assignable_from(std::optional<T>& out_val, VARIANT const* in_val, bool is_optional) {
	if (V_VT(in_val) == VT_NULL) {
		return S_OK;
	}

	T value;
	return is_assignable_from(value, in_val, true);
}

template<typename T>
const HRESULT autoit_to(VARIANT const* in_val, std::optional<T>& out_val) {
	if (V_VT(in_val) == VT_NULL) {
		out_val.reset();
		return S_OK;
	}

	if (PARAMETER_MISSING(in_val)) {
		return S_OK;
	}

	return autoit_to(in_val, out_val.emplace());
}

template<typename T>
const HRESULT autoit_from(std::optional<T> const& in_val, VARIANT*& out_val) {
	if (in_val.has_value()) {
		return autoit_from(in_val.value(), out_val);
	}

	VariantClear(out_val);
	VariantInit(out_val);
	V_VT(out_val) = VT_ERROR;
	V_ERROR(out_val) = DISP_E_PARAMNOTFOUND;

	return S_OK;
}

template<typename T>
const HRESULT autoit_out(std::optional<T>& out_val, VARIANT* const retval) {
	if (out_val.has_value()) {
		return autoit_out(out_val.value(), retval);
	}

	VariantClear(retval);
	VariantInit(retval);
	V_VT(retval) = VT_ERROR;
	V_ERROR(retval) = DISP_E_PARAMNOTFOUND;

	return S_OK;
}

// ================================

// ================================
// std::pair
// ================================

template<typename T1, typename T2>
const bool is_assignable_from(std::pair<T1, T2>& out_val, VARIANT const* in_val, bool is_optional) {
	if (PARAMETER_MISSING(in_val)) {
		return is_optional;
	}

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return false;
	}

	typename ATL::template CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(in_val));

	if (vArray.GetCount() != 2) {
		vArray.Detach();
		return false;
	}

	auto& vfirst = vArray.GetAt(0);
	auto* pvfirst = &vfirst;

	auto& vsecond = vArray.GetAt(1);
	auto* pvsecond = &vsecond;

	HRESULT hr = is_assignable_from(out_val.first, pvfirst, false);

	if (SUCCEEDED(hr)) {
		hr = is_assignable_from(out_val.second, pvsecond, false);
	}

	vArray.Detach();

	return hr;
}

template<typename T1, typename T2>
HRESULT autoit_to(VARIANT const* in_val, std::pair<T1, T2>& out_val) {
	if (PARAMETER_MISSING(in_val)) {
		return S_OK;
	}

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return E_INVALIDARG;
	}

	typename ATL::template CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(in_val));

	if (vArray.GetCount() != 2) {
		vArray.Detach();
		return E_INVALIDARG;
	}

	auto& vfirst = vArray.GetAt(0);
	auto* pvfirst = &vfirst;

	auto& vsecond = vArray.GetAt(1);
	auto* pvsecond = &vsecond;

	HRESULT hr = is_assignable_from(out_val.first, pvfirst, false);

	if (SUCCEEDED(hr)) {
		hr = is_assignable_from(out_val.second, pvsecond, false);
	}

	if (SUCCEEDED(hr)) {
		hr = autoit_to(pvfirst, out_val.first);
	}

	if (SUCCEEDED(hr)) {
		hr = autoit_to(pvsecond, out_val.second);
	}

	vArray.Detach();
	return hr;
}

template<typename T1, typename T2>
const HRESULT autoit_from(std::pair<T1, T2> const& in_val, VARIANT*& out_val) {
	typename ATL::template CComSafeArray<VARIANT> vArray(2);

	HRESULT hr;

	VARIANT value;
	VariantInit(&value);
	auto* pvalue = &value;

	hr = autoit_from(in_val.first, pvalue);
	if (SUCCEEDED(hr)) {
		AUTOIT_ASSERT_THROW(SUCCEEDED(vArray.SetAt(0, value)), "Failed to set value a index " << 0);

		VariantClear(&value);
		hr = autoit_from(in_val.second, pvalue);
		if (SUCCEEDED(hr)) {
			AUTOIT_ASSERT_THROW(SUCCEEDED(vArray.SetAt(1, value)), "Failed to set value a index " << 1);
		}
	}

	VariantClear(&value);

	VariantClear(out_val);
	VariantInit(out_val);
	V_VT(out_val) = VT_ARRAY | VT_VARIANT;
	V_ARRAY(out_val) = vArray.Detach();
	return S_OK;
}

// ================================

// ================================
// std::tuple
// ================================

template<typename ... Types>
const bool is_assignable_from(std::tuple <Types...>& out_val, VARIANT const* in_val, bool is_optional) {
	if (PARAMETER_MISSING(in_val)) {
		return is_optional;
	}

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return false;
	}

	std::tuple<Types...> dummy;
	return SUCCEEDED(autoit_to(in_val, dummy));
}

template<std::size_t I, typename... Types>
const HRESULT _autoit_to(VARIANT const* in_val, std::tuple<Types...>& out_val) {
	typename ATL::template CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(in_val));
	auto& v = vArray.GetAt(I);
	auto* pv = &v;

	using _Tuple = typename std::tuple<Types...>;
	using _Type = typename std::tuple_element<I, _Tuple>::type;
	_Type value;

	HRESULT hr = is_assignable_from(value, pv, false);

	if (SUCCEEDED(hr)) {
		hr = autoit_to(pv, value);
	}

	if (SUCCEEDED(hr)) {
		std::get<I>(out_val) = value;
	}

	vArray.Detach();
	return hr;
}

template<std::size_t I, typename... Types>
typename std::enable_if<I == sizeof...(Types) - 1, const HRESULT>::type
autoit_to(VARIANT const* in_val, std::tuple<Types...>& out_val) {
	if (PARAMETER_MISSING(in_val)) {
		return S_OK;
	}

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return E_INVALIDARG;
	}

	typename ATL::template CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(in_val));
	LONG lLower = vArray.GetLowerBound();
	LONG lUpper = vArray.GetUpperBound();
	vArray.Detach();

	if (lUpper - lLower + 1 < I) {
		return E_INVALIDARG;
	}

	return _autoit_to<I, Types...>(in_val, out_val);
}

template<std::size_t I, typename... Types>
typename std::enable_if<I != sizeof...(Types) - 1, const HRESULT>::type
autoit_to(VARIANT const* in_val, std::tuple<Types...>& out_val) {
	if (PARAMETER_MISSING(in_val)) {
		return S_OK;
	}

	HRESULT hr = autoit_to<I + 1, Types...>(in_val, out_val);
	if (FAILED(hr)) {
		return hr;
	}

	return _autoit_to<I, Types...>(in_val, out_val);
}

template<std::size_t I, typename... Types>
typename std::enable_if<I == sizeof...(Types), const HRESULT>::type
autoit_from(std::tuple<Types...> const& in_val, VARIANT*& out_val) {
	V_VT(out_val) = VT_ARRAY | VT_VARIANT;
	typename ATL::template CComSafeArray<VARIANT> vArray((ULONG)I);
	V_ARRAY(out_val) = vArray.Detach();
	return S_OK;
}

template<std::size_t I, typename... Types>
typename std::enable_if<I != sizeof...(Types), const HRESULT>::type
autoit_from(std::tuple<Types...> const& in_val, VARIANT*& out_val) {
	HRESULT hr = autoit_from<I + 1, Types...>(in_val, out_val);
	if (FAILED(hr)) {
		return hr;
	}

	typename ATL::template CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(out_val));

	VARIANT value = { VT_EMPTY };
	auto* pvalue = &value;
	hr = autoit_from(std::get<I>(in_val), pvalue);

	if (SUCCEEDED(hr)) {
		AUTOIT_ASSERT_THROW(SUCCEEDED(vArray.SetAt(I, value)), "Failed to set value a index " << I);
	}

	VariantClear(&value);

	vArray.Detach();
	return hr;
}

// ================================

// ================================
// std::variant
// ================================

template<std::size_t I = 0, typename... Types>
const bool _is_assignable_from(std::variant<Types...>& out_val, VARIANT const* in_val, bool is_optional) {
	using _Tuple = typename std::tuple<Types...>;
	using T = typename std::tuple_element<I, _Tuple>::type;

	if constexpr (!std::is_same_v<std::monostate, T>) {
		T value;
		if (is_assignable_from(value, in_val, is_optional)) {
			return true;
		}
	}

	if constexpr (I == sizeof...(Types) - 1) {
		return false;
	}
	else {
		return _is_assignable_from<I + 1, Types...>(out_val, in_val, is_optional);
	}
}

template<typename... Types>
const bool is_assignable_from(std::variant<Types...>& out_val, VARIANT const* in_val, bool is_optional) {
	return _is_assignable_from(out_val, in_val, is_optional);
}

template<std::size_t I = 0, typename... Types>
const HRESULT _autoit_to(VARIANT const* in_val, std::variant<Types...>& out_val) {
	using _Tuple = typename std::tuple<Types...>;
	using T = typename std::tuple_element<I, _Tuple>::type;

	if constexpr (!std::is_same_v<std::monostate, T>) {
		T value;
		auto hr = autoit_to(in_val, value);
		if (SUCCEEDED(hr)) {
			out_val = value;
			return hr;
		}
	}

	if constexpr (I == sizeof...(Types) - 1) {
		return E_INVALIDARG;
	}
	else {
		return _autoit_to<I + 1, Types...>(in_val, out_val);
	}
}

template<typename... Types>
const HRESULT autoit_to(VARIANT const* in_val, std::variant<Types...>& out_val) {
	return _autoit_to(in_val, out_val);
}

template<std::size_t I = 0, typename... Types>
const HRESULT _autoit_from(std::variant<Types...> const& in_val, VARIANT*& out_val) {
	using _Tuple = typename std::tuple<Types...>;
	using T = typename std::tuple_element<I, _Tuple>::type;

	if constexpr (!std::is_same_v<std::monostate, T>) {
		if (std::holds_alternative<T>(in_val)) {
			return autoit_from(std::get<T>(in_val), out_val);
		}
	}

	if constexpr (I == sizeof...(Types) - 1) {
		return E_INVALIDARG;
	}
	else {
		return _autoit_from<I + 1, Types...>(in_val, out_val);
	}
}

template<typename... Types>
const HRESULT autoit_from(std::variant<Types...> const& in_val, VARIANT*& out_val) {
	return _autoit_from(in_val, out_val);
}

// ================================

// ================================
// std::vector
// ================================

template<class T, class Allocator>
const bool is_assignable_from(std::vector<T, Allocator>& out_val, VARIANT const* in_val, bool is_optional) {
	if (PARAMETER_MISSING(in_val)) {
		return is_optional;
	}

	if (V_VT(in_val) == VT_DISPATCH) {
		return dynamic_cast<TypeToImplType<std::vector<T, Allocator>>::type*>(getRealIDispatch(in_val)) != NULL;
	}

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return false;
	}

	HRESULT hr = S_OK;
	typename ATL::template CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(in_val));

	LONG lLower = vArray.GetLowerBound();
	LONG lUpper = vArray.GetUpperBound();

	T value;

	for (LONG i = lLower; i <= lUpper; i++) {
		auto& v = vArray.GetAt(i);
		VARIANT* pv = &v;
		if (!is_assignable_from(value, pv, false)) {
			hr = E_INVALIDARG;
			break;
		}
	}

	vArray.Detach();

	return SUCCEEDED(hr);
}

template<class T, class Allocator>
const bool is_assignable_from(AUTOIT_PTR<std::vector<T, Allocator>>& out_val, VARIANT const* in_val, bool is_optional) {
	static std::vector<T, Allocator> tmp;
	return is_assignable_from(tmp, in_val, is_optional);
}

template<class T, class Allocator>
const HRESULT autoit_to(VARIANT const* in_val, std::vector<T, Allocator>& out_val) {
	if (PARAMETER_MISSING(in_val)) {
		return S_OK;
	}

	if (V_VT(in_val) == VT_DISPATCH) {
		const auto& obj = dynamic_cast<TypeToImplType<std::vector<T, Allocator>>::type*>(getRealIDispatch(in_val));
		if (!obj) {
			return E_INVALIDARG;
		}
		out_val = *obj->__self->get();
		return S_OK;
	}

	if ((V_VT(in_val) & VT_ARRAY) != VT_ARRAY || (V_VT(in_val) ^ VT_ARRAY) != VT_VARIANT) {
		return E_INVALIDARG;
	}

	HRESULT hr = S_OK;
	typename ATL::template CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(in_val));

	LONG lLower = vArray.GetLowerBound();
	LONG lUpper = vArray.GetUpperBound();

	out_val.resize(lUpper - lLower + 1);
	T value;

	for (LONG i = lLower; i <= lUpper; i++) {
		auto& v = vArray.GetAt(i);
		VARIANT* pv = &v;

		if (!is_assignable_from(value, pv, false)) {
			hr = E_INVALIDARG;
			break;
		}

		hr = autoit_to(pv, value);
		if (FAILED(hr)) {
			break;
		}

		out_val[i - lLower] = value;
	}

	vArray.Detach();
	return hr;
}

template<class T, class Allocator>
const HRESULT autoit_to(VARIANT const* in_val, AUTOIT_PTR<std::vector<T, Allocator>>& out_val) {
	out_val = AUTOIT_MAKE_PTR<std::vector<T, Allocator>>();
	return autoit_to(in_val, *out_val.get());
}

template<class T, class Allocator>
const HRESULT autoit_from(AUTOIT_PTR<std::vector<T, Allocator>> const& in_val, VARIANT*& out_val) {
	return autoit_from(*in_val.get(), out_val);
}

template<class T, class Allocator>
const HRESULT autoit_from(std::vector<T, Allocator> const& in_val, VARIANT*& out_val) {
	if (PARAMETER_NULL(out_val) || PARAMETER_NOT_FOUND(out_val)) {
		V_VT(out_val) = VT_ARRAY | VT_VARIANT;
		typename ATL::template CComSafeArray<VARIANT> vArray((ULONG)0);
		V_ARRAY(out_val) = vArray.Detach();
	}

	if ((V_VT(out_val) & VT_ARRAY) != VT_ARRAY || (V_VT(out_val) ^ VT_ARRAY) != VT_VARIANT) {
		return E_INVALIDARG;
	}

	HRESULT hr = S_OK;
	typename ATL::template CComSafeArray<VARIANT> vArray;
	vArray.Attach(V_ARRAY(out_val));

#pragma warning( push )
#pragma warning( disable : 4267)
	vArray.Resize(in_val.size());
#pragma warning( pop )

	for (LONG i = 0; SUCCEEDED(hr) && i < in_val.size(); i++) {
		VARIANT value = { VT_EMPTY };
		auto* pvalue = &value;
		hr = autoit_from(in_val[i], pvalue);

		if (SUCCEEDED(hr)) {
			AUTOIT_ASSERT_THROW(SUCCEEDED(vArray.SetAt(i, value)), "Failed to set value a index " << i);
		}

		VariantClear(&value);
	}

	vArray.Detach();
	return hr;
}

namespace autoit {
	template<class T, class Allocator = std::allocator<T>>
	decltype(auto) vector_method__index(std::vector<T, Allocator>& vec, size_t index) {
		if (index < 0 || index >= vec.size()) {
			AUTOIT_ERROR("index " << index << " is out of range. Expecting an integer between 0 and " << (vec.size() - 1) << ".");
		}
		return vec.at(index);
	}

	template<class T, class Allocator = std::allocator<T>>
	void vector_method__index(std::vector<T, Allocator>& vec, size_t index, const T& value) {
		if (index >= vec.size()) {
			AUTOIT_ERROR("index " << index << " is out of range. Expecting an integer between 0 and " << (vec.size() - 1) << ".");
		}
		vec[index] = value;
	}
}

// ================================

namespace autoit {
	// ================================
	// __str__
	// ================================

	/**
	 * https://github.com/ThePhD/sol2/blob/v3.3.0/include/sol/stack_core.hpp#L1338
	 */
	template<typename T>
	std::string member_default_to_string(const T& obj) {
		return obj.to_string();
	}

	/**
	 * https://github.com/ThePhD/sol2/blob/v3.3.0/include/sol/stack_core.hpp#L1352
	 */
	template<typename T>
	inline std::string adl_default_to_string(const T& obj) {
		return std::to_string(obj);
	}

	/**
	 * https://github.com/ThePhD/sol2/blob/v3.3.0/include/sol/stack_core.hpp#L1364
	 */
	template<typename T>
	std::string oss_default_to_string(const T& obj) {
		std::ostringstream oss;
		oss << obj;
		return oss.str();
	}

	template<typename T>
	std::string __str__(const T& obj, const std::string& type) {
		// ================================================================
		// https://github.com/ThePhD/sol2/blob/v3.3.0/include/sol/types.hpp#L907
		// ================================================================

		// meta::supports_op_left_shift<std::ostream, meta::unqualified_t<T>>
		// https://github.com/ThePhD/sol2/blob/v3.3.0/include/sol/traits.hpp#L519
		// decltype(std::declval<T&>() << std::declval<U&>())
		if constexpr (requires(std::ostream & oss, const T & t) { oss << t; }) {
			return oss_default_to_string(obj);
		}

		// meta::supports_to_string_member<meta::unqualified_t<T>>
		// https://github.com/ThePhD/sol2/blob/v3.3.0/include/sol/traits.hpp#L551
		// class supports_to_string_member : public meta::boolean<meta_detail::has_to_string_test<meta_detail::non_void_t<T>>::value> { };
		// https://github.com/ThePhD/sol2/blob/v3.3.0/include/sol/traits.hpp#L465
		// https://github.com/ThePhD/sol2/blob/v3.3.0/include/sol/traits.hpp#L469
		// static sfinae_yes_t test(decltype(std::declval<C>().to_string())*);
		else if constexpr (requires(const T & t) { t.to_string(); }) {
			return member_default_to_string<T>(obj);
		}

		// meta::supports_adl_to_string<meta::unqualified_t<T>>
		// https://github.com/ThePhD/sol2/blob/v3.3.0/include/sol/traits.hpp#L547
		// class supports_adl_to_string : public meta_detail::supports_adl_to_string_test<T> { };
		// https://github.com/ThePhD/sol2/blob/v3.3.0/include/sol/traits.hpp#L523
		// class supports_adl_to_string_test<T, void_t<decltype(to_string(std::declval<const T&>()))>> : public std::true_type { };
		else if constexpr (requires(const T & t) { std::to_string(t); }) {
			return adl_default_to_string<T>(obj);
		}

		else {
			std::ostringstream oss;
			oss << "<" << type << " 0x" << std::setw(16) << std::setfill('0') << std::hex << static_cast<const void*>(&obj) << ">";
			return oss.str();
		}
	}

	// ================================

	// ================================
	// __eq__
	// ================================

	template<typename T>
	inline bool __eq__(const std::shared_ptr<T>& p1, const std::shared_ptr<T>& p2) {
		if (static_cast<bool>(p1) && static_cast<bool>(p2)) {
			return __eq__(*p1, *p2);
		}
		return !static_cast<bool>(p1) && !static_cast<bool>(p2);
	}

	template<typename K, typename V>
	inline bool __eq__(const std::map<K, V>& m1, const std::map<K, V>& m2) {
		if (m1.size() != m2.size()) {
			return false;
		}

		for (const auto& [key, value] : m1) {
			if (!m2.count(key) || !__eq__(value, m2.at(key))) {
				return false;
			}
		}

		return true;
	}

	template<typename T1, typename T2>
	inline bool __eq__(const std::pair<T1, T2>& p1, const std::pair<T1, T2>& p2) {
		return __eq__(p1.first, p2.first) && __eq__(p1.second, p2.second);
	}

	template<typename T>
	inline bool __eq__(const std::vector<T>& v1, const std::vector<T>& v2) {
		if (v1.size() != v2.size()) {
			return false;
		}
		const auto mismatched = std::mismatch(v1.begin(), v1.end(), v2.begin(), static_cast<bool(*)(const T&, const T&)>(__eq__));
		return mismatched.first == v1.end();
	}

	template<typename T>
	inline bool __eq__(const T& o1, const T& o2) {
		if constexpr (requires(const T & a, const T & b) { static_cast<bool>(a == b); }) {
			return static_cast<bool>(o1 == o2);
		}
		else {
			return &o1 == &o2;
		}
	}

	// ================================

}

// ================================
// autoit_from_reference
// ================================

template<typename T, typename V>
std::enable_if_t<autoit::is_usertype_v<T>, const HRESULT> autoit_from_reference(T& in_val, V& out_val) {
	if constexpr (std::is_same_v<V, VARIANT*>) {
		using IFace = typename TypeToImplType<T>::iface_type;
		IFace* pdispVal = nullptr;
		IFace** ppdispVal = &pdispVal;
		HRESULT hr = autoit_from_reference(in_val, ppdispVal);
		if (SUCCEEDED(hr)) {
			VariantClear(out_val);
			V_VT(out_val) = VT_DISPATCH;
			V_DISPATCH(out_val) = static_cast<IDispatch*>(*ppdispVal);
		}
		return hr;
	}
	else {
		return autoit_from(autoit::reference_internal(&in_val), out_val);
	}
}

template<typename T, typename V>
std::enable_if_t<!autoit::is_usertype_v<T> && autoit::is_instantiation_of_v<std::optional, T>, const HRESULT> autoit_from_reference(T& in_val, V& out_val) {
	if (in_val.has_value()) {
		return autoit_from_reference(in_val.value(), out_val);
	}
	return autoit_from(in_val, out_val);
}

template<typename T, typename V>
std::enable_if_t<!autoit::is_usertype_v<T> && !autoit::is_instantiation_of_v<std::optional, T>, const HRESULT> autoit_from_reference(T& in_val, V& out_val) {
	return autoit_from(in_val, out_val);
}

template<typename T, typename V>
std::enable_if_t<!std::is_reference_v<T>, const HRESULT> autoit_from_reference(const T& in_val, V& out_val) {
	return autoit_from(in_val, out_val);
}

// ================================
