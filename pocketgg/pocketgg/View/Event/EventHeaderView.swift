import SwiftUI

struct EventHeaderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let name: String?
  private let imageURL: String?
  private let eventType: String?
  private let videogameName: String?
  private let startDate: String?
  private let dotColor: Color
  
  init(name: String?, imageURL: String?, eventType: String?, videogameName: String?, startDate: String?, dotColor: Color) {
    self.name = name
    self.imageURL = imageURL
    self.eventType = eventType
    self.videogameName = videogameName
    self.startDate = startDate
    self.dotColor = dotColor
  }
  
  var body: some View {
    HStack {
      AsyncImageView(
        imageURL: imageURL,
        cornerRadius: 5,
        newSize: .init(width: 54, height: 72)
      )
      .frame(width: 54 * scale, height: 72 * scale)
      .clipped()
      
      VStack(alignment: .leading) {
        Text(name ?? "")
          .font(.headline)
        
        subtitleTextView
          .font(.subheadline)
      }
      
      Spacer()
    }
  }
  
  private var subtitleTextView: some View {
    return Text(eventType ?? "") + Text(" • ") + Text(videogameName ?? "")
    + Text("\n") + Text("● ").foregroundColor(dotColor) + Text(startDate ?? "")
  }
}

#Preview {
  EventHeaderView(
    name: "Melee Singles",
    imageURL: "https://images.start.gg/images/videogame/1/image-36450d5d1b6f2c693be2abfdbc159106.jpg?ehk=kHyxo9ZpitIjPcTdkRi6H4H8JkRXjeM5%2BousqjDV%2B%2FI%3D&ehkOptimized=CRpoBnGE8dtJkSIGcd2811UkurtlEPOKEay%2BqgCETlQ%3D",
    eventType: "Singles",
    videogameName: "Super Smash Bros. Melee",
    startDate: "Oct 9, 2016",
    dotColor: .gray
  )
}
