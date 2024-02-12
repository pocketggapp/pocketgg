import SwiftUI

struct EliminationSetView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let phaseGroupSet: PhaseGroupSet
  
  init(phaseGroupSet: PhaseGroupSet) {
    self.phaseGroupSet = phaseGroupSet
  }
  
  var body: some View {
    ZStack(alignment: .leading) {
      VStack(alignment: .leading, spacing: 0) {
        HStack {
          getEntrantTextView(0)
            .font(phaseGroupSet.outcome == .entrant0Won ? .headline : .body)
          
          Spacer()
          
          getScoreTextView(0)
            .background(phaseGroupSet.outcome == .entrant0Won ? .green : .gray)
        }
        
        HStack {
          getEntrantTextView(1)
            .font(phaseGroupSet.outcome == .entrant1Won ? .headline : .body)
          
          Spacer()
          
          getScoreTextView(1)
            .background(phaseGroupSet.outcome == .entrant1Won ? .green : .gray)
        }
      }
      .padding(.leading, 15 * scale)
      .background(Color(uiColor: UIColor.secondarySystemBackground))
      .clipShape(RoundedRectangle(cornerRadius: 5))
      .padding(.leading, 12.5 * scale)
      .frame(width: 225 * scale)
      
      ZStack {
        Color(uiColor: UIColor.systemGray3)
        
        Text(phaseGroupSet.identifier)
          .foregroundColor(.white)
          .fixedSize()
      }
      .frame(width: 25 * scale, height: 25 * scale)
      .clipShape(RoundedRectangle(cornerRadius: 5))
    }
  }
  
  // MARK: Private Helpers
  
  @ViewBuilder
  private func getEntrantTextView(_ num: Int) -> some View {
    if let name = phaseGroupSet.entrants?[safe: num]?.entrant?.name {
      if let teamName = phaseGroupSet.entrants?[safe: num]?.entrant?.teamName {
        HStack(spacing: 5) {
          Text(teamName)
            .lineLimit(1)
            .foregroundColor(.gray)
            .frame(minWidth: 30 * scale)
          
          Text(name)
            .lineLimit(1)
            .layoutPriority(1)
        }
      } else {
        Text(name)
          .lineLimit(1)
      }
    } else {
      Text("_")
    }
  }
  
  private func getScoreTextView(_ num: Int) -> some View {
    Text(phaseGroupSet.entrants?[safe: num]?.score ?? "-")
      .lineLimit(1)
      .frame(minWidth: 30 * scale)
      .padding(.vertical, 5)
      .padding(.horizontal, 10)
      .foregroundColor(.white)
  }
}

#Preview {
  EliminationSetView(
    phaseGroupSet: MockStartggService.createPhaseGroupSet()
  )
}
