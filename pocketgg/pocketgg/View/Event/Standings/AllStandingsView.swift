import SwiftUI

struct AllStandingsView: View {
  @StateObject private var viewModel: AllStandingsViewModel
  private let eventID: Int
  
  init(
    eventID: Int,
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      AllStandingsViewModel(
        eventID: eventID,
        service: service
      )
    }())
    self.eventID = eventID
  }
  
  var body: some View {
    List {
      switch viewModel.state {
      case .uninitialized, .loading:
        ForEach(0..<20) { _ in
          Text("Standing Placeholder")
            .redacted(reason: .placeholder)
        }
      case .loaded(let standings):
        ForEach(standings, id: \.self) {
          AllStandingRowView(standing: $0)
        }
        
        if !viewModel.noMoreStandings {
          Text("Standing Placeholder")
            .redacted(reason: .placeholder)
            .onAppear {
              Task {
                await viewModel.fetchStandings(getNextPage: true)
              }
            }
        }
      case .error(let is503):
        ErrorStateView(is503: is503, subtitle: "There was an error loading this event.") {
          Task {
            await viewModel.fetchStandings(refreshed: true)
          }
        }
      }
    }
    .task {
      await viewModel.fetchStandings()
    }
    .refreshable {
      await viewModel.fetchStandings(refreshed: true)
    }
    .listStyle(.insetGrouped)
    .navigationTitle("Standings")
  }
}

#Preview {
  AllStandingsView(
    eventID: 1,
    service: MockStartggService()
  )
}
