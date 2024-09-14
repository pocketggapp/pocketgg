import SwiftUI

struct PhaseGroupView: View {
  @StateObject private var viewModel: PhaseGroupViewModel
  @State private var selected = 0
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
    self.phaseGroup = phaseGroup
    self.title = title
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Divider()
      
      InlineTabsView(
        tabIndex: $selected,
        models: [
          .init(title: "Standings"),
          .init(title: "Matches"),
          .init(title: "Bracket")
        ]
      )
      
      ZStack {
        StandingsView(phaseGroupViewModel: viewModel) {
          reloadPhaseGroup()
        }
        .opacity(selected == 0 ? 1 : 0)
        MatchesView(state: $viewModel.state, selectedMatch: $selectedPhaseGroupSet) {
          reloadPhaseGroup()
        }
        .opacity(selected == 1 ? 1 : 0)
        BracketView(state: $viewModel.state, selectedSet: $selectedPhaseGroupSet) {
          reloadPhaseGroup()
        }
        .opacity(selected == 2 ? 1 : 0)
      }
      .refreshable {
        reloadPhaseGroup()
      }
    }
    .task {
      if phaseGroup == nil {
        await viewModel.fetchSinglePhaseGroup()
      } else {
        await viewModel.fetchPhaseGroup()
      }
    }
    .toolbar {
      if selected == 2 {
        ToolbarItemGroup(placement: .topBarTrailing) {
          Button {
            reloadPhaseGroup()
          } label: {
            Text("Refresh")
          }
        }
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
        PhaseGroupSetView(id: set.id)
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
