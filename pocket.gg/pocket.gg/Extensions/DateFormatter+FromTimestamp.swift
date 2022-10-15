//
//  DateFormatter+FromTimestamp.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-03-13.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import Foundation

extension DateFormatter {
  static let shared = DateFormatter()
  
  func dateFromTimestamp(_ timestamp: String?) -> String {
    guard let timestamp = timestamp else { return "" }
    guard let timeInterval = TimeInterval(timestamp) else { return "" }
    self.dateStyle = .medium
    return self.string(from: Date(timeIntervalSince1970: timeInterval))
  }
}
