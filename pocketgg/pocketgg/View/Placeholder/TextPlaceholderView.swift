import SwiftUI

struct TextPlaceholderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  var body: some View {
    Text("Placeholder Text")
      .redacted(reason: .placeholder)
      .frame(height: 44 * scale)
  }
}

#Preview {
  TextPlaceholderView()
}
