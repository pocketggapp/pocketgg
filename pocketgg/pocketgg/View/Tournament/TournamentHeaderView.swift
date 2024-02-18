import SwiftUI

struct TournamentHeaderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let tournament: Tournament
  
  init(tournament: Tournament) {
    self.tournament = tournament
  }
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      GeometryReader { proxy in
        AsyncBannerImageView(
          imageURL: tournament.bannerImageURL,
          imageRatio: tournament.bannerImageRatio
        )
        .frame(width: proxy.size.width, height: 150 * scale)
        .clipped()
      }
      
      VStack(alignment: .leading) {
        AsyncImageView(
          imageURL: tournament.logoImageURL,
          cornerRadius: 10
        )
        .frame(width: 100 * scale, height: 100 * scale)
        .clipped()
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(Color(uiColor: .systemBackground), lineWidth: 2)
        )
        
        VStack(alignment: .leading, spacing: 5) {
          Text(tournament.name ?? "")
            .font(.title2.bold())
            .lineLimit(3)
          
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
      .padding(.top, 100 * scale)
      .padding(.leading, 16)
    }
  }
}

#Preview {
  TournamentHeaderView(
    tournament: MockStartggService.createTournament(id: 0)
  )
}
