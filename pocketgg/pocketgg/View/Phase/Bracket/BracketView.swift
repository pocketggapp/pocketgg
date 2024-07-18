import SwiftUI

struct BracketView: View {
  @Binding private var state: PhaseGroupViewState
  @Binding private var selectedSet: PhaseGroupSet?
  
  private let reloadPhaseGroup: (() -> Void)
  
  init(
    state: Binding<PhaseGroupViewState>,
    selectedSet: Binding<PhaseGroupSet?>,
    reloadPhaseGroup: @escaping () -> Void
  ) {
    self._state = state
    self._selectedSet = selectedSet
    self.reloadPhaseGroup = reloadPhaseGroup
  }
  
  var body: some View {
    switch state {
    case .uninitialized, .loading:
      EmptyView() // TODO: Bracket loading placeholder view
    case .loaded(let phaseGroupDetails):
      if let sets = phaseGroupDetails?.matches, !sets.isEmpty {
        switch phaseGroupDetails?.bracketType {
        case .singleElimination, .doubleElimination:
          EliminationBracketView(
            selectedSet: $selectedSet,
            phaseGroupSets: sets,
            roundLabels: phaseGroupDetails?.roundLabels ?? [],
            phaseGroupSetRounds: phaseGroupDetails?.phaseGroupSetRounds ?? [:]
          )
        case .roundRobin:
          RoundRobinBracketView(
            selectedSet: $selectedSet,
            phaseGroupSets: sets,
            entrants: phaseGroupDetails?.standings.compactMap { $0.entrant } ?? []
          )
        case .swiss:
          SwissBracketView(
            selectedSet: $selectedSet,
            phaseGroupSets: sets
          )
        default:
          EmptyStateView(
            systemImageName: "questionmark.app.dashed",
            title: "Unsupported Bracket Type (\(phaseGroupDetails?.bracketType?.rawValue ?? ""))",
            subtitle: "This type of bracket is currently not supported."
          )
        }
      } else {
        EmptyStateView(
          systemImageName: "questionmark.app.dashed",
          title: "No Sets",
          subtitle: "There are currently no sets in this phase group."
        )
      }
    case .error:
      ErrorStateView(subtitle: "There was an error loading this bracket.") {
        reloadPhaseGroup()
      }
    }
  }
}

#Preview {
  return BracketView(
    state: .constant(.loaded(MockStartggService.createPhaseGroupDetails())),
    selectedSet: .constant(nil),
    reloadPhaseGroup: { }
  )
}
