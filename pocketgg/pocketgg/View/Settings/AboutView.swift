import SwiftUI
import SafariServices

struct AboutView: View {
  @ScaledMetric private var scale: CGFloat = 1
  @State private var imageFlipped = false
  
  var body: some View {
    List {
      Section {
        ZStack {
          Color(uiColor: .secondarySystemBackground)
          HStack {
            Image(imageFlipped ? "mang0" : "tournament-red")
              .resizable()
              .frame(width: 100, height: 100)
              .rotation3DEffect(.degrees(imageFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
              .onTapGesture { flipImage() }
            
            VStack(alignment: .leading) {
              Text("pocketgg")
                .font(.title.bold())
              Text(getAppVersionText())
            }
          }
        }
        .listRowInsets(EdgeInsets())
      }
      
      Section {
        Button {
          openSFSafariVC(urlString: "https://developer.start.gg/docs/intro")
        } label: {
          HStack {
            settingsRowView(imageName: "server.rack")
            Text("start.gg GraphQL API")
          }
        }
        .buttonStyle(.plain)
      }
      
      Section {
        Button {
          openSFSafariVC(urlString: "https://www.apollographql.com/docs/ios")
        } label: {
          HStack {
            settingsRowView(imageName: "a.circle")
            Text("Apollo iOS")
          }
        }
        .buttonStyle(.plain)
      }
      
      Section {
        Button {
          openSFSafariVC(urlString: "https://gabrielsiu.com/pocketgg")
        } label: {
          HStack {
            settingsRowView(imageName: "hand.raised")
            Text("Privacy Policy")
          }
        }
        .buttonStyle(.plain)
      }
    }
    .listStyle(.insetGrouped)
  }
  
  private func flipImage() {
    guard !imageFlipped else { return }
    
    withAnimation {
      imageFlipped = true
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      withAnimation {
        imageFlipped = false
      }
    }
  }
  
  private func openSFSafariVC(urlString: String) {
    guard let url = URL(string: urlString) else { return }
    UIApplication.shared.rootViewController?.present(SFSafariViewController(url: url), animated: true)
  }
  
  private func getAppVersionText() -> String {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? Constants.currentAppVersion
    return "Version " + appVersion
  }
  
  private func settingsRowView(imageName: String) -> some View {
    Image(systemName: imageName)
      .foregroundColor(.red)
      .frame(width: 30 * scale, height: 30 * scale)
  }
}

#Preview {
  AboutView()
}
