enum Constants {
  // UserDefaults
  static let accessTokenLastRefreshed = "accessTokenLastRefreshed"
  static let appVersion = "appVersion"
  static let homeViewSections = "homeViewSections"
  static let pinnedTournamentIDs = "pinnedTournamentIDs"
  
  // NotificationCenter
  static let refreshHomeView = "refreshHomeView"
  
  /// Hardcoded backup in case the call to Bundle.main.infoDictionary?["CFBundleShortVersionString"] somehow fails
  static let currentAppVersion = "2.0"
}
