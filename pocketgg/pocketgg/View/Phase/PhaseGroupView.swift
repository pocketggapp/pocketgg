import SwiftUI

struct PhaseGroupView: View {
  @StateObject private var viewModel: PhaseGroupViewModel
  @State private var selected: String
  @State private var selectedPhaseGroupSet: PhaseGroupSet?
  
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
        phaseGroupID: phaseGroup?.id,
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
      
      ZStack {
        StandingsView(phaseGroupViewModel: viewModel) {
          reloadPhaseGroup()
        }
        .opacity(selected == "Standings" ? 1 : 0)
        MatchesView(state: $viewModel.state, selectedMatch: $selectedPhaseGroupSet) {
          reloadPhaseGroup()
        }
        .opacity(selected == "Matches" ? 1 : 0)
        BracketView(state: $viewModel.state, selectedSet: $selectedPhaseGroupSet) {
          reloadPhaseGroup()
        }
        .opacity(selected == "Bracket" ? 1 : 0)
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
    .sheet(item: $selectedPhaseGroupSet) { set in
      VStack(alignment: .trailing) {
        Button {
          selectedPhaseGroupSet = nil
        } label: {
          Text("Done")
            .font(.headline)
        }
        PhaseGroupSetView(phaseGroupSet: set)
      }
      .padding()
      .presentationDetents([.medium, .large])
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
