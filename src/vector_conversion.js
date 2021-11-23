module.exports = (coclass, header, impl) => {
    const cotype = coclass.getClassName();
    const comparator = `${ coclass.fqn }Comparator`;
    const ptr_comparator = `${ coclass.fqn }PtrComparator`;
    const { cpptype } = coclass;
    const idltype = coclass.idltype === "VARIANT" || coclass.idltype[0] === "I" ? "VARIANT" : coclass.idltype;
    const to_variant = idltype === "VARIANT";
    const default_value = to_variant ? "{ VT_EMPTY }" : "NULL";
    const ptrtype = to_variant ? idltype : cpptype;
    const byref = cpptype !== "void*" && cpptype !== "uchar*" && (idltype === "VARIANT" || idltype[0] === "I");

    const cvt = (to_variant || idltype[0] === "I" ? `
        ${ to_variant ? "_variant_t" : idltype } va = ${ default_value };
        ${ to_variant ? "_variant_t" : idltype } vb = ${ default_value };

        ${ idltype }* pva = &va;
        ${ idltype }* pvb = &vb;

        autoit_opencv_from(a, pva);
        autoit_opencv_from(b, pvb);

        return cmp(pva, pvb);
    ` : `
        return cmp(&a, &b);
    `).replace(/^ {8}/mg, "").trim().split("\n");

    header.push(`
        typedef bool (*${ comparator })(${ cpptype } a, ${ cpptype } b);
        typedef bool (*${ ptr_comparator })(${ ptrtype }* a, ${ ptrtype }* b);
        typedef struct _${ comparator }Proxy  ${ comparator }Proxy;

        extern const bool is_assignable_from(${ coclass.fqn }& out_val, I${ cotype }*& in_val, bool is_optional);
        extern const HRESULT autoit_opencv_to(I${ cotype }*& in_val, ${ coclass.fqn }& out_val);
        extern const HRESULT autoit_opencv_out(VARIANT const* const& in_val, I${ cotype }**& out_val);

        extern const HRESULT autoit_opencv_from(I${ cotype }*& in_val, I${ cotype }**& out_val);
        extern const HRESULT autoit_opencv_from(I${ cotype }*& in_val, IDispatch**& out_val);
        extern const HRESULT autoit_opencv_from(I${ cotype }*& in_val, VARIANT*& out_val);
        extern const HRESULT autoit_opencv_from(const cv::Ptr<${ coclass.fqn }>& in_val, I${ cotype }**& out_val);
    `.replace(/^ {8}/mg, ""));

    impl.push(`
        typedef struct _${ comparator }Proxy {
            ${ ptr_comparator } cmp;
            bool operator() (${ cpptype } a, ${ cpptype } b) {
                ${ cvt.join(`\n${ " ".repeat(16) }`) }
            }
        } ${ comparator }Proxy;

        const bool is_assignable_from(${ coclass.fqn }& out_val, I${ cotype }* in_val, bool is_optional) {
            return true;
        }

        const HRESULT autoit_opencv_to(I${ cotype }*& in_val, ${ coclass.fqn }& out_val) {
            auto obj = reinterpret_cast<C${ cotype }*>(in_val);
            out_val = *obj->__self->get();
            return S_OK;
        }

        const HRESULT autoit_opencv_out(VARIANT const* const& in_val, I${ cotype }**& out_val) {
            if (V_VT(in_val) != VT_DISPATCH) {
                return E_INVALIDARG;
            }

            auto obj = reinterpret_cast<I${ cotype }*>(getRealIDispatch(in_val));
            *out_val = obj;
            obj->AddRef();
            return S_OK;
        }

        const HRESULT autoit_opencv_from(I${ cotype }*& in_val, I${ cotype }**& out_val) {
            *out_val = in_val;
            in_val->AddRef();
            return S_OK;
        }

        const HRESULT autoit_opencv_from(I${ cotype }*& in_val, IDispatch**& out_val) {
            *out_val = static_cast<IDispatch*>(in_val);
            in_val->AddRef();
            return S_OK;
        }

        const HRESULT autoit_opencv_from(I${ cotype }*& in_val, VARIANT*& out_val) {
            VariantClear(out_val);
            V_VT(out_val) = VT_DISPATCH;
            V_DISPATCH(out_val) = static_cast<IDispatch*>(in_val);
            in_val->AddRef();
            return S_OK;
        }

        const HRESULT autoit_opencv_from(const cv::Ptr<${ coclass.fqn }>& in_val, I${ cotype }**& out_val) {
            HRESULT hr = CoCreateInstance(CLSID_${ cotype }, NULL, CLSCTX_INPROC_SERVER, IID_I${ cotype }, reinterpret_cast<void**>(out_val));
            if (SUCCEEDED(hr)) {
                auto obj = static_cast<C${ cotype }*>(*out_val);
                delete obj->__self;
                obj->__self = new cv::Ptr<${ coclass.fqn }>(in_val);
            }
            return hr;
        }

        #include "vectors_c.h"

        void C${ cotype }::at(size_t i, ${ cpptype }${ byref ? "&" : "" } value, HRESULT& hr) {
            (*this->__self->get())[i] = value;
        }

        void C${ cotype }::push_vector(${ coclass.fqn }& other, HRESULT& hr) {
            auto v = this->__self->get();
            VectorPushMulti(v, &other[0], other.size());
        }

        void C${ cotype }::push_vector(${ coclass.fqn }& other, size_t count, size_t start, HRESULT& hr) {
            auto v = this->__self->get();
            VectorPushMulti(v, &other[start], count);
        }

        const ${ coclass.fqn } C${ cotype }::slice(size_t start, size_t count, HRESULT& hr) {
            auto v = this->__self->get();
            auto begin = v->begin() + start;
            return ${ coclass.fqn }(begin, begin + count);
        }

        void C${ cotype }::sort(void* comparator, size_t start, size_t count, HRESULT& hr) {
            auto v = this->__self->get();
            auto begin = v->begin() + start;
            std::sort(begin, begin + count, reinterpret_cast<${ comparator }>(comparator));
        }

        void C${ cotype }::sort_variant(void* comparator, size_t start, size_t count, HRESULT& hr) {
            auto v = this->__self->get();
            auto begin = v->begin() + start;
            ${ comparator }Proxy cmp = { reinterpret_cast<${ ptr_comparator }>(comparator) };
            std::sort(begin, begin + count, cmp);
        }

        const void* C${ cotype }::start(HRESULT& hr) {
            auto v = this->__self->get();
            auto _result = v->empty() ? NULL : static_cast<const void*>(&(*v)[0]);
            return _result;
        }

        const void* C${ cotype }::end(HRESULT& hr) {
            auto v = this->__self->get();
            auto _result = v->empty() ? NULL : static_cast<const void*>(&(*v)[v->size()]);
            return _result;
        }
        `.replace(/^ {8}/mg, "")
    );
};
