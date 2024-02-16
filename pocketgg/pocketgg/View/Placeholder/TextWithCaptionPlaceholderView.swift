import SwiftUI

struct TextWithCaptionPlaceholderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Placeholder Text")
      
      Text("Placeholder Text")
        .font(.caption)
    }
    .redacted(reason: .placeholder)
    .frame(height: 44 * scale)
  }
}

#Preview {
  TextWithCaptionPlaceholderView()
}
