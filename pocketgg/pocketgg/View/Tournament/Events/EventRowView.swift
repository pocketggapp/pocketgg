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
          cornerRadius: 5,
          newSize: .init(width: 33, height: 44)
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
          .foregroundStyle(.gray)
      }
    }
  }
  
  private var subtitleTextView: some View {
    switch event.state {
    case .active:
      return Text("● ").foregroundStyle(.green) + Text("In Progress")
    case .completed:
      guard let winnerName = event.winner?.name else { fallthrough }
      
      if let teamName = event.winner?.teamName {
        return Text("● ").foregroundStyle(.gray) + Text("1st place: ") + Text("\(teamName) ").foregroundStyle(.gray) + Text(winnerName)
      } else {
        return Text("● ").foregroundStyle(.gray) + Text("1st place: \(winnerName)")
      }
    default:
      return Text("● ").foregroundStyle(.blue) + Text(event.startDate ?? "")
    }
  }
}

#Preview {
  EventRowView(
    event: MockStartggService.createEvent()
  )
}
