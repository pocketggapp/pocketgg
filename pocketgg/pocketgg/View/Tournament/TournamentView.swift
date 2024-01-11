import SwiftUI

struct TournamentView: View {
  @StateObject private var viewModel: TournamentViewModel
  
  init(viewModel: TournamentViewModel) {
    self._viewModel = StateObject(wrappedValue: { viewModel }())
  }
  
  var body: some View {
    List {
      Section {
        TournamentHeaderView(
          viewModel: TournamentHeaderViewModel(
            id: viewModel.tournamentData.id,
            name: viewModel.tournamentData.name,
            imageURL: viewModel.tournamentData.imageURL,
            date: viewModel.tournamentData.date
          )
        )
      }
      
      Section {
        switch viewModel.state {
        case .uninitialized, .loading:
          EventPlaceholderView()
          EventPlaceholderView()
          EventPlaceholderView()
        case .loaded(let tournamentDetails):
          EmptyView()
        case .error(let string):
          EmptyView()
        }
      } header: {
        Text("Events")
      }
      
      Section {
        Text("hi hand 1")
      } header: {
        Text("Streams")
      }
      
      Section {
        Text("hi hand 1")
      } header: {
        Text("Location")
      }
      
      Section {
        Text("hi hand 1")
      } header: {
        Text("Contact Info")
      }
    }
    .listStyle(.grouped)
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
