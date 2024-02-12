import SwiftUI

struct EliminationBracketView: View {
  @Binding private var state: PhaseGroupViewState
  
  private let reloadPhaseGroup: (() -> Void)
  
  init(state: Binding<PhaseGroupViewState>, reloadPhaseGroup: @escaping () -> Void) {
    self._state = state
    self.reloadPhaseGroup = reloadPhaseGroup
  }
  
  var body: some View {
    switch state {
    case .uninitialized, .loading:
      EmptyView()
    case .loaded(let phaseGroupDetails):
      if let sets = phaseGroupDetails?.matches, !sets.isEmpty {
        ScrollViewWrapper {
          EliminationBracketLayout {
            ForEach(sets) {
              EliminationSetView(phaseGroupSet: $0)
                .layoutValue(key: PhaseGroupSetValue.self, value: $0)
            }
            ForEach(phaseGroupDetails?.roundLabels ?? []) {
              EliminationRoundLabelView(roundLabel: $0)
                .layoutValue(key: PhaseGroupRoundLabel.self, value: $0)
            }
            ForEach(sets) {
              setPathView(for: $0, phaseGroupSetRounds: phaseGroupDetails?.phaseGroupSetRounds ?? [:])
                .layoutValue(key: PhaseGroupSetPathID.self, value: $0.id)
            }
          }
        }
      } else {
        EmptyStateView(
          systemImageName: "questionmark.app.dashed",
          title: "No Sets",
          subtitle: "There are currently no sets in this phase group"
        )
      }
    case .error:
      ErrorStateView(subtitle: "There was an error loading this phase group") {
        reloadPhaseGroup()
      }
    }
  }
  
  @ViewBuilder
  private func setPathView(for set: PhaseGroupSet, phaseGroupSetRounds: [Int: Int]) -> some View {
    if let round1Num = phaseGroupSetRounds[set.prevRoundIDs[0]],
       let round2Num = phaseGroupSetRounds[set.prevRoundIDs[1]] {
      
      if round1Num * round2Num > 0, set.prevRoundIDs[0] != set.prevRoundIDs[1] {
        EliminationSetPathView(numPrecedingSets: 2)
          .stroke(style: .init(lineWidth: 3, lineCap: .round))
          .fill(Color(uiColor: UIColor.systemGray3))
      } else {
        EliminationSetPathView(numPrecedingSets: 1)
          .stroke(style: .init(lineWidth: 3, lineCap: .round))
          .fill(Color(uiColor: UIColor.systemGray3))
      }
    } else {
      EmptyView()
    }
  }
}

#Preview {
  return EliminationBracketView(
    state: .constant(.loaded(MockStartggService.createPhaseGroupDetails())),
    reloadPhaseGroup: { }
  )
}
