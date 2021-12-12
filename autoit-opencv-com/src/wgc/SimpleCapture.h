#pragma once

#include "pch.h"
#include <opencv2/core/mat.hpp>

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
