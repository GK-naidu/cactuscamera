//
//  CaptureSessionManager.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import AVFoundation
import Photos
import UIKit

final class CaptureSessionManager: NSObject, ObservableObject {
    let session = AVCaptureSession()

    private let sessionQueue = DispatchQueue(label: "CaptureSessionManager.sessionQueue")
    private let outputQueue = DispatchQueue(label: "CaptureSessionManager.outputQueue")

    private let movieOutput = AVCaptureMovieFileOutput()

    private var currentFileURL: URL?

    var onRecordingDidStart: (() -> Void)?
    var onRecordingWillStop: (() -> Void)?
    var onSavingDidBegin: (() -> Void)?
    var onSavingDidFinish: ((Bool) -> Void)?

    override init() {
        super.init()
        configureSession()
    }

    func startSession() {
        sessionQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }

    func stopSession() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }

    func startRecording() {
        sessionQueue.async {
            if self.movieOutput.isRecording {
                return
            }

            let fileURL = self.makeTempURL()
            self.currentFileURL = fileURL

            if let connection = self.movieOutput.connection(with: .video) {
                connection.videoOrientation = .portrait
            }

            self.movieOutput.startRecording(to: fileURL, recordingDelegate: self)
        }
    }

    func stopRecording() {
        sessionQueue.async {
            if self.movieOutput.isRecording {
                DispatchQueue.main.async {
                    self.onRecordingWillStop?()
                }
                self.movieOutput.stopRecording()
            }
        }
    }

    private func configureSession() {
        sessionQueue.async {
            self.session.beginConfiguration()
            self.session.sessionPreset = .high

            if let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                do {
                    let videoInput = try AVCaptureDeviceInput(device: videoDevice)
                    if self.session.canAddInput(videoInput) {
                        self.session.addInput(videoInput)
                    }
                } catch {}
            }

            if let audioDevice = AVCaptureDevice.default(for: .audio) {
                do {
                    let audioInput = try AVCaptureDeviceInput(device: audioDevice)
                    if self.session.canAddInput(audioInput) {
                        self.session.addInput(audioInput)
                    }
                } catch {}
            }

            if self.session.canAddOutput(self.movieOutput) {
                self.session.addOutput(self.movieOutput)
            }

            self.session.commitConfiguration()
        }
    }

    private func makeTempURL() -> URL {
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let fileName = UUID().uuidString + ".mov"
        return tempDir.appendingPathComponent(fileName)
    }

    private func saveToLibrary(fileURL: URL) {
        DispatchQueue.main.async {
            self.onSavingDidBegin?()
        }

        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
        }, completionHandler: { success, _ in
            if success {
                try? FileManager.default.removeItem(at: fileURL)
            }
            DispatchQueue.main.async {
                self.onSavingDidFinish?(success)
            }
        })
    }
}

extension CaptureSessionManager: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.onRecordingDidStart?()
        }
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        outputQueue.async {
            let saveURL = outputFileURL
            self.saveToLibrary(fileURL: saveURL)
            self.currentFileURL = nil
        }
    }
}

