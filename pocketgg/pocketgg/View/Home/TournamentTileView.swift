import SwiftUI

struct TournamentTileView: View {
  var imageURL: String?
  var name: String?
  var date: String?
  
  @ScaledMetric private var scale: CGFloat = 1
  
  var body: some View {
    VStack(alignment: .leading) {
      AsyncImageView(
        imageURL: imageURL,
        cornerRadius: 10
      )
      .frame(width: 150 * scale, height: 150 * scale)
      .clipped()
      
      Text(name ?? "")
        .font(.headline)
        .lineLimit(2)
        .multilineTextAlignment(.leading)
      
      Text(date ?? "")
        .font(.subheadline)
        .multilineTextAlignment(.leading)
    }
    .aspectRatio(0.6, contentMode: .fit)
    .frame(width: 150 * scale)
  }
}

#Preview {
  TournamentTileView(
    imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTySOlAWdNB8bEx9-r6y9ZK8rco9ptzwHUzm2XcNI0gcQ&s",
    name: "Genesis 5",
    date: "Jul 21 - Jul 23, 2023"
  )
}
