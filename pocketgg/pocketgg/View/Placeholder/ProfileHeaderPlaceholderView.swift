import SwiftUI

struct ProfileHeaderPlaceholderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  var body: some View {
    GeometryReader { proxy in
      ZStack(alignment: .topLeading) {
        Rectangle()
          .fill(Color(.placeholder))
          .frame(width: proxy.size.width, height: 150 * scale)
        
        VStack(alignment: .leading) {
          Rectangle()
            .fill(Color(.placeholder))
            .frame(width: 100 * scale, height: 100 * scale)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(Color(uiColor: .systemBackground), lineWidth: 2)
            )
          
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
}

#Preview {
  ProfileHeaderPlaceholderView()
}
