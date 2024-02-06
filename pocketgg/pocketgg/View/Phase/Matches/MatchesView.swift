import SwiftUI

struct MatchesView: View {
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
          Text("Match Placeholder")
            .redacted(reason: .placeholder)
        }
      case .loaded(let phaseGroupDetails):
        if let matches = phaseGroupDetails?.matches, !matches.isEmpty {
          ForEach(matches) {
            MatchRowView(phaseGroupSet: $0)
          }
        } else {
          EmptyStateView(
            systemImageName: "questionmark.app.dashed",
            title: "No Matches",
            subtitle: "There are currently no matches in this phase group"
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
}

#Preview {
  return MatchesView(
    state: .constant(.loaded(MockStartggService.createPhaseGroupDetails())),
    reloadPhaseGroup: { }
  )
}
