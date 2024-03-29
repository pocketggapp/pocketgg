import SwiftUI

struct EmptyStateView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let systemImageName: String
  private let title: String
  private let subtitle: String
  private let showVerticalPadding: Bool
  
  init(
    systemImageName: String,
    title: String,
    subtitle: String,
    showVerticalPadding: Bool = true
  ) {
    self.systemImageName = systemImageName
    self.title = title
    self.subtitle = subtitle
    self.showVerticalPadding = showVerticalPadding
  }
  
  var body: some View {
    HStack {
      Spacer()
      VStack(spacing: 16) {
        Image(systemName: systemImageName)
          .resizable()
          .scaledToFit()
          .frame(width: 75 * scale, height: 75 * scale)
          .fontWeight(.light)
        
        VStack(spacing: 5) {
          Text(title)
            .font(.title2.bold())
            .multilineTextAlignment(.center)
          
          Text(subtitle)
            .multilineTextAlignment(.center)
            .foregroundColor(.gray)
        }
      }
      Spacer()
    }
    .padding(.vertical, showVerticalPadding ? 64 : 0)
  }
}

#Preview {
  EmptyStateView(
    systemImageName: "questionmark.app.dashed",
    title: "No Events",
    subtitle: "There are currently no events for this tournament"
  )
}
