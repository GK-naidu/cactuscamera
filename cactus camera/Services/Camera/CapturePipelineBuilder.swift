//
//  CapturePipelineBuilder.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import AVFoundation

final class CapturePipelineBuilder {
    func buildSession() throws -> AVCaptureSession {
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = .high

        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            session.commitConfiguration()
            throw CameraError.cameraUnavailable
        }

        let videoInput = try AVCaptureDeviceInput(device: videoDevice)
        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        } else {
            session.commitConfiguration()
            throw CameraError.configurationFailed
        }

        guard let audioDevice = AVCaptureDevice.default(for: .audio) else {
            session.commitConfiguration()
            throw CameraError.microphoneUnavailable
        }

        let audioInput = try AVCaptureDeviceInput(device: audioDevice)
        if session.canAddInput(audioInput) {
            session.addInput(audioInput)
        } else {
            session.commitConfiguration()
            throw CameraError.configurationFailed
        }

        session.commitConfiguration()
        return session
    }
}
