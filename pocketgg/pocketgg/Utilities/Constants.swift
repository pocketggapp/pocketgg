enum Constants {
  // UserDefaults
  static let accessTokenLastRefreshed = "accessTokenLastRefreshed"
  static let appVersion = "appVersion"
  static let homeViewSections = "homeViewSections"
  
  // NotificationCenter
  static let videoGamesChanged = "videoGamesChanged"
  
  /// Hardcoded backup in case the call to Bundle.main.infoDictionary?["CFBundleShortVersionString"] somehow fails
  static let currentAppVersion = "2.0"
}
