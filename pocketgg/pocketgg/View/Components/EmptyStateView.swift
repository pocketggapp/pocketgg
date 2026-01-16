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
          .frame(width: 60 * scale, height: 60 * scale)
          .fontWeight(.light)
          .foregroundStyle(Color(.emptyState))
        
        VStack(spacing: 5) {
          Text(title)
            .font(.title2.bold())
            .multilineTextAlignment(.center)
          
          Text(subtitle)
            .multilineTextAlignment(.center)
            .foregroundStyle(.gray)
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
    subtitle: "There are currently no events for this tournament."
  )
}
