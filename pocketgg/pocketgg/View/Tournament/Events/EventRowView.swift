import SwiftUI

struct EventRowView: View {
  @ScaledMetric private var scale: CGFloat = 1
  private var event: Event
  
  init(event: Event) {
    self.event = event
  }
  
  var body: some View {
    ZStack {
      Color(UIColor.systemBackground)
      
      HStack {
        AsyncImageView(
          imageURL: event.videogameImage ?? "",
          cornerRadius: 5
        )
        .frame(width: 33 * scale, height: 44 * scale)
        .clipped()
        
        VStack(alignment: .leading) {
          Text(event.name ?? "")
            .font(.body)
          
          subtitleTextView
            .font(.caption)
        }
        
        Spacer()
        
        Image(systemName: "chevron.right")
          .foregroundColor(.gray)
      }
    }
  }
  
  private var subtitleTextView: some View {
    switch event.state {
    case "ACTIVE":
      return Text("● ").foregroundColor(.green) + Text("In Progress")
    case "COMPLETED":
      guard let winnerName = event.winner?.name else { fallthrough }
      
      if let teamName = event.winner?.teamName {
        return Text("● ").foregroundColor(.gray) + Text("1st place: ") + Text("\(teamName) ").foregroundColor(.gray) + Text(winnerName)
      } else {
        return Text("● ").foregroundColor(.gray) + Text("1st place: \(winnerName)")
      }
    default:
      return Text("● ").foregroundColor(.blue) + Text(event.startDate ?? "")
    }
  }
}

#Preview {
  EventRowView(
    event: Event(
      id: 1,
      name: "Smash Bros. Melee Singles",
      state: "COMPLETED",
      winner: Entrant(id: 1, name: "Mang0", teamName: "C9"),
      startDate: "Oct 9, 2016",
      eventType: "Singles",
      videogameName: "Super Smash Bros. Melee",
      videogameImage: "https://images.start.gg/images/videogame/1/image-36450d5d1b6f2c693be2abfdbc159106.jpg?ehk=kHyxo9ZpitIjPcTdkRi6H4H8JkRXjeM5%2BousqjDV%2B%2FI%3D&ehkOptimized=CRpoBnGE8dtJkSIGcd2811UkurtlEPOKEay%2BqgCETlQ%3D"
    )
  )
}
