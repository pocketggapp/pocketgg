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
            ForEach(tournamentGroups, id: \.id) {
              TournamentHorizontalListView(tournamentsGroup: $0) {
                Task {
                  await viewModel.fetchTournaments()
                }
              }
            }
          case .noSections:
            EmptyStateView(
              systemImageName: "questionmark.app.dashed",
              title: "No Video Games Enabled",
              subtitle: "Select video games in the app settings to see tournaments that feature those games"
            )
          case .error:
            ErrorStateView(subtitle: "There was an error loading your tournaments") {
              Task {
                await viewModel.fetchTournaments(refreshed: true)
              }
            }
          }
        }
      }
      .onReceive(NotificationCenter.default.publisher(for: Notification.Name(Constants.refreshHomeView))) { _ in
        viewModel.needsRefresh = true
      }
      .task {
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
      .navigationDestination(for: Tournament.self) {
        TournamentView(tournament: $0)
      }
      .navigationDestination(for: TournamentsGroup.self) {
        TournamentListView(
          title: $0.name,
          sectionID: $0.id
        )
      }
      .navigationDestination(for: Event.self) { event in
        EventView(event: event)
      }
      .navigationDestination(for: Entrant.self) {
        UserAdminTournamentListView(user: $0)
      }
    }
  }
}

#Preview {
  HomeView(
    service: MockStartggService()
  )
}
