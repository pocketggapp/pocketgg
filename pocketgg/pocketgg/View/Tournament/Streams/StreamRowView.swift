import SwiftUI

struct StreamRowView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let stream: Stream
  
  init(stream: Stream) {
    self.stream = stream
  }
  
  var body: some View {
    Button {
      openStream()
    } label: {
      ZStack {
        Color(UIColor.systemBackground)
        
        HStack {
          AsyncImageView(
            imageURL: stream.logoUrl ?? "",
            cornerRadius: 5,
            placeholderImageName: "play.tv"
          )
          .frame(width: 44 * scale, height: 44 * scale)
          .clipped()
          
          Text(stream.name ?? "")
            .font(.body)
          
          Spacer()
        }
      }
    }
    .buttonStyle(.plain)
  }
  
  private func openStream() {
    guard let streamName = stream.name, let streamSource = stream.source else { return }
    switch streamSource {
    case "TWITCH":
      guard let twitchURL = URL(string: "twitch://open") else { return }
      let url = UIApplication.shared.canOpenURL(twitchURL)
        ? URL(string: "twitch://stream/" + streamName)
        : URL(string: "https://www.twitch.tv/" + streamName)
      guard let url else { return }
      UIApplication.shared.open(url)
    case "YOUTUBE":
      guard let streamID = stream.streamID,
            let url = URL(string: "https://www.youtube.com/channel/" + streamID) else { return }
      UIApplication.shared.open(url)
    default:
      return
    }
  }
}

#Preview {
  StreamRowView(
    stream: Stream(
      name: "VGBootCamp",
      logoUrl: "https://static-cdn.jtvnw.net/jtv_user_pictures/vgbootcamp-profile_image-2d7c9dd9b19b8c44-300x300.png",
      source: "TWITCH",
      streamID: "61213141"
    )
  )
}
