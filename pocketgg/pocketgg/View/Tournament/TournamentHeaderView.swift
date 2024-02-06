import SwiftUI

struct TournamentHeaderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let tournament: Tournament
  
  init(tournament: Tournament) {
    self.tournament = tournament
  }
  
  var body: some View {
    HStack(alignment: .top) {
      AsyncImageView(
        imageURL: tournament.imageURL,
        cornerRadius: 10
      )
      .frame(width: 100 * scale, height: 100 * scale)
      .clipped()
      
      VStack(alignment: .leading, spacing: 5) {
        Text(tournament.name ?? "")
          .font(.headline)
          .lineLimit(3)
        // TODO: Get best value for maxWidth that fixes context menu preview issue
          .frame(maxWidth: 300, alignment: .leading)
        
        HStack {
          Image(systemName: "calendar")
          Text(tournament.date ?? "")
        }
        
        HStack {
          Image(systemName: "mappin.and.ellipse")
          Text(tournament.location)
        }
      }
    }
  }
}

#Preview {
  TournamentHeaderView(
    tournament: MockStartggService.createTournament(id: 0)
  )
}
