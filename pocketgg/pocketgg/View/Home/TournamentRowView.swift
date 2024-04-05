import SwiftUI

struct TournamentRowView: View {
  @ScaledMetric private var scale: CGFloat = 1
  @Environment(\.dynamicTypeSize) private var dynamicTypeSize
  
  private let tournament: Tournament
  
  init(tournament: Tournament) {
    self.tournament = tournament
  }
  
  var body: some View {
    let layout = dynamicTypeSize <= .accessibility2
      ? AnyLayout(HStackLayout(alignment: .top))
      : AnyLayout(VStackLayout(alignment: .leading))
    
    layout {
      AsyncImageView(
        imageURL: tournament.logoImageURL,
        cornerRadius: 10
      )
      .frame(width: 100 * scale, height: 100 * scale)
      .clipped()
      
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
  }
}

#Preview {
  TournamentRowView(
    tournament: MockStartggService.createTournament(id: 0)
  )
}
