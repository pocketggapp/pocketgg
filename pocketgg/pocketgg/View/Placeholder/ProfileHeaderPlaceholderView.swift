import SwiftUI

struct ProfileHeaderPlaceholderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      GeometryReader { proxy in
        Rectangle()
          .fill(Color(.placeholder))
          .frame(width: proxy.size.width, height: 150 * scale)
      }
      
      VStack(alignment: .leading) {
        ZStack {
          RoundedRectangle(cornerRadius: 10)
            .fill(Color(uiColor: .systemBackground))
            .frame(width: 104 * scale, height: 104 * scale)
          
          RoundedRectangle(cornerRadius: 10)
            .fill(Color(.placeholder))
            .frame(width: 100 * scale, height: 100 * scale)
        }
        
        VStack(alignment: .leading, spacing: 5) {
          Text("C9 Mang0")
            .font(.title2.bold())
          
          Text("SSBM GOAT")
        }
      }
      .padding(.top, 100 * scale)
      .padding(.leading, 16)
    }
    .redacted(reason: .placeholder)
  }
}

#Preview {
  ProfileHeaderPlaceholderView()
}
