import SwiftUI

struct TournamentTileView: View {
  var imageURL: String
  var name: String
  var date: String
  
  var body: some View {
    VStack(alignment: .leading) {
      AsyncImage(url: URL(string: imageURL)) {
        $0.resizable()
          .aspectRatio(contentMode: .fit)
      } placeholder: {
        ProgressView()
      }
      .cornerRadius(15)
      
      Text(name)
        .font(.headline)
        .lineLimit(2)
      
      Text(date)
        .font(.subheadline)
    }
    .foregroundColor(.primary)
    .border(.green)
  }
}

#Preview {
  TournamentTileView(
    imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTySOlAWdNB8bEx9-r6y9ZK8rco9ptzwHUzm2XcNI0gcQ&s",
    name: "Genesis 5",
    date: "Jul 21 - Jul 23, 2023"
  )
}
