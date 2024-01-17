import SwiftUI

struct EventRowView: View {
  @ScaledMetric private var scale: CGFloat = 1
  var imageURL: String?
  var eventName: String?
  var eventDate: String?
  
  var body: some View {
    HStack {
      AsyncImageView(imageURL: imageURL ?? "")
        .frame(width: 33 * scale, height: 44 * scale)
        .cornerRadius(5)
        .clipped()
      
      VStack(alignment: .leading) {
        Text(eventName ?? "")
          .font(.body)
        
        Text(eventDate ?? "")
          .font(.caption)
      }
    }
  }
}

#Preview {
    EventRowView(
      imageURL: "https://images.start.gg/images/videogame/1/image-36450d5d1b6f2c693be2abfdbc159106.jpg?ehk=kHyxo9ZpitIjPcTdkRi6H4H8JkRXjeM5%2BousqjDV%2B%2FI%3D&ehkOptimized=CRpoBnGE8dtJkSIGcd2811UkurtlEPOKEay%2BqgCETlQ%3D",
      eventName: "Smash Bros. Melee Singles",
      eventDate: "● Oct 9, 2016"
    )
}
