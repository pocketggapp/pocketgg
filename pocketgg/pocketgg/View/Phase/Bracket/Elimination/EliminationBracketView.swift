import SwiftUI

struct EliminationBracketView: View {
  @Binding private var selectedSet: PhaseGroupSet?
  
  private let phaseGroupSets: [PhaseGroupSet]
  private let roundLabels: [PhaseGroupDetails.RoundLabel]
  private let phaseGroupSetRounds: [Int: Int]
  
  init(
    selectedSet: Binding<PhaseGroupSet?>,
    phaseGroupSets: [PhaseGroupSet],
    roundLabels: [PhaseGroupDetails.RoundLabel],
    phaseGroupSetRounds: [Int : Int]
  ) {
    self._selectedSet = selectedSet
    self.roundLabels = roundLabels
    self.phaseGroupSetRounds = phaseGroupSetRounds
    
    // First sort the sets by the number of characters in their identifier
    // Then sort the the sets by their identifier's alphabetical order
    self.phaseGroupSets = phaseGroupSets.sorted {
      if $0.identifier.count != $1.identifier.count {
        return $0.identifier.count < $1.identifier.count
      } else {
        return $0.identifier < $1.identifier
      }
    }
  }
  
  var body: some View {
    ScrollViewWrapper {
      EliminationBracketLayout {
        ForEach(phaseGroupSets) { phaseGroupSet in
          EliminationSetView(phaseGroupSet: phaseGroupSet)
            .onTapGesture {
              selectedSet = phaseGroupSet
            }
            .layoutValue(key: PhaseGroupSetValue.self, value: phaseGroupSet)
        }
        ForEach(roundLabels, id: \.id) {
          EliminationRoundLabelView(roundLabel: $0)
            .layoutValue(key: PhaseGroupRoundLabel.self, value: $0)
        }
        ForEach(phaseGroupSets) {
          SetPathView(for: $0, phaseGroupSetRounds: phaseGroupSetRounds)
            .layoutValue(key: PhaseGroupSetPathID.self, value: $0.id)
        }
      }
    }
  }
  
  @ViewBuilder
  private func SetPathView(for set: PhaseGroupSet, phaseGroupSetRounds: [Int: Int]) -> some View {
    let round1Num = phaseGroupSetRounds[set.prevRoundIDs[0]]
    let round2Num = phaseGroupSetRounds[set.prevRoundIDs[1]]
    
    // 2 preceding sets
    if let round1Num, let round2Num {
      // No SetPathView if both preceding sets are in a different section than the current set
      if round1Num * round2Num > 0, set.roundNum * round1Num < 0 {
        EmptyView()
      }
      // Single line SetPathView if 1 of the 2 preceding sets is in a different section than the current set,
      // or if both preceding sets are the same set
      else if set.roundNum * round1Num < 0 || set.roundNum * round2Num < 0 || set.prevRoundIDs[0] == set.prevRoundIDs[1]{
        EliminationSetPathView(numPrecedingSets: 1)
          .stroke(style: .init(lineWidth: 3, lineCap: .round))
          .fill(Color(uiColor: UIColor.systemGray3))
      } else {
        EliminationSetPathView(numPrecedingSets: 2)
          .stroke(style: .init(lineWidth: 3, lineCap: .round))
          .fill(Color(uiColor: UIColor.systemGray3))
      }
    }
    // 1 or 0 preceding sets
    else {
      // Single line SetPathView, but only if the preceding set is in the same section as the current set
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
    selectedSet: .constant(nil),
    phaseGroupSets: [MockStartggService.createPhaseGroupSet()],
    roundLabels: [],
    phaseGroupSetRounds: [:]
  )
}
