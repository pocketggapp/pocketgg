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
    let round1Num = phaseGroupSetRounds[set.prevRoundIDs[0]]
    let round2Num = phaseGroupSetRounds[set.prevRoundIDs[1]]
    
    // 2 preceding sets
    if let round1Num, let round2Num {
      // SetPathView branches only if:
      // 1. 2 preceding sets exist
      // 2. The 2 preceding sets are in the same section of the bracket
      // 3. The 2 preceding sets are not the same set
      if round1Num * round2Num > 0, set.prevRoundIDs[0] != set.prevRoundIDs[1] {
        EliminationSetPathView(numPrecedingSets: 2)
          .stroke(style: .init(lineWidth: 3, lineCap: .round))
          .fill(Color(uiColor: UIColor.systemGray3))
      // If 2 preceding sets exist, there is no SetPathView if the 2 preceding sets are in a different section than the current set
      } else if round1Num * round2Num > 0, set.roundNum * round1Num < 0 {
        EmptyView()
      } else {
        EliminationSetPathView(numPrecedingSets: 1)
          .stroke(style: .init(lineWidth: 3, lineCap: .round))
          .fill(Color(uiColor: UIColor.systemGray3))
      }
    }
    // 1 or 0 preceding sets
    else {
      if let round1Num, round1Num * set.roundNum > 0 {
        EliminationSetPathView(numPrecedingSets: 1)
          .stroke(style: .init(lineWidth: 3, lineCap: .round))
          .fill(Color(uiColor: UIColor.systemGray3))
      } else if let round2Num, round2Num * set.roundNum > 0 {
        EliminationSetPathView(numPrecedingSets: 1)
          .stroke(style: .init(lineWidth: 3, lineCap: .round))
          .fill(Color(uiColor: UIColor.systemGray3))
      } else {
        EmptyView()
      }
    }
  }
}

#Preview {
  return EliminationBracketView(
    state: .constant(.loaded(MockStartggService.createPhaseGroupDetails())),
    reloadPhaseGroup: { }
  )
}
