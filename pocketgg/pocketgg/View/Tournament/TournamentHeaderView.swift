import SwiftUI

struct TournamentHeaderView: View {
  @StateObject private var viewModel: TournamentHeaderViewModel
  
  init(viewModel: TournamentHeaderViewModel) {
    self._viewModel = StateObject(wrappedValue: { viewModel }())
  }
  
  var body: some View {
    HStack(alignment: .top) {
      AsyncImage(url: URL(string: viewModel.imageURL)) {
        $0.resizable()
          .aspectRatio(1, contentMode: .fit)
      } placeholder: {
        ProgressView()
          .frame(width: 100, height: 100)
      }
      .frame(width: 100, height: 100)
      .cornerRadius(10)
      
      VStack(alignment: .leading, spacing: 5) {
        Text(viewModel.name)
          .font(.headline)
        
        HStack {
          Image(systemName: "calendar")
          Text(viewModel.date)
        }
        
        HStack {
          Image(systemName: "mappin.and.ellipse")
          locationView()
        }
      }
    }
    .padding()
  }
  
  @ViewBuilder
  private func locationView() -> some View {
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
