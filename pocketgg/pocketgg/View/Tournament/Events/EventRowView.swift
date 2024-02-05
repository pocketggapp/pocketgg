import SwiftUI

struct EventRowView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let event: Event
  
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
    event: MockStartggService.createEvent()
  )
}
