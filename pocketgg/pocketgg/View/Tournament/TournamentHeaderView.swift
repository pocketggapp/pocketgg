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
        ZStack {
          RoundedRectangle(cornerRadius: 10)
            .fill(Color(uiColor: .systemBackground))
            .frame(width: 104 * scale, height: 104 * scale)
          
          AsyncImageView(
            imageURL: tournament.logoImageURL,
            cornerRadius: 10,
            newSize: .init(width: 100, height: 100)
          )
          .frame(width: 100 * scale, height: 100 * scale)
          .clipped()
        }
        
        VStack(alignment: .leading, spacing: 5) {
          Text(tournament.name ?? "")
            .font(.title2.bold())
            .lineLimit(2)
          
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
