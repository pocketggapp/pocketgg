import SwiftUI

struct HomeView: View {
  @StateObject private var viewModel: HomeViewModel
  @State private var showingEditView = false
  
  init(
    oAuthService: OAuthServiceType = OAuthService.shared,
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      HomeViewModel(oAuthService: oAuthService, service: service)
    }())
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVStack(spacing: 32) {
          switch viewModel.state {
          case .uninitialized, .loading:
            TournamentsPlaceholderView()
            TournamentsPlaceholderView()
            TournamentsPlaceholderView()
          case .loaded(let tournamentGroups):
            ForEach(tournamentGroups) { tournamentGroup in
              TournamentHorizontalListView(tournamentsGroup: tournamentGroup)
            }
          case .error(let error):
            Text(error)
          }
        }
      }
      .task {
        await viewModel.fetchTournaments()
      }
      .refreshable {
        await viewModel.fetchTournaments(refreshed: true)
      }
      .navigationTitle("Tournaments")
      .navigationDestination(for: Tournament.self) { tournament in
        TournamentView(
          tournament: tournament
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
    .sheet(isPresented: $showingEditView) {
      print("EDIT HOME DISMISSED")
    } content: {
      EditHomeView()
    }
  }
}

#Preview {
  HomeView(
    oAuthService: MockOAuthService(),
    service: MockStartggService()
  )
}
