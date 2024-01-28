import SwiftUI

struct TournamentHeaderView: View {
  @StateObject private var viewModel: TournamentHeaderViewModel
  @ScaledMetric private var scale: CGFloat = 1
  
  private let name: String
  private let imageURL: String
  private let date: String
  
  init(id: Int, name: String, imageURL: String, date: String) {
    self.name = name
    self.imageURL = imageURL
    self.date = date
    self._viewModel = StateObject(wrappedValue: {
      TournamentHeaderViewModel(id: id)
    }())
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
        Text(name)
          .font(.headline)
          .lineLimit(3)
        // TODO: Get best value for maxWidth that fixes context menu preview issue
          .frame(maxWidth: 300, alignment: .leading)
        
        HStack {
          Image(systemName: "calendar")
          Text(date)
        }
        
        HStack {
          Image(systemName: "mappin.and.ellipse")
          locationView
        }
      }
    }
  }
  
  @ViewBuilder
  private var locationView: some View {
    if let location = viewModel.location {
      Text(location)
    } else {
      Text("Somewhere, Earth")
        .redacted(reason: .placeholder)
    }
  }
}

#Preview {
  TournamentHeaderView(
    id: 0,
    name: "Genesis 4",
    imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTySOlAWdNB8bEx9-r6y9ZK8rco9ptzwHUzm2XcNI0gcQ&s",
    date: "Jul 21 - Jul 23, 2023"
  )
}
