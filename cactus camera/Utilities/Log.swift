//
//  Log.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import Foundation
import os

enum Log {
    private static let subsystem = "com.cactuscamera.app"

    static func info(_ message: String) {
        let logger = os.Logger(subsystem: subsystem, category: "info")
        logger.log("\(message, privacy: .public)")
    }

    static func error(_ message: String) {
        let logger = os.Logger(subsystem: subsystem, category: "error")
        logger.error("\(message, privacy: .public)")
    }

    static func debug(_ message: String) {
        let logger = os.Logger(subsystem: subsystem, category: "debug")
        logger.debug("\(message, privacy: .public)")
    }
}
