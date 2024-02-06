import SwiftUI

struct TournamentTileView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let tournament: Tournament
  
  init(tournament: Tournament) {
    self.tournament = tournament
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      AsyncImageView(
        imageURL: tournament.imageURL,
        cornerRadius: 10
      )
      .frame(width: 150 * scale, height: 150 * scale)
      .clipped()
      
      Text(tournament.name ?? "")
        .font(.headline)
        .lineLimit(2)
        .multilineTextAlignment(.leading)
      
      Text(tournament.date ?? "")
        .font(.subheadline)
        .multilineTextAlignment(.leading)
    }
    .aspectRatio(0.6, contentMode: .fit)
    .frame(width: 150 * scale)
  }
}

#Preview {
  TournamentTileView(
    tournament: MockStartggService.createTournament(id: 0)
  )
}
