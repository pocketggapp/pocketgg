import SwiftUI

struct BracketRowView: View {
  @ScaledMetric private var scale: CGFloat = 1
  private let name: String?
  
  init(name: String?) {
    self.name = name
  }
  
  var body: some View {
    ZStack {
      Color(UIColor.systemBackground)
      
      HStack {
        Text(name ?? "")
          .font(.body)
        
        Spacer()
        
        Image(systemName: "chevron.right")
          .foregroundStyle(.gray)
      }
      .frame(height: 44 * scale)
    }
  }
}

#Preview {
  BracketRowView(name: "Top 8")
}
