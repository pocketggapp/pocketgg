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
        imageRatio: tournament.bannerImageRatio,
        placeholderImageName: "trophy.fill"
      )
      .frame(width: 250 * scale, height: 125 * scale)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      
      VStack(alignment: .leading, spacing: 5) {
        Text(tournament.name ?? "")
          .font(.headline)
          .lineLimit(1)
        
        HStack {
          Image(systemName: "calendar")
          Text(tournament.date ?? "")
            .font(.subheadline)
            .lineLimit(1)
        }
        
        HStack {
          Image(systemName: "mappin.and.ellipse")
          Text(tournament.location)
            .font(.subheadline)
            .lineLimit(1)
        }
      }
    }
    .frame(width: 250 * scale)
  }
}

#Preview {
  TournamentTileView(
    tournament: MockStartggService.createTournament(id: 0)
  )
}
