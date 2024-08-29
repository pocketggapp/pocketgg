import SwiftUI

struct SettingsView: View {
  @EnvironmentObject private var appRootManager: AppRootManager
  @ScaledMetric private var scale: CGFloat = 1
  @State private var showingWhatsNewSheet = false
  @State private var showingLogOutAlert = false
  
  var body: some View {
    NavigationStack {
      List {
        Section {
          NavigationLink(value: 0) {
            HStack {
              settingsRowView(imageName: "gamecontroller")   
              Text("Video Game Selection")
            }
          }
          
          NavigationLink(value: 1) {
            HStack {
              settingsRowView(imageName: "location")
              Text("Location")
            }
          }
          
          NavigationLink(value: 2) {
            HStack {
              settingsRowView(imageName: "text.line.first.and.arrowtriangle.forward")
              Text("Rearrange Sections")
            }
          }
        }
        
        Section {
          Button {
            showingWhatsNewSheet = true
          } label: {
            HStack {
              Image(systemName: "sparkles")
                .foregroundColor(.red)
                .frame(width: 30 * scale, height: 30 * scale)
              Text("What's New")
                .foregroundColor(Color(uiColor: .label))
            }
          }
        }
        
        Section {
          Button {
            launchAppStoreReviewPage()
          } label: {
            HStack {
              Image(systemName: "star")
                .foregroundColor(.red)
                .frame(width: 30 * scale, height: 30 * scale)
              Text("Write a Review")
                .foregroundColor(Color(uiColor: .label))
            }
          }
          
          NavigationLink(value: 5) {
            HStack {
              settingsRowView(imageName: "heart")
              Text("Tip Jar")
            }
          }
          
          NavigationLink(value: 6) {
            HStack {
              settingsRowView(imageName: "info.circle")
              Text("About")
            }
          }
        }
        
        Section {
          Button {
            showingLogOutAlert = true
          } label: {
            HStack {
              Spacer()
              Text("Log out").foregroundColor(.red)
              Spacer()
            }
          }
        }
      }
      .listStyle(.insetGrouped)
      .navigationTitle("Settings")
      .navigationDestination(for: Int.self) {
        switch $0 {
        case 0:
          VideoGamesView()
        case 1:
          LocationPreferenceView()
        case 2:
          RearrangeSectionsView()
        case 5:
          TipJarView()
        case 6:
          AboutView()
        default:
          EmptyView()
        }
      }
      .sheet(isPresented: $showingWhatsNewSheet) {
        OnboardingView(
          content: OnboardingContentService.createWhatsNewContent(),
          flowType: .appUpdate
        )
      }
      .alert("Log Out", isPresented: $showingLogOutAlert, actions: {
        Button("No", role: .cancel) { }
        Button("Yes") { logOut() }
      }, message: {
        Text("Are you sure you want to log out?")
      })
    }
  }
  
  private func settingsRowView(imageName: String) -> some View {
    Image(systemName: imageName)
      .foregroundColor(.red)
      .frame(width: 30 * scale, height: 30 * scale)
  }
  
  private func launchAppStoreReviewPage() {
    guard let url = URL(string: "https://apps.apple.com/app/id1576064097?action=write-review") else { return }
    UIApplication.shared.open(url)
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
    
    ImageService.clearCache()
    UserDefaults.standard.removeObject(forKey: Constants.accessTokenLastRefreshed)
    appRootManager.currentRoot = .login
  }
}

#Preview {
  SettingsView()
}
