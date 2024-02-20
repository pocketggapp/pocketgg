enum Constants {
  // UserDefaults
  static let accessTokenLastRefreshed = "accessTokenLastRefreshed"
  
  /// Hardcoded backup in case the call to Bundle.main.infoDictionary?["CFBundleShortVersionString"] somehow fails
  static let currentAppVersion = "2.0"
}
