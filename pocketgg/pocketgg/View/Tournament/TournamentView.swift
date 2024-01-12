import SwiftUI

struct TournamentView: View {
  @StateObject private var viewModel: TournamentViewModel
  @State private var selected: String
  
  init(viewModel: TournamentViewModel) {
    self._viewModel = StateObject(wrappedValue: { viewModel }())
    self.selected = "Events"
  }
  
  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading) {
        TournamentHeaderView(
          viewModel: TournamentHeaderViewModel(
            id: viewModel.tournamentData.id,
            name: viewModel.tournamentData.name,
            imageURL: viewModel.tournamentData.imageURL,
            date: viewModel.tournamentData.date
          )
        )
        .padding()
        
        SegmentedControlView(selected: $selected, sections: ["Events", "Streams", "Location", "Contact Info"])
        
        switch selected {
        case "Events":
          VStack {
            EventPlaceholderView()
            EventPlaceholderView()
            EventPlaceholderView()
            EventPlaceholderView()
            EventPlaceholderView()
          }
          .padding()
        case "Streams":
          Color.blue
        case "Location":
          Color.green
        case "Contact Info":
          Color.purple
        default:
          EmptyView()
        }
      }
    }
    .navigationTitle(viewModel.tournamentData.name)
  }
}

#Preview {
  let image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTySOlAWdNB8bEx9-r6y9ZK8rco9ptzwHUzm2XcNI0gcQ&s"
  let date = "Jul 21 - Jul 23, 2023"
  return TournamentView(
    viewModel: TournamentViewModel(
      tournamentData: TournamentData(id: 0, name: "Tournament 0", imageURL: image, date: date)
    )
  )
}
