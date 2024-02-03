import SwiftUI

struct LocationPlaceholderView: View {
  var body: some View {
    VStack(alignment: .leading) {
      Rectangle()
        .fill(Color(.placeholder))
        .frame(height: 300)
      
      Text("Better Living Centre")
        .font(.body)
        .padding(.leading)
      
      Text("123 Queen St W, Toronto, ON M5H 3M9, Canada")
        .font(.caption)
        .padding(.leading)
      
      Text("Get Directions")
        .font(.body)
        .padding([.top, .leading])
    }
    .redacted(reason: .placeholder)
  }
}

#Preview {
  LocationPlaceholderView()
}
