import SwiftUI

struct NoContactInfoView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  var body: some View {
    HStack {
      Spacer()
      VStack {
        Image(systemName: "person.fill.questionmark")
          .resizable()
          .scaledToFit()
          .frame(width: 75 * scale, height: 75 * scale)
        
        VStack {
          Text("**No Contact Info**")
            .font(.title)
            .multilineTextAlignment(.center)
          
          Text("There is currently no contact info for this tournament")
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
  NoContactInfoView()
}
