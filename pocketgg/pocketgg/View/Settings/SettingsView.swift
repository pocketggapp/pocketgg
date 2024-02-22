import SwiftUI

struct SettingsView: View {
  @EnvironmentObject private var appRootManager: AppRootManager
  @ScaledMetric private var scale: CGFloat = 1
  
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
          NavigationLink(value: 3) {
            HStack {
              settingsRowView(imageName: "safari")
              Text("Website")
            }
          }
          
          NavigationLink(value: 4) {
            HStack {
              settingsRowView(imageName: "box.truck")
              Text("Roadmap")
            }
          }
        }
        
        Section {
          NavigationLink(value: 5) {
            HStack {
              settingsRowView(imageName: "heart")
              Text("Tip Jar")
            }
          }
          
          NavigationLink(value: 6) {
            HStack {
              settingsRowView(imageName: "star")
              Text("Write a Review")
            }
          }
          
          NavigationLink(value: 7) {
            HStack {
              settingsRowView(imageName: "info.circle")
              Text("About")
            }
          }
        }
        
        Section {
          Button {
            logOut()
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
        case 7:
          AboutView()
        default:
          EmptyView()
        }
      }
    }
  }
  
  private func settingsRowView(imageName: String) -> some View {
    Image(systemName: imageName)
      .foregroundColor(.red)
      .frame(width: 30 * scale, height: 30 * scale)
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
  SettingsView()
}
