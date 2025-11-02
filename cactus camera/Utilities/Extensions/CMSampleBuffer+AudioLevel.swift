//
//  CMSampleBuffer+AudioLevel.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import AVFoundation

extension CMSampleBuffer {
    func peakAudioLevel() -> Float {
        guard let blockBuffer = CMSampleBufferGetDataBuffer(self) else {
            return 0.0
        }

        var lengthAtOffset: Int = 0
        var totalLength: Int = 0
        var dataPointer: UnsafeMutablePointer<Int8>?

        let status = CMBlockBufferGetDataPointer(
            blockBuffer,
            atOffset: 0,
            lengthAtOffsetOut: &lengthAtOffset,
            totalLengthOut: &totalLength,
            dataPointerOut: &dataPointer
        )

        if status != noErr {
            return 0.0
        }

        guard let dataPointer else { return 0.0 }

        let sampleCount = totalLength / MemoryLayout<Int16>.size

        let samples = dataPointer.withMemoryRebound(to: Int16.self, capacity: sampleCount) {
            UnsafeBufferPointer(start: $0, count: sampleCount)
        }

        var maxSample: Int16 = 0
        for sample in samples {
            let magnitude = sample >= 0 ? sample : Int16(-Int32(sample))
            if magnitude > maxSample {
                maxSample = magnitude
            }
        }

        let normalized = Float(maxSample) / Float(Int16.max)
        return normalized
    }
}
