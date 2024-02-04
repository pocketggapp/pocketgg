import SwiftUI

struct StreamPlaceholderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  var body: some View {
    HStack {
      Rectangle()
        .fill(Color(.placeholder))
        .frame(width: 44 * scale, height: 44 * scale)
        .clipShape(RoundedRectangle(cornerRadius: 5))
      
      Text("VGBootCamp & EvenMatchupGaming")
        .font(.body)
    }
    .redacted(reason: .placeholder)
  }
}

#Preview {
  StreamPlaceholderView()
}
