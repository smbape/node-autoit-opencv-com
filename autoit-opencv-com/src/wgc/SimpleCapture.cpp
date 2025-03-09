#include "SimpleCapture.h"

using namespace winrt;
using namespace Windows;
using namespace Windows::Foundation;
using namespace Windows::System;
using namespace Windows::Graphics;
using namespace Windows::Graphics::Capture;
using namespace Windows::Graphics::DirectX;
using namespace Windows::Graphics::DirectX::Direct3D11;
using namespace Windows::Foundation::Numerics;
using namespace Windows::UI;
using namespace Windows::UI::Composition;

namespace cv {
	namespace wgc {
		/**
		 * @see https://github.com/obsproject/obs-studio/blob/27.1.3/libobs-winrt/winrt-capture.cpp#L15
		 */
		bool winrt_capture_supported() {
			try {
				/* no contract for IGraphicsCaptureItemInterop, verify 10.0.18362.0 */
				return winrt::Windows::Foundation::Metadata::ApiInformation::
					IsApiContractPresent(L"Windows.Foundation.UniversalApiContract", 8);
			}
			catch (const winrt::hresult_error& err) {
				auto msg = cv::format("winrt_capture_supported (0x%08X): %ls", err.code().value, err.message().c_str());
				std::cout << msg << std::endl;
				return false;
			}
			catch (...) {
				auto msg = cv::format("winrt_capture_supported (0x%08X)", winrt::to_hresult().value);
				std::cout << msg << std::endl;
				return false;
			}
		}

		bool SimpleCapture::isWGCSupported = winrt_capture_supported();

		SimpleCapture::SimpleCapture() : onFrameArrived(nullptr) {
			if (!SimpleCapture::isWGCSupported) {
				return;
			}

			auto d3dDevice = CreateD3DDevice();
			auto dxgiDevice = d3dDevice.as<IDXGIDevice>();
			m_device = CreateDirect3DDevice(dxgiDevice.get());
			d3dDevice->GetImmediateContext(m_d3dContext.put());
		}

		SimpleCapture::~SimpleCapture() {
			Stop();
			m_d3dContext = nullptr;
			m_device = nullptr;
			m_item = nullptr;
			onFrameArrived = nullptr;
		}

		bool SimpleCapture::setHandle(HWND hWnd, WORD channels) {
			if (!SimpleCapture::isWGCSupported) {
				return false;
			}

			Stop();

			if (!hWnd) {
				return false;
			}

			m_channels = channels;
			m_format = m_channels == 4 ? DirectXPixelFormat::B8G8R8A8UIntNormalized : DirectXPixelFormat::B8G8R8X8UIntNormalized;
			m_item = CreateCaptureItemForWindow(hWnd);

			return true;
		}

		// Start sending capture frames
		bool SimpleCapture::Start() {
			if (!SimpleCapture::isWGCSupported) {
				return false;
			}

			if (!m_item) {
				return false;
			}

			auto expected = true;
			if (!m_closed.compare_exchange_strong(expected, !expected)) {
				return false;
			}

			auto size = m_item.Size();

			// Create framepool, define pixel format (DXGI_FORMAT_B8G8R8A8_UNORM), and frame size. 
			m_framePool = Direct3D11CaptureFramePool::Create(
				m_device,
				m_format,
				2,
				size
			);

			m_session = m_framePool.CreateCaptureSession(m_item);
			m_lastSize = size;
			m_frameArrived = m_framePool.FrameArrived(auto_revoke, { this, &SimpleCapture::OnFrameArrived });
			m_session.StartCapture();
			return true;
		}

		bool SimpleCapture::Pause() {
			if (!SimpleCapture::isWGCSupported) {
				return false;
			}

			auto expected = false;
			return m_paused.compare_exchange_strong(expected, !expected);
		}

		bool SimpleCapture::Resume() {
			if (!SimpleCapture::isWGCSupported) {
				return false;
			}

			auto expected = true;
			return m_paused.compare_exchange_strong(expected, !expected);
		}

		// Stop sending capture frames
		bool SimpleCapture::Stop() {
			if (!SimpleCapture::isWGCSupported) {
				return false;
			}

			auto expected = false;
			if (!m_closed.compare_exchange_strong(expected, !expected)) {
				return false;
			}

			m_frameArrived.revoke();
			m_session.Close();
			m_framePool.Close();

			m_session = nullptr;
			m_framePool = nullptr;

			return true;
		}

		void SimpleCapture::OnFrameArrived(
			Direct3D11CaptureFramePool const& sender,
			winrt::Windows::Foundation::IInspectable const&)
		{
			auto newSize = false;

			{
				auto frame = sender.TryGetNextFrame();
				auto frameContentSize = frame.ContentSize();

				if (frameContentSize.Width != m_lastSize.Width ||
					frameContentSize.Height != m_lastSize.Height)
				{
					// The thing we have been capturing has changed size.
					// We need to resize our swap chain first, then blit the pixels.
					// After we do that, retire the frame and then recreate our frame pool.
					newSize = true;
					m_lastSize = frameContentSize;
				}

				if (onFrameArrived && !m_paused.load()) {
					auto d3dDevice = GetDXGIInterfaceFromObject<ID3D11Device>(m_device);
					auto srcTexture = GetDXGIInterfaceFromObject<ID3D11Texture2D>(frame.Surface());

					// Create CPU access texture
					D3D11_TEXTURE2D_DESC desc = {};
					srcTexture->GetDesc(&desc);

					// https://gist.github.com/Arnold1/0bec046c0d82c6a78ea13ee7c4f176b3#file-screen_capture-cpp-L379
					desc.Usage = D3D11_USAGE_STAGING;
					desc.BindFlags = 0;
					desc.CPUAccessFlags = D3D11_CPU_ACCESS_READ | D3D11_CPU_ACCESS_WRITE;
					desc.MiscFlags = 0;

					// https://gist.github.com/Arnold1/0bec046c0d82c6a78ea13ee7c4f176b3#file-screen_capture-cpp-L480
					winrt::com_ptr<ID3D11Texture2D> dstTexture;
					winrt::check_hresult(d3dDevice->CreateTexture2D(&desc, nullptr, dstTexture.put()));
					m_d3dContext->CopyResource(dstTexture.get(), srcTexture.get());

					// Copy from CPU access texture to bitmap buffer
					D3D11_MAPPED_SUBRESOURCE resource;
					auto subresource = D3D11CalcSubresource(0, 0, 0);
					m_d3dContext->Map(dstTexture.get(), subresource, D3D11_MAP_READ_WRITE, 0, &resource);

					auto data = reinterpret_cast<BYTE*>(resource.pData);
					cv::Mat src(frameContentSize.Height, frameContentSize.Width, CV_MAKETYPE(CV_8U, m_channels), data, resource.RowPitch);
					onFrameArrived(&src);
				}
			}

			if (newSize) {
				m_framePool.Recreate(
					m_device,
					m_format,
					2,
					m_lastSize
				);
			}
		}

		cv::Ptr<SimpleCapture> createSimpleCapture() {
			return cv::Ptr<SimpleCapture>(new SimpleCapture());
		}

		cv::Ptr<SimpleCapture> createSimpleCapture(WGCFrameCallback handleFrame) {
			return cv::Ptr<SimpleCapture>(new SimpleCapture(handleFrame));
		}

		void BitBltCapture(HWND hWnd, cv::Mat& dst, WORD channels) {
			RECT tRECT;
			GetWindowRect(hWnd, &tRECT);
			auto width = tRECT.right - tRECT.left + 1;
			auto height = tRECT.bottom - tRECT.top + 1;

			auto hWndDC = GetDC(hWnd);
			auto hSrcDC = CreateCompatibleDC(hWndDC);
			auto hPrevSrcObject = SelectObject(hSrcDC, CreateCompatibleBitmap(hWndDC, width, height));
			PrintWindow(hWnd, hSrcDC, 0);

			auto hDstDC = CreateCompatibleDC(hWndDC);

			BITMAPINFO tBITMAPINFO;
			ZeroMemory(&tBITMAPINFO, sizeof(BITMAPINFO));
			tBITMAPINFO.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
			tBITMAPINFO.bmiHeader.biWidth = width;
			tBITMAPINFO.bmiHeader.biHeight = height;
			tBITMAPINFO.bmiHeader.biPlanes = 1;
			tBITMAPINFO.bmiHeader.biBitCount = channels * 8;
			tBITMAPINFO.bmiHeader.biCompression = BI_RGB;

			BYTE* pBits = NULL;
			auto hPrevDstObject = SelectObject(hDstDC, CreateDIBSection(hDstDC, &tBITMAPINFO, DIB_RGB_COLORS, reinterpret_cast<void**>(&pBits), 0, 0));
			BitBlt(hDstDC, 0, 0, width, height, hSrcDC, 0, 0, SRCCOPY);

			cv::Mat src(height, width, CV_MAKETYPE(CV_8U, channels), pBits, (width * channels + 3) & -4);
			cv::flip(src, dst, 0);

			DeleteObject(SelectObject(hDstDC, hPrevDstObject));
			DeleteDC(hDstDC);
			DeleteObject(SelectObject(hSrcDC, hPrevSrcObject));
			DeleteDC(hSrcDC);
			ReleaseDC(hWnd, hWndDC);
		}

		bool isWGCSupported() {
			return SimpleCapture::isWGCSupported;
		}
	}
}
