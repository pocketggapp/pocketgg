import SwiftUI

struct TipOptionPlaceholderView: View {
  var body: some View {
    Button { } label: {
      HStack {
        Text("Placeholder")
          .font(.title)
        
        Spacer()
        
        Text("$1.99")
      }
    }
    .buttonStyle(.bordered)
    .redacted(reason: .placeholder)
    .disabled(true)
  }
}

#Preview {
  TipOptionPlaceholderView()
}
