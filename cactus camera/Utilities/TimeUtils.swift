//
//  TimeUtils.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation

enum TimeUtils {
    static func formatDuration(from start: Date, to now: Date = Date()) -> String {
        let interval = Int(now.timeIntervalSince(start))
        let minutes = interval / 60
        let seconds = interval % 60

        let minutesString = String(format: "%02d", minutes)
        let secondsString = String(format: "%02d", seconds)

        return "\(minutesString):\(secondsString)"
    }
}
