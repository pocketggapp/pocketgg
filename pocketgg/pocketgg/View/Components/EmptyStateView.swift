import SwiftUI

struct EmptyStateView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let systemImageName: String
  private let title: String
  private let subtitle: String
  
  init(systemImageName: String, title: String, subtitle: String) {
    self.systemImageName = systemImageName
    self.title = title
    self.subtitle = subtitle
  }
  
  var body: some View {
    HStack {
      Spacer()
      VStack {
        Image(systemName: systemImageName)
          .resizable()
          .scaledToFit()
          .frame(width: 75 * scale, height: 75 * scale)
        
        VStack {
          Text("**\(title)**")
            .font(.title)
            .multilineTextAlignment(.center)
          
          Text(subtitle)
            .font(.title3)
            .multilineTextAlignment(.center)
        }
      }
      Spacer()
    }
    .padding(.vertical, 64)
  }
}

#Preview {
  EmptyStateView(
    systemImageName: "questionmark.app.dashed",
    title: "No Events",
    subtitle: "There are currently no events for this tournament"
  )
}
