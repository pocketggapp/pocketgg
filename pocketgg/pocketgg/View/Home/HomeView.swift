import SwiftUI

struct HomeView: View {
  @StateObject private var viewModel: HomeViewModel
  
  init(service: StartggServiceType = StartggService.shared) {
    self._viewModel = StateObject(wrappedValue: {
      HomeViewModel(service: service)
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
          case .error:
            EmptyView() // TODO: Home error view
          }
        }
      }
      .onReceive(NotificationCenter.default.publisher(for: Notification.Name(Constants.videoGamesChanged))) { _ in
        viewModel.videoGamesChanged = true
      }
      .task {
        // TODO: Refresh pinned tournaments, video games, without .uninitialzied check
        await viewModel.fetchTournaments()
      }
      .refreshable {
        await viewModel.fetchTournaments(refreshed: true)
      }
      .onAppear {
        viewModel.presentOnboardingViewIfNeeded()
      }
      .sheet(isPresented: $viewModel.showingOnboardingView) {
        OnboardingView(
          content: viewModel.getOnboardingFlowType() == .newUser
            ? OnboardingContentService.createNewUserContent()
            : OnboardingContentService.createWhatsNewContent()
          ,
          flowType: viewModel.getOnboardingFlowType() ?? .appUpdate
        )
      }
      .navigationTitle("Tournaments")
      .navigationDestination(for: Tournament.self) { tournament in
        TournamentView(
          tournament: tournament
        )
      }
    }
  }
}

#Preview {
  HomeView(
    service: MockStartggService()
  )
}
