import SwiftUI

struct ProfileHeaderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let profile: Profile
  
  init(profile: Profile) {
    self.profile = profile
  }
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      GeometryReader { proxy in
        AsyncBannerImageView(
          imageURL: profile.bannerImageURL,
          imageRatio: profile.bannerImageRatio
        )
        .frame(width: proxy.size.width, height: 150 * scale)
        .clipped()
      }
      
      VStack(alignment: .leading) {
        ZStack {
          RoundedRectangle(cornerRadius: 10)
            .fill(Color(uiColor: .systemBackground))
            .frame(width: 104 * scale, height: 104 * scale)
          
          // TODO: Figure out proper solution to crop image when newSize is passed in
          // Currently if a size with both width and height is passed in, the image loses its original aspect ratio and distorts
          AsyncImageView(
            imageURL: profile.profileImageURL,
            cornerRadius: 10,
            newSize: .init(width: 100, height: 0)
          )
          .frame(width: 100 * scale, height: 100 * scale)
          .clipped()
        }
        
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
  
  @ViewBuilder
  private func UserTextView() -> some View {
    if let name = profile.name {
      if let teamName = profile.teamName, !teamName.isEmpty {
        Text(teamName).foregroundStyle(.gray) + Text(" ") + Text(name)
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
