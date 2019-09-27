// BaseLogger.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh on 2019/9/18.

import Foundation
import os

enum LogLevel: Int, CustomStringConvertible {
  var description: String {
    switch self {
    case .fault:
      return "❌ Fault"
    case .error:
      return "‼️ Error"
    case .debug:
      return "🐌 Debug"
    case .info:
      return "📗 Info"
    case .defaultLevel:
      return "🍋 Default"
    }
  }

  case fault, error, debug, info, defaultLevel
  
  var theOSLogType: OSLogType {
    switch self {
    case .fault:
      return .fault
    case .error:
      return .error
    case .debug:
      return .debug
    case .info:
      return .info
    case .defaultLevel:
      return .default
    }
  }
  
}

#if TEST
  let logger = BaseLogger() // Test Target 要測試時用這個
#else
  let logger = AdvancedLogger() // APP Target 用這個，此包含 UI 和 Log 檔案儲存。
#endif

struct Log {
  // TODO: 根據需要進行修改。
  static let subsystem = "me.jerome.Mod"
  static let table = OSLog(subsystem: subsystem, category: "table")
  static let networking = OSLog(subsystem: subsystem, category: "networking")
  static let test = OSLog(subsystem: subsystem, category: "test")
  static let image = OSLog(subsystem: subsystem, category: "image")
  static let defaultLog = OSLog(subsystem: subsystem, category: "default")
}

class BaseLogger {
  // MARK: - Properties

  private(set) var logLevels = [LogLevel]()
  private(set) var shouldShow = false
  private(set) var shouldCache = false

  init() {}

  // MARK: - Public method

  func configure(_ logLevels: [LogLevel], shouldShow: Bool = false, shouldCache: Bool = false) {
    self.logLevels = logLevels
    self.shouldShow = shouldShow
    self.shouldCache = shouldCache
  }

  func log(_ items: Any,
           theOSLog: OSLog = Log.defaultLog,
           level: LogLevel = .defaultLevel,
           file: String = #file,
           function: String = #function,
           line: Int = #line) {
    #if DEBUG
      if logLevels.contains(level) {
        let fileName = file.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
        let logString = "⭐️ [\(level.description)] [\(fileName).\(function):\(line)] > \(items)"

        os_log("%@", log: theOSLog, type: level.theOSLogType, logString)

        if shouldShow {
          show(logString)
        }

        if shouldCache {
          cache(logString)
        }
      }
    #endif
  }

  func show(_: String) {} // 在 AdvancedLogger 中實作
  func cache(_: String) {} // 在 AdvancedLogger 中實作
}

extension Date {
  func toString(dateFormat: String = "yyyy-MM-dd HH:mm:ss.SSS") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter.string(from: self)
  }
}
