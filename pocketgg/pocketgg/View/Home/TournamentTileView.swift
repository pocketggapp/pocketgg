import SwiftUI

struct TournamentTileView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let tournament: Tournament
  
  init(tournament: Tournament) {
    self.tournament = tournament
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      AsyncBannerImageView(
        imageURL: tournament.bannerImageURL,
        imageRatio: tournament.bannerImageRatio
      )
      .frame(width: 300 * scale, height: 175 * scale)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      
      VStack(alignment: .leading, spacing: 5) {
        Text(tournament.name ?? "")
          .font(.title2.bold())
          .lineLimit(1)
        
        HStack {
          Image(systemName: "calendar")
          Text(tournament.date ?? "")
            .lineLimit(1)
        }
        
        HStack {
          Image(systemName: "mappin.and.ellipse")
          Text(tournament.location)
            .lineLimit(1)
        }
      }
    }
    .frame(width: 300 * scale)
  }
}

#Preview {
  TournamentTileView(
    tournament: MockStartggService.createTournament(id: 0)
  )
}
