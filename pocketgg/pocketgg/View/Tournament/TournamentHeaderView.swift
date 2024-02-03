import SwiftUI

struct TournamentHeaderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let name: String?
  private let imageURL: String?
  private let date: String?
  private let location: String
  
  init(name: String?, imageURL: String?, date: String?, location: String) {
    self.name = name
    self.imageURL = imageURL
    self.date = date
    self.location = location
  }
  
  var body: some View {
    HStack(alignment: .top) {
      AsyncImageView(
        imageURL: imageURL,
        cornerRadius: 10
      )
      .frame(width: 100 * scale, height: 100 * scale)
      .clipped()
      
      VStack(alignment: .leading, spacing: 5) {
        Text(name ?? "")
          .font(.headline)
          .lineLimit(3)
        // TODO: Get best value for maxWidth that fixes context menu preview issue
          .frame(maxWidth: 300, alignment: .leading)
        
        HStack {
          Image(systemName: "calendar")
          Text(date ?? "")
        }
        
        HStack {
          Image(systemName: "mappin.and.ellipse")
          Text(location)
        }
      }
    }
  }
}

#Preview {
  TournamentHeaderView(
    name: "Genesis 4",
    imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTySOlAWdNB8bEx9-r6y9ZK8rco9ptzwHUzm2XcNI0gcQ&s",
    date: "Jul 21 - Jul 23, 2023",
    location: "San Jose, CA, US"
  )
}
