import SwiftUI

struct HomeView: View {
  @StateObject private var viewModel: HomeViewModel
  
  init(service: StartggServiceType = StartggService.shared) {
    self._viewModel = StateObject(wrappedValue: {
      HomeViewModel(service: service)
    }())
  }

  var body: some View {
    NavigationStack(path: $viewModel.navigationPath) {
      ScrollView {
        LazyVStack(spacing: 32) {
          switch viewModel.state {
          case .uninitialized, .loading:
            ForEach(0..<3) { _ in
              TournamentsPlaceholderView()
            }
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
              subtitle: "Select video games in the app settings to see tournaments that feature those games."
            )
          case .error(let is503):
            ErrorStateView(is503: is503, subtitle: "There was an error loading your tournaments.") {
              Task {
                await viewModel.fetchTournaments(refreshed: true)
              }
            }
          }
        }
        .padding(.bottom)
      }
      .onReceive(NotificationCenter.default.publisher(for: Notification.Name(Constants.refreshHomeView))) { _ in
        viewModel.needsRefresh = true
      }
      .onAppear {
        viewModel.presentOnboardingViewIfNeeded()
      }
      .task {
        await viewModel.fetchTournaments()
      }
      .refreshable {
        await viewModel.fetchTournaments(refreshed: true)
      }
      .sheet(isPresented: $viewModel.showingOnboardingView, onDismiss: {
        Task {
          await viewModel.fetchTournaments()
        }
      }, content: {
        OnboardingView(
          content: viewModel.getOnboardingFlowType() == .newUser
            ? OnboardingContentService.createNewUserContent()
            : OnboardingContentService.createWhatsNewContent()
          ,
          flowType: viewModel.getOnboardingFlowType() ?? .appUpdate
        )
      })
      .navigationTitle("Tournaments")
      .navigationDestination(for: TournamentsGroup.self) {
        TournamentListView(
          title: $0.name,
          sectionID: $0.id
        )
      }
      .navigationDestination(for: Tournament.self) {
        TournamentView(tournament: $0)
      }
      .navigationDestination(for: Event.self) {
        EventView(event: $0)
      }
      .navigationDestination(for: Entrant.self) {
        UserTournamentListView(user: $0)
      }
      .onOpenURL { url in
        Task.detached(priority: .userInitiated) {
          await viewModel.getDeeplinkedTournament(url: url)
        }
      }
    }
  }
}

#Preview {
  HomeView(
    service: MockStartggService()
  )
}
