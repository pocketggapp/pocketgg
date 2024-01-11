import SwiftUI

struct HomeView: View {
  @StateObject private var viewModel: HomeViewModel
  @State private var showingEditView = false
  
  init(viewModel: HomeViewModel) {
    self._viewModel = StateObject(wrappedValue: { viewModel }())
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVStack(spacing: 32) {
          switch viewModel.state {
          case .uninitialized, .loading:
            LoadingView()
          case .loaded(let tournamentGroups):
            ForEach(tournamentGroups) { tournamentGroup in
              TournamentHorizontalListView(tournamentsGroup: tournamentGroup)
            }
          case .error(let error):
            Text(error)
          }
        }
      }
      .refreshable {
        await viewModel.fetchTournaments()
      }
      .navigationTitle("Tournaments")
      .navigationDestination(for: TournamentData.self) { tournament in
        EmptyView()
        TournamentView(
          viewModel: TournamentViewModel(
            tournamentData: tournament
          )
        )
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Edit") {
            showingEditView = true
          }
        }
      }
    }
    .onAppear {
      viewModel.onViewAppear()
    }
    .sheet(isPresented: $showingEditView) {
      print("EDIT HOME DISMISSED")
    } content: {
      EditHomeView()
    }
  }
}

#Preview {
  HomeView(viewModel: HomeViewModel(oAuthService: OAuthService()))
}
