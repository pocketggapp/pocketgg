import SwiftUI

private enum Constants {
  static let accessTokenLastRefreshed = "accessTokenLastRefreshed"
}

struct SettingsView: View {
  @EnvironmentObject private var appRootManager: AppRootManager
  
  var body: some View {
    Button("Log out") {
      do {
        try KeychainService.deleteToken(.accessToken)
        try KeychainService.deleteToken(.refreshToken)
        UserDefaults.standard.removeObject(forKey: Constants.accessTokenLastRefreshed)
        appRootManager.currentRoot = .login
      } catch {
        print(error)
      }
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
