import SwiftUI

struct TournamentOrganizerRowView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let tournamentOrganizer: Entrant
  
  init(tournamentOrganizer: Entrant) {
    self.tournamentOrganizer = tournamentOrganizer
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Tournament Organizer")
        .font(.title3.bold())
      
      NavigationLink(value: tournamentOrganizer) {
        ZStack {
          Color(UIColor.systemBackground)
          
          HStack {
            Image(systemName: "person")
              .resizable()
              .scaledToFit()
              .frame(width: 44 * scale, height: 44 * scale)
              .fontWeight(.light)
            
            organizerTextView
            
            Spacer()
            
            Image(systemName: "chevron.right")
              .foregroundStyle(.gray)
          }
        }
      }
      .buttonStyle(.plain)
    }
  }
  
  private var organizerTextView: some View {
    if let teamName = tournamentOrganizer.teamName {
      return Text("\(teamName) ").foregroundStyle(.gray) + Text(tournamentOrganizer.name ?? "")
    } else {
      return Text(tournamentOrganizer.name ?? "")
    }
  }
}

#Preview {
  TournamentOrganizerRowView(
    tournamentOrganizer: MockStartggService.createEntrant(id: 0)
  )
}
