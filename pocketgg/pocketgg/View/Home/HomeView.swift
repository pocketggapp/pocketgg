import SwiftUI

struct HomeView: View {
  @StateObject private var viewModel = HomeViewModel()

  var body: some View {
    NavigationStack {
      List {
        ForEach(viewModel.tournamentGroups) { tournamentGroup in
          Section(tournamentGroup.name) {
            TournamentHorizontalListView(tournaments: tournamentGroup.tournaments)
              .listRowInsets(EdgeInsets())
          }
        }
      }
      .listStyle(.grouped)
      .navigationTitle("Tournaments")
      .navigationDestination(for: TournamentData.self) { tournament in
        EmptyView()
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
