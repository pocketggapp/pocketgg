import Foundation

extension DateFormatter {
  static func dateFromTimestamp(_ timestamp: String?) -> Date? {
    guard let timestamp = timestamp else { return nil }
    guard let timeInterval = TimeInterval(timestamp) else { return nil }
    return Date(timeIntervalSince1970: timeInterval)
  }
}
