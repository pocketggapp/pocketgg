import SwiftUI

struct PhaseGroupView: View {
  @StateObject private var viewModel: PhaseGroupViewModel
  @State private var selected: String
  
  private let phaseGroup: PhaseGroup?
  private let title: String
  
  init(
    phaseGroup: PhaseGroup?,
    phaseID: Int?,
    title: String,
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      PhaseGroupViewModel(
        phaseGroup: phaseGroup,
        phaseID: phaseID,
        service: service
      )
    }())
    self._selected = State(initialValue: "Standings")
    self.phaseGroup = phaseGroup
    self.title = title
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      SegmentedControlView(
        selected: $selected,
        sections: ["Standings", "Matches", "Bracket"]
      )
      
      switch selected {
      case "Standings":
        StandingsView(state: $viewModel.state) {
          reloadPhaseGroup()
        }
      case "Matches":
        MatchesView(state: $viewModel.state) {
          reloadPhaseGroup()
        }
      case "Bracket":
        BracketView(state: $viewModel.state) {
          reloadPhaseGroup()
        }
      default:
        EmptyView()
      }
    }
    .task {
      if phaseGroup == nil {
        await viewModel.fetchSinglePhaseGroup()
      } else {
        await viewModel.fetchPhaseGroup()
      }
    }
    .refreshable {
      if phaseGroup == nil {
        await viewModel.fetchSinglePhaseGroup(refreshed: true)
      } else {
        await viewModel.fetchPhaseGroup(refreshed: true)
      }
    }
    .navigationTitle(title)
  }
  
  // MARK: Reload Phase Group
  
  private func reloadPhaseGroup() {
    Task {
      if phaseGroup == nil {
        await viewModel.fetchSinglePhaseGroup(refreshed: true)
      } else {
        await viewModel.fetchPhaseGroup(refreshed: true)
      }
    }
  }
}

#Preview {
  PhaseGroupView(
    phaseGroup: MockStartggService.createPhaseGroup(),
    phaseID: nil,
    title: "Top 8",
    service: MockStartggService()
  )
}
