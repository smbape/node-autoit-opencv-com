#pragma once
#pragma comment(lib, "dwmapi.lib")
#pragma comment(lib, "windowsapp.lib")

#include "targetver.h"
#include <iostream>

#include <Unknwn.h>
#include <inspectable.h>

// WinRT
#include <winrt/Windows.Foundation.h>
#include <winrt/Windows.System.h>
#include <winrt/Windows.UI.h>
#include <winrt/Windows.UI.Composition.h>
#include <winrt/Windows.UI.Composition.Desktop.h>
#include <winrt/Windows.UI.Popups.h>
#include <winrt/Windows.Graphics.Capture.h>
#include <winrt/Windows.Graphics.DirectX.h>
#include <winrt/Windows.Graphics.DirectX.Direct3d11.h>
#include <winrt/Windows.Foundation.Metadata.h>

#include <windows.ui.composition.interop.h>
#include <DispatcherQueue.h>

// STL
#include <atomic>
#include <memory>

// D3D
#include <d3d11_4.h>
#include <dxgi1_6.h>
#include <d2d1_3.h>
#include <wincodec.h>

// Helpers
#include "composition.interop.h"
#include "d3dHelpers.h"
#include "direct3d11.interop.h"
#include "capture.interop.h"

#include <opencv2/core.hpp>

namespace cv {
	namespace wgc {
		typedef void (*WGCFrameCallback)(cv::Mat* frame);

		class CV_EXPORTS_W SimpleCapture {
		public:
			SimpleCapture();
			SimpleCapture(WGCFrameCallback handleFrame) : onFrameArrived(handleFrame) {}
			~SimpleCapture();

			CV_WRAP bool setHandle(HWND hWnd, WORD channels = 4);
			CV_WRAP bool Start();
			CV_WRAP bool Pause();
			CV_WRAP bool Resume();
			CV_WRAP bool Stop();

			CV_WRAP bool Paused() {
				return m_paused.load();
			}

		public:
			static bool isWGCSupported;
			CV_PROP_RW WGCFrameCallback onFrameArrived;

		private:
			// since I don't know the copy behaviour
			// disable it
			SimpleCapture(const SimpleCapture&) = delete;
			SimpleCapture& operator=(const SimpleCapture&) = delete;

			void OnFrameArrived(
				winrt::Windows::Graphics::Capture::Direct3D11CaptureFramePool const& sender,
				winrt::Windows::Foundation::IInspectable const& args);

		private:
			WORD m_channels = 4;
			winrt::Windows::Graphics::DirectX::DirectXPixelFormat m_format;

			winrt::Windows::Graphics::Capture::GraphicsCaptureItem m_item{ nullptr };
			winrt::Windows::Graphics::Capture::Direct3D11CaptureFramePool m_framePool{ nullptr };
			winrt::Windows::Graphics::Capture::GraphicsCaptureSession m_session{ nullptr };
			winrt::Windows::Graphics::SizeInt32 m_lastSize;

			winrt::Windows::Graphics::DirectX::Direct3D11::IDirect3DDevice m_device{ nullptr };
			winrt::com_ptr<ID3D11DeviceContext> m_d3dContext{ nullptr };

			std::atomic<bool> m_closed = true;
			std::atomic<bool> m_paused = false;
			winrt::Windows::Graphics::Capture::Direct3D11CaptureFramePool::FrameArrived_revoker m_frameArrived;
		};

		CV_EXPORTS_W bool isWGCSupported();
		CV_EXPORTS_W cv::Ptr<SimpleCapture> createSimpleCapture();
		CV_EXPORTS_W cv::Ptr<SimpleCapture> createSimpleCapture(WGCFrameCallback handleFrame);
		CV_EXPORTS_W void BitBltCapture(HWND hWnd, CV_OUT cv::Mat& dst, WORD channels = 4);
	}
}
