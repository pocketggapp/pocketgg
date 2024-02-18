import SwiftUI

struct InfoPlaceholderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Contact Info")
        .font(.title3.bold())
      
      HStack {
        Rectangle()
          .fill(Color(.placeholder))
          .frame(width: 44 * scale, height: 44 * scale)
          .clipShape(RoundedRectangle(cornerRadius: 5))
        
        Text("InfoPlaceholderView")
      }
    }
    .redacted(reason: .placeholder)
  }
}

#Preview {
  InfoPlaceholderView()
}
