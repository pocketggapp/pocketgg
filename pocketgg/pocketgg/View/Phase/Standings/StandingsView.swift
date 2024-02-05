import SwiftUI

struct StandingsView: View {
  @Binding private var state: PhaseGroupViewState
  
  private let reloadPhaseGroup: (() -> Void)
  
  init(state: Binding<PhaseGroupViewState>, reloadPhaseGroup: @escaping () -> Void) {
    self._state = state
    self.reloadPhaseGroup = reloadPhaseGroup
  }
  
  var body: some View {
    List {
      switch state {
      case .uninitialized, .loading:
        ForEach(1..<20) { _ in
          Text("Standing Placeholder")
            .redacted(reason: .placeholder)
        }
      case .loaded(let phaseGroupDetails):
        if let standings = phaseGroupDetails?.standings, !standings.isEmpty {
          ForEach(standings) {
            StandingRowView(
              standing: $0,
              progressed: entrantProgressed(placement: $0.placement, progressionsOut: phaseGroupDetails?.progressionsOut)
            )
          }
        } else {
          EmptyStateView(
            systemImageName: "questionmark.app.dashed",
            title: "No Events",
            subtitle: "There are currently no standings for this phase group"
          )
        }
      case .error:
        ErrorStateView(subtitle: "There was an error loading this phase group") {
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
  // TODO: Complete
  let phaseGroupDetails = PhaseGroupDetails(
    bracketType: nil,
    progressionsOut: [],
    standings: [],
    matches: []
  )
  return StandingsView(
    state: .constant(.loaded(phaseGroupDetails)),
    reloadPhaseGroup: { }
  )
}
