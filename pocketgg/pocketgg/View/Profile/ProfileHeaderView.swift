import SwiftUI

struct ProfileHeaderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let profile: Profile
  
  init(profile: Profile) {
    self.profile = profile
  }
  
  var body: some View {
    GeometryReader { proxy in
      ZStack(alignment: .topLeading) {
        AsyncBannerImageView(
          imageURL: profile.bannerImageURL,
          imageRatio: profile.bannerImageRatio
        )
        .frame(width: proxy.size.width, height: 150 * scale)
        .clipped()
        
        VStack(alignment: .leading) {
          AsyncImageView(
            imageURL: profile.profileImageURL,
            cornerRadius: 10
          )
          .frame(width: 100 * scale, height: 100 * scale)
          .clipped()
          .overlay(
            RoundedRectangle(cornerRadius: 10)
              .stroke(Color(uiColor: .systemBackground), lineWidth: 2)
          )
          
          VStack(alignment: .leading, spacing: 5) {
            UserTextView()
              .font(.title2.bold())
            
            Text(profile.bio ?? "")
          }
        }
        .padding(.top, 100 * scale)
        .padding(.leading, 16)
      }
    }
  }
  
  @ViewBuilder
  private func UserTextView() -> some View {
    if let name = profile.name {
      if let teamName = profile.teamName {
        Text(teamName).foregroundColor(.gray) + Text(" ") + Text(name)
      } else {
        Text(name)
      }
    } else {
      Text("Guest")
    }
  }
}

#Preview {
  ProfileHeaderView(
    profile: MockStartggService.createProfile()
  )
}
