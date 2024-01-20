import SwiftUI

struct NoStreamsView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  var body: some View {
    HStack {
      Spacer()
      VStack {
        Image(systemName: "questionmark.video")
          .resizable()
          .scaledToFit()
          .frame(width: 75 * scale, height: 75 * scale)
        
        VStack {
          Text("**No Streams**")
            .font(.title)
            .multilineTextAlignment(.center)
          
          Text("There are currently no streams for this tournament")
            .font(.title3)
            .multilineTextAlignment(.center)
        }
      }
      Spacer()
    }
    .padding(.top, 64)
  }
}

#Preview {
  NoStreamsView()
}
