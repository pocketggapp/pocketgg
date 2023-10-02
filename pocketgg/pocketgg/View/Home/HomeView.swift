import SwiftUI

struct HomeView: View {
  @StateObject private var viewModel: HomeViewModel
  
  init(viewModel: HomeViewModel) {
    self._viewModel = StateObject(wrappedValue: { viewModel }())
  }

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
      .alert("Error", isPresented: $viewModel.showingAlert, actions: {}, message: {
        Text(viewModel.alertMessage)
      })
    }
    .onAppear {
      viewModel.onViewAppear()
    }
  }
}

#Preview {
  HomeView(viewModel: HomeViewModel(oAuthService: OAuthService()))
}
