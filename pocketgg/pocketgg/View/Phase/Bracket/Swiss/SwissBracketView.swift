import SwiftUI

struct SwissBracketView: View {
  @Binding private var selectedSet: PhaseGroupSet?
  @State private var selected: String
  
  private let phaseGroupSets: [PhaseGroupSet]
  private let rounds: [String]
  
  private var selectedRoundSets: [PhaseGroupSet] {
    phaseGroupSets.filter { selected == "Round \($0.roundNum)" }
  }
  
  init(
    selectedSet: Binding<PhaseGroupSet?>,
    phaseGroupSets: [PhaseGroupSet]
  ) {
    self._selectedSet = selectedSet
    
    // First sort the sets by the number of characters in their identifier
    // Then sort the the sets by their identifier's alphabetical order
    self.phaseGroupSets = phaseGroupSets.sorted {
      if $0.identifier.count != $1.identifier.count {
        return $0.identifier.count < $1.identifier.count
      } else {
        return $0.identifier < $1.identifier
      }
    }
    
    var roundNums = Set<Int>()
    for phaseGroupSet in phaseGroupSets {
      if !roundNums.contains(phaseGroupSet.roundNum) {
        roundNums.insert(phaseGroupSet.roundNum)
      }
    }
    let rounds = Array(roundNums).sorted().map { "Round \($0)" }
    self.rounds = rounds
    
    self._selected = State(initialValue: rounds.first ?? "")
  }
  
  var body: some View {
    VStack {
      HStack {
        Text("Round:")
          .font(.headline)
        Spacer()
        Picker("Round Number", selection: $selected) {
          ForEach(rounds, id: \.self) {
            Text($0)
          }
        }
      }
      .padding(.horizontal)
      
      List(selectedRoundSets, id: \.id) { phaseGroupSet in
        Button {
          selectedSet = phaseGroupSet
        } label: {
          MatchRowView(phaseGroupSet: phaseGroupSet)
        }
        .buttonStyle(.plain)
      }
      .listStyle(.insetGrouped)
    }
  }
}

#Preview {
  SwissBracketView(
    selectedSet: .constant(nil),
    phaseGroupSets: [MockStartggService.createPhaseGroupSet()]
  )
}
