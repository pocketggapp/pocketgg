import SwiftUI

struct TournamentSearchView: View {
  @StateObject private var viewModel: TournamentSearchViewModel
  
  init(
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      TournamentSearchViewModel(service: service)
    }())
  }
  
  var body: some View {
    NavigationStack {
      List {
        Section {
          HStack {
            Image(systemName: "magnifyingglass")
              .foregroundColor(.gray)
            
            TextField("Search", text: $viewModel.searchText)
              .onSubmit {
                Task {
                  await viewModel.fetchTournaments(newSearch: true)
                }
              }
              .submitLabel(.search)
          }
        }
        
        switch viewModel.state {
        case .uninitialized:
          EmptyStateView(
            systemImageName: "magnifyingglass",
            title: "Search for Tournaments",
            subtitle: "Find tournaments by typing the name of a tournament and tapping search."
          )
        case .loading:
          ForEach(0..<20) { _ in
            TournamentRowPlaceholderView()
          }
        case .loaded(let tournaments):
          if !tournaments.isEmpty {
            ForEach(tournaments, id: \.id) { tournament in
              NavigationLink(value: tournament) {
                TournamentRowView(tournament: tournament)
              }
            }
            
            if !viewModel.noMoreTournaments {
              TournamentRowPlaceholderView()
                .onAppear {
                  Task {
                    await viewModel.fetchTournaments(getNextPage: true)
                  }
                }
            }
          } else {
            EmptyStateView(
              systemImageName: "magnifyingglass",
              title: "No Search Results",
              subtitle: "Check the spelling or try a new search."
            )
          }
        case .error(let is503):
          ErrorStateView(is503: is503, subtitle: "There was an error loading search results.") {
            Task {
              await viewModel.fetchTournaments(newSearch: true)
            }
          }
        }
      }
      .listStyle(.grouped)
      .scrollDismissesKeyboard(.immediately)
      .navigationDestination(for: Tournament.self) {
        TournamentView(tournament: $0)
      }
      .navigationDestination(for: Event.self) {
        EventView(event: $0)
      }
      .navigationDestination(for: Entrant.self) {
        UserTournamentListView(user: $0)
      }
      .navigationTitle("Search")
    }
  }
}

#Preview {
  TournamentSearchView()
}
