import SwiftUI

struct NoLocationView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  var body: some View {
    HStack {
      Spacer()
      VStack {
        Image(systemName: "wifi")
          .resizable()
          .scaledToFit()
          .frame(width: 75 * scale, height: 75 * scale)
        
        VStack {
          Text("**Online**")
            .font(.title)
            .multilineTextAlignment(.center)
          
          Text("This tournament is being held online")
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
