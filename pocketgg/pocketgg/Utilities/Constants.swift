enum Constants {
  // UserDefaults
  static let accessTokenLastRefreshed = "accessTokenLastRefreshed"
  static let appVersion = "appVersion"
  static let homeViewSections = "homeViewSections"
  static let pinnedTournamentIDs = "pinnedTournamentIDs"
  static let locationEnabled = "locationEnabled"
  static let locationCoordinates = "locationCoordinates"
  static let locationString = "locationString"
  static let locationDistance = "locationDistance"
  static let locationDistanceUnit = "locationDistanceUnit"
  static let followedTournamentOrganizerIDs = "followedTournamentOrganizerIDs"
  
  // NotificationCenter
  static let refreshHomeView = "refreshHomeView"
  static let refreshFollowingView = "refreshFollowingView"
  
  /// Hardcoded backup in case the call to Bundle.main.infoDictionary?["CFBundleShortVersionString"] somehow fails
  static let currentAppVersion = "2.0"
}
