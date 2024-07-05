import Foundation

extension DateFormatter {
  static let shared = DateFormatter()
  
  func dateStringFromTimestamp(_ timestamp: String?) -> String {
    guard let timestamp = timestamp else { return "" }
    guard let timeInterval = TimeInterval(timestamp) else { return "" }
    self.dateStyle = .medium
    return self.string(from: Date(timeIntervalSince1970: timeInterval))
  }
  
  static func dateFromTimestamp(_ timestamp: String?) -> Date? {
    guard let timestamp = timestamp else { return nil }
    guard let timeInterval = TimeInterval(timestamp) else { return nil }
    return Date(timeIntervalSince1970: timeInterval)
  }
}
