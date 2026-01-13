//
//  QRScannerView.swift
//  Onepazz
//
//  Created by Claude on 11/2/25.
//

import SwiftUI
import AVFoundation

struct QRScannerView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = QRScannerViewModel()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Camera preview
                CameraPreview(session: viewModel.session, viewModel: viewModel)
                    .ignoresSafeArea()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            viewModel.updateScanningArea(for: geometry.size)
                        }
                    }

            // Dark overlay with cutout
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .mask(
                    Rectangle()
                        .fill(Color.black)
                        .overlay(
                            Rectangle()
                                .frame(width: 260, height: 260)
                                .blendMode(.destinationOut)
                        )
                )

            ZStack {
                VStack(spacing: 0) {
                    // Top navigation bar
                    ZStack {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                            }

                            Spacer()
                        }

                        Text("Scan QR")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 12)

                    Spacer()

                    // Bottom icon
                    Image(systemName: "qrcode")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, 80)
                }

                // Corner brackets - centered on screen
                CornerBrackets()
                    .stroke(Color(red: 0.2, green: 0.6, blue: 0.86), lineWidth: 5)
                    .frame(width: 260, height: 260)
            }

            // Scanned result
            if let scannedCode = viewModel.scannedCode {
                VStack {
                    Spacer()
                    Text("Scanned: \(scannedCode)")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.bottom, 150)
                }
            }
        }
        .onAppear {
            viewModel.startScanning()
        }
        .onDisappear {
            viewModel.stopScanning()
        }
        }
    }
}

// MARK: - Corner Brackets Shape

struct CornerBrackets: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerLength: CGFloat = 30

        // Top-left corner
        path.move(to: CGPoint(x: rect.minX + cornerLength, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerLength))

        // Top-right corner
        path.move(to: CGPoint(x: rect.maxX - cornerLength, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerLength))

        // Bottom-left corner
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY - cornerLength))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + cornerLength, y: rect.maxY))

        // Bottom-right corner
        path.move(to: CGPoint(x: rect.maxX - cornerLength, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerLength))

        return path
    }
}

// MARK: - Camera Preview

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    let viewModel: QRScannerViewModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        context.coordinator.previewLayer = previewLayer
        viewModel.previewLayer = previewLayer
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            context.coordinator.previewLayer?.frame = uiView.bounds
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var previewLayer: AVCaptureVideoPreviewLayer?
    }
}

// MARK: - QR Scanner ViewModel

class QRScannerViewModel: NSObject, ObservableObject {
    @Published var scannedCode: String?
    let session = AVCaptureSession()
    private let metadataOutput = AVCaptureMetadataOutput()
    private let sessionQueue = DispatchQueue(label: "qr.scanner.session")
    var previewLayer: AVCaptureVideoPreviewLayer?

    func startScanning() {
        sessionQueue.async { [weak self] in
            self?.setupCaptureSession()
        }
    }

    func stopScanning() {
        sessionQueue.async { [weak self] in
            self?.session.stopRunning()
        }
    }

    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }

        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("Error creating video input: \(error)")
            return
        }

        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        }

        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
        }
    }

    func updateScanningArea(for screenSize: CGSize) {
        guard let previewLayer = previewLayer else { return }

        // Calculate the scanning rect (260x260) centered on screen - matching the bracket position
        let scanSize: CGFloat = 260
        let x = (screenSize.width - scanSize) / 2
        let y = (screenSize.height - scanSize) / 2
        let scanRect = CGRect(x: x, y: y, width: scanSize, height: scanSize)

        // Convert to normalized coordinates for metadata output
        let rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: scanRect)
        metadataOutput.rectOfInterest = rectOfInterest
    }
}

extension QRScannerViewModel: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            scannedCode = stringValue
        }
    }
}

#Preview {
    QRScannerView()
}
