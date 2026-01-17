import SwiftUI

struct StandingsView: View {
  @ObservedObject private var phaseGroupViewModel: PhaseGroupViewModel
  
  private let reloadPhaseGroup: (() -> Void)
  
  init(phaseGroupViewModel: PhaseGroupViewModel, reloadPhaseGroup: @escaping () -> Void) {
    self.phaseGroupViewModel = phaseGroupViewModel
    self.reloadPhaseGroup = reloadPhaseGroup
  }
  
  var body: some View {
    List {
      switch phaseGroupViewModel.state {
      case .uninitialized, .loading:
        ForEach(0..<20) { _ in
          Text("Standing Placeholder")
            .redacted(reason: .placeholder)
        }
      case .loaded(let phaseGroupDetails):
        if let standings = phaseGroupDetails?.standings, !standings.isEmpty {
          ForEach(standings, id: \.self) {
            StandingRowView(
              standing: $0,
              progressed: entrantProgressed(
                placement: $0.placement,
                progressionsOut: phaseGroupDetails?.progressionsOut
              )
            )
          }
          
          ForEach(phaseGroupViewModel.additionalStandings, id: \.self) {
            StandingRowView(
              standing: $0,
              progressed: entrantProgressed(
                placement: $0.placement,
                progressionsOut: phaseGroupDetails?.progressionsOut
              )
            )
          }
          
          if !phaseGroupViewModel.noMoreStandings {
            Text("Standing Placeholder")
              .redacted(reason: .placeholder)
              .onAppear {
                Task {
                  await phaseGroupViewModel.fetchAdditionalPhaseGroupStandings()
                }
              }
          }
        } else {
          ContentUnavailableView(
            "No Standings",
            systemImage: "questionmark.app.dashed",
            description: Text("There are currently no standings for this phase group.")
          )
        }
      case .error(let is503):
        ErrorStateView(is503: is503, subtitle: "There was an error loading this phase group.") {
          reloadPhaseGroup()
        }
      }
    }
    .listStyle(.insetGrouped)
  }
  
  private func entrantProgressed(placement: Int?, progressionsOut: Set<Int>?) -> Bool {
    guard let placement, let progressionsOut else { return false }
    return progressionsOut.contains(placement)
  }
}

#Preview {
  StandingsView(
    phaseGroupViewModel: PhaseGroupViewModel(
      phaseGroupID: 1,
      phaseID: 1,
      service: MockStartggService()
    ),
    reloadPhaseGroup: { }
  )
}
