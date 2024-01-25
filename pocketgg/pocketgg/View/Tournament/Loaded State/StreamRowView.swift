import SwiftUI

struct StreamRowView: View {
  @ScaledMetric private var scale: CGFloat = 1
  private let stream: Stream
  
  init(stream: Stream) {
    self.stream = stream
  }
  
  var body: some View {
    ZStack {
      Color(UIColor.systemBackground)
      
      HStack {
        AsyncImageView(
          imageURL: stream.logoUrl ?? "",
          cornerRadius: 5
        )
        .frame(width: 44 * scale, height: 44 * scale)
        .clipped()
        
        Text(stream.name ?? "")
          .font(.body)
        
        Spacer()
      }
    }
  }
}

#Preview {
  StreamRowView(
    stream: Stream(
      name: "VGBootCamp",
      logoUrl: "https://static-cdn.jtvnw.net/jtv_user_pictures/vgbootcamp-profile_image-2d7c9dd9b19b8c44-300x300.png",
      sourceUrl: "TWITCH"
    )
  )
}
