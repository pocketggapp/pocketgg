import SwiftUI

struct TournamentHeaderView: View {
  @StateObject private var viewModel: TournamentHeaderViewModel
  @ScaledMetric private var scale: CGFloat = 1
  
  init(viewModel: TournamentHeaderViewModel) {
    self._viewModel = StateObject(wrappedValue: { viewModel }())
  }
  
  var body: some View {
    HStack(alignment: .top) {
      AsyncImageView(imageURL: viewModel.imageURL)
        .frame(width: 100 * scale, height: 100 * scale)
        .cornerRadius(10)
        .clipped()
      
      VStack(alignment: .leading, spacing: 5) {
        Text(viewModel.name)
          .font(.headline)
        
        HStack {
          Image(systemName: "calendar")
          Text(viewModel.date)
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
    viewModel: TournamentHeaderViewModel(
      id: 0,
      name: "Genesis 4",
      imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTySOlAWdNB8bEx9-r6y9ZK8rco9ptzwHUzm2XcNI0gcQ&s",
      date: "Jul 21 - Jul 23, 2023"
    )
  )
}
