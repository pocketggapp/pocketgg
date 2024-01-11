import SwiftUI

struct EventPlaceholderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  var body: some View {
    HStack {
      Rectangle()
        .fill(Color(red: 214/255, green: 214/255, blue: 214/255))
        .aspectRatio(0.75, contentMode: .fit)
        .frame(height: 44 * scale)
        .cornerRadius(5)
      
      VStack(alignment: .leading) {
        Text("Smash Bros. Melee Singles")
          .font(.body)
        
        Text("● Oct 9, 2016")
          .font(.caption)
      }
    }
    .redacted(reason: .placeholder)
  }
}

#Preview {
  EventPlaceholderView()
}
