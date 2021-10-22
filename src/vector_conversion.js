module.exports = (coclass, header, impl) => {
    const cotype = coclass.getClassName();

    header.push(`
        extern const bool is_assignable_from(${ coclass.fqn }& out_val, I${ cotype }*& in_val, bool is_optional);
        extern const HRESULT autoit_opencv_to(I${ cotype }*& in_val, ${ coclass.fqn }& out_val);
        extern const HRESULT autoit_opencv_out(VARIANT const* const& in_val, I${ cotype }**& out_val);

        extern const HRESULT autoit_opencv_from(I${ cotype }*& in_val, I${ cotype }**& out_val);
        extern const HRESULT autoit_opencv_from(I${ cotype }*& in_val, IDispatch**& out_val);
        extern const HRESULT autoit_opencv_from(I${ cotype }*& in_val, VARIANT*& out_val);
        extern const HRESULT autoit_opencv_from(const cv::Ptr<${ coclass.fqn }>& in_val, I${ cotype }**& out_val);
    `.replace(/^ {8}/mg, ""));

    impl.push(`
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
                obj->__self = new cv::Ptr<${ coclass.fqn }>(in_val);
            }
            return hr;
        }

        #include "vectors_c.h"

        void C${ cotype }::at(size_t i, ${ coclass.cpptype } value) {
            (*this->__self->get())[i] = value;
        }

        void C${ cotype }::push_vector(${ coclass.fqn } other) {
            push_vector(other, other.size());
        }

        void C${ cotype }::push_vector(${ coclass.fqn } other, size_t count) {
            auto v = this->__self->get();
            VectorPushMulti(v, &other[0], count);
        }

        void* C${ cotype }::start() {
            auto v = this->__self->get();
            return v->empty() ? NULL : reinterpret_cast<void*>(&(*v)[0]);
        }

        void* C${ cotype }::end() {
            auto v = this->__self->get();
            if (v->empty()) return NULL;
            return reinterpret_cast<void*>(&(*v)[v->size()]);
        }
        `.replace(/^ {8}/mg, "")
    );
};
