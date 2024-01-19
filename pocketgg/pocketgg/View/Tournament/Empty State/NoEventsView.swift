import SwiftUI

struct NoEventsView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  var body: some View {
    VStack {
      Image(systemName: "questionmark.app.dashed")
        .resizable()
        .frame(width: 75 * scale, height: 75 * scale)
      
      VStack {
        Text("**No Events**")
          .font(.title)
          .multilineTextAlignment(.center)
        
        Text("There are currently no events for this tournament")
          .font(.title3)
          .multilineTextAlignment(.center)
      }
    }
  }
}

#Preview {
  NoEventsView()
}
