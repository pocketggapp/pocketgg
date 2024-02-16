import SwiftUI

struct MatchesView: View {
  @Binding private var state: PhaseGroupViewState
  @Binding private var selectedMatch: PhaseGroupSet?
  
  private let reloadPhaseGroup: (() -> Void)
  
  init(
    state: Binding<PhaseGroupViewState>,
    selectedMatch: Binding<PhaseGroupSet?>,
    reloadPhaseGroup: @escaping () -> Void
  ) {
    self._state = state
    self._selectedMatch = selectedMatch
    self.reloadPhaseGroup = reloadPhaseGroup
  }
  
  var body: some View {
    List {
      switch state {
      case .uninitialized, .loading:
        ForEach(0..<10) { _ in
          MatchRowPlaceholderView()
        }
      case .loaded(let phaseGroupDetails):
        if let matches = phaseGroupDetails?.matches, !matches.isEmpty {
          ForEach(matches) { match in
            Button {
              selectedMatch = match
            } label: {
              MatchRowView(phaseGroupSet: match)
            }
            .buttonStyle(.plain)
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
    selectedMatch: .constant(nil),
    reloadPhaseGroup: { }
  )
}
