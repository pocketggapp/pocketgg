import SwiftUI

struct AppStartupView: View {
  @EnvironmentObject private var appRootManager: AppRootManager
  @StateObject private var viewModel: AppStartupViewModel
  
  @State private var showingExpiredTokenAlert = false
  @State private var showingServerUnavailableAlert = false
  @State private var showingNoInternetAlert = false
  
  init(oAuthService: OAuthServiceType = OAuthService.shared) {
    self._viewModel = StateObject(wrappedValue: {
      AppStartupViewModel(oAuthService: oAuthService)
    }())
  }
  
  var body: some View {
    ProgressView()
      .onAppear {
        // Ensure an access token is present. If not present, go to LoginView
        guard viewModel.accessTokenPresent() else {
          logOut()
          return
        }
        
        // If the access token was already refreshed today, go directly to HomeView
        guard viewModel.shouldRefreshAccessToken() else {
          #if DEBUG
          print("NOT REFRESHING ACCESS TOKEN")
          #endif
          appRootManager.currentRoot = .home
          return
        }
        
        refreshAccessToken()
      }
      .alert("Your session has expired", isPresented: $showingExpiredTokenAlert, actions: {
        Button("OK", role: .cancel) { logOut() }
      }, message: {
        Text("Please log in via start.gg again.")
      })
      .alert("Error", isPresented: $showingServerUnavailableAlert, actions: {
        Button("Retry", role: .cancel) { refreshAccessToken() }
        Button("Log out") { logOut() }
      }, message: {
        Text("The start.gg servers are currently unavailable, please try again soon.")
      })
      .alert("Error", isPresented: $showingNoInternetAlert, actions: {
        Button("Retry", role: .cancel) { refreshAccessToken() }
        Button("Log out") { logOut() }
      }, message: {
        Text("Unable to connect to the server. Please check the internet connection and try again.")
      })
  }
  
  /// Uses the refresh token to get a new access token, valid for another week. If successful, navigate to HomeView
  private func refreshAccessToken() {
    #if DEBUG
    print("REFRESHING ACCESS TOKEN")
    #endif
    
    Task {
      do {
        try await viewModel.refreshAccessToken()
        appRootManager.currentRoot = .home
      } catch {
        switch error {
        case OAuthError.dataTaskError(_):
          showingNoInternetAlert = true
        case LoginError.serverUnavailable:
          showingServerUnavailableAlert = true
        default:
          showingExpiredTokenAlert = true
        }
      }
    }
  }
  
  /// Clear the access token, refresh token, and navigate to LoginView
  private func logOut() {
    do {
      try KeychainService.deleteToken(.accessToken)
      try KeychainService.deleteToken(.refreshToken)
    } catch {
      #if DEBUG
      print(error)
      #endif
    }
    
    UserDefaults.standard.removeObject(forKey: Constants.accessTokenLastRefreshed)
    appRootManager.currentRoot = .login
  }
}

#Preview {
  AppStartupView(
    oAuthService: MockOAuthService()
  )
}
