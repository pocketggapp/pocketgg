import SwiftUI
import MapKit

struct TournamentView: View {
  @StateObject private var viewModel: TournamentViewModel
  @State private var selected: String
  
  private let tournament: Tournament
  
  init(
    tournament: Tournament,
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      TournamentViewModel(
        tournament: tournament,
        service: service
      )
    }())
    self._selected = State(initialValue: "Events")
    self.tournament = tournament
  }
  
  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading) {
        TournamentHeaderView(tournament: tournament)
        
        SegmentedControlView(
          selected: $selected,
          sections: ["Events", "Streams", "Location", "Info"]
        )
        
        switch selected {
        case "Events":
          EventsView(state: $viewModel.state) {
            reloadTournament()
          }
        case "Streams":
          StreamsView(state: $viewModel.state) {
            reloadTournament()
          }
        case "Location":
          LocationView(state: $viewModel.state, tournamentID: tournament.id) {
            reloadTournament()
          }
        case "Info":
          InfoView(state: $viewModel.state) {
            reloadTournament()
          }
        default:
          EmptyView()
        }
      }
    }
    .onAppear {
      viewModel.resetHomeViewRefreshNotification()
    }
    .task {
      await viewModel.fetchTournament()
    }
    .refreshable {
      await viewModel.fetchTournament(refreshed: true)
    }
    .sheet(isPresented: $viewModel.showingAddToCalendarView) {
      AddToCalendarView(eventStore: viewModel.eventStore, event: viewModel.event)
    }
    .toolbar {
      ToolbarItemGroup(placement: .topBarTrailing) {
        Menu {
          Button {
            viewModel.toggleTournamentPinStatus()
          } label: {
            Label(
              viewModel.isPinned ? "Unpin" : "Pin",
              systemImage: viewModel.isPinned ? "pin.slash.fill" : "pin.fill"
            )
          }
          
          Button {
            Task {
              await viewModel.addTournamentToCalendar()
            }
          } label: {
            Label("Add to calendar", systemImage: "calendar.badge.plus")
          }
          
          if let tournamentURL = viewModel.tournamentURL {
            ShareLink(item: tournamentURL)
          }
        } label: {
          Image(systemName: "ellipsis.circle")
        }
      }
    }
    .navigationTitle(tournament.name ?? "")
    .alert("Error", isPresented: $viewModel.showingCalendarErrorAlert, actions: {
      Button("OK", role: .cancel) {}
    }, message: {
      Text("There was an error requesting access to your calendar. To add this tournament to your calendar, please go to Privacy Settings and grant pocketgg access to your calendar.")
    })
  }
  
  // MARK: Reload Tournament
  
  private func reloadTournament() {
    Task {
      await viewModel.fetchTournament(refreshed: true)
    }
  }
}

#Preview {
  return TournamentView(
    tournament: MockStartggService.createTournament(id: 0),
    service: MockStartggService()
  )
}
