import SwiftUI

struct MatchRowView: View {
  private let phaseGroupSet: PhaseGroupSet
  
  init(phaseGroupSet: PhaseGroupSet) {
    self.phaseGroupSet = phaseGroupSet
  }
  
  var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading) {
          Text(phaseGroupSet.fullRoundText ?? "")
            .font(.headline)
          
          SubtitleTextView
        }
        Spacer()
      }
      .padding(.bottom)
      
      HStack {
        getEntrantTextView(0)
          .font(phaseGroupSet.outcome == .entrant0Won ? .headline : .body)
          .frame(maxWidth: .infinity)
        
        Text("vs.")
        
        getEntrantTextView(1)
          .font(phaseGroupSet.outcome == .entrant1Won ? .headline : .body)
          .frame(maxWidth: .infinity)
      }
      
      HStack {
        getScoreTextView(0)
          .font(phaseGroupSet.outcome == .entrant0Won ? .headline : . body)
          .foregroundColor(phaseGroupSet.outcome == .entrant0Won ? .green : .primary)
        
        Text("-")
        
        getScoreTextView(1)
          .font(phaseGroupSet.outcome == .entrant1Won ? .headline : .body)
          .foregroundColor(phaseGroupSet.outcome == .entrant1Won ? .green : .primary)
      }
    }
  }
  
  // MARK: Private Helpers
  
  private func getEntrantTextView(_ num: Int) -> some View {
    guard let name = phaseGroupSet.entrants?[safe: num]?.entrant?.name else {
      return Text("_")
    }
    var nameAndSeed = name
    if let seedNum = phaseGroupSet.entrants?[safe: num]?.seedNum {
      nameAndSeed += " (\(seedNum))"
    }
    if let teamName = phaseGroupSet.entrants?[safe: num]?.entrant?.teamName {
      return Text("\(teamName) ").foregroundColor(.gray) + Text(nameAndSeed)
    } else {
      return Text(nameAndSeed)
    }
  }
  
  private func getScoreTextView(_ num: Int) -> some View {
    Text(phaseGroupSet.entrants?[safe: num]?.score ?? "_")
  }
  
  private var SubtitleTextView: some View {
    switch phaseGroupSet.state {
    case .active:
      return Text("● ").foregroundColor(.green)
        + Text("Match \(phaseGroupSet.identifier) • \(phaseGroupSet.state.rawValue.localizedCapitalized)")
        .font(.subheadline)
    case .called:
      return Text("● ").foregroundColor(.yellow)
        + Text("Match \(phaseGroupSet.identifier) • \(phaseGroupSet.state.rawValue.localizedCapitalized)")
        .font(.subheadline)
    default:
      return Text("Match \(phaseGroupSet.identifier) • \(phaseGroupSet.state.rawValue.localizedCapitalized)")
        .font(.subheadline)
    }
  }
}

#Preview {
  MatchRowView(
    phaseGroupSet: MockStartggService.createPhaseGroupSet()
  )
}
