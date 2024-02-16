import SwiftUI

struct MatchRowPlaceholderView: View {
  var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading) {
          Text("Winners Semi-Final")
            .font(.headline)
          
          Text("Match A • Completed")
            .font(.subheadline)
        }
        Spacer()
      }
      .padding(.bottom)
      
      HStack {
        Text("C9 Mang0")
          .frame(maxWidth: .infinity)
        
        Text("vs.")
        
        Text("C9 Mang0")
          .frame(maxWidth: .infinity)
      }
      
      Text("3 - 2")
    }
    .redacted(reason: .placeholder)
  }
}

#Preview {
  MatchRowPlaceholderView()
}
