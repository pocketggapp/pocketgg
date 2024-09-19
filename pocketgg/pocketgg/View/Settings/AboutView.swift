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
              Text("by Gabriel Siu")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 5)
            }
          }
        }
        .listRowInsets(EdgeInsets())
      }
      
      Section {
        aboutRowView(
          text: "start.gg GraphQL API",
          url: "https://developer.start.gg/docs/intro",
          imageName: "server.rack"
        )
      }
      
      Section {
        aboutRowView(
          text: "Apollo iOS",
          url: "https://www.apollographql.com/docs/ios",
          imageName: "a.circle"
        )
      }
      
      Section {
        aboutRowView(
          text: "Website",
          url: "https://pocketggapp.github.io",
          imageName: "safari"
        )
        aboutRowView(
          text: "Roadmap",
          url: "https://github.com/orgs/pocketggapp/projects/1",
          imageName: "box.truck"
        )
        aboutRowView(
          text: "Privacy Policy",
          url: "https://pocketggapp.github.io/privacy",
          imageName: "hand.raised"
        )
      }
      
      Section {
        contactRowView(
          text: "Support",
          url: "mailto:pocketggapp@gmail.com?subject=pocketgg%20Support%20Request",
          imageName: "envelope.fill"
        )
        contactRowView(
          text: "@gabrielsiu_dev",
          url: "https://x.com/gabrielsiu_dev",
          imageName: "newspaper"
        )
      } header: {
        Text("Contact")
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
    return "version " + appVersion
  }
  
  private func aboutRowView(
    text: String,
    url: String,
    imageName: String
  ) -> some View {
    Button {
      openSFSafariVC(urlString: url)
    } label: {
      HStack {
        Image(systemName: imageName)
          .foregroundColor(.red)
          .frame(width: 30 * scale, height: 30 * scale)
        Text(text)
          .foregroundColor(Color(uiColor: .label))
      }
    }
  }
  
  private func contactRowView(
    text: String,
    url: String,
    imageName: String
  ) -> some View {
    Button {
      guard let url = URL(string: url) else { return }
      UIApplication.shared.open(url)
    } label: {
      HStack {
        Image(systemName: imageName)
          .foregroundColor(.red)
          .frame(width: 30 * scale, height: 30 * scale)
        Text(text)
          .foregroundColor(Color(uiColor: .label))
      }
    }
  }
}

#Preview {
  AboutView()
}
