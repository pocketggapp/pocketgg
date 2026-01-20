import SwiftUI

struct ErrorStateView: View {
  private let is503: Bool
  private let subtitle: String
  private let reload: (() -> Void)
  
  init(is503: Bool, subtitle: String, reload: @escaping () -> Void) {
    self.is503 = is503
    self.subtitle = is503 ? "The start.gg servers are currently unavailable, please try again soon." : subtitle
    self.reload = reload
  }
  
  var body: some View {
    ContentUnavailableView {
      Label("Error", systemImage: is503 ? "server.rack" : "exclamationmark.circle")
    } description: {
      Text(subtitle)
    } actions: {
      Button {
        reload()
      } label: {
        Text("Reload")
          .padding(5)
      }
      .buttonStyle(.borderedProminent)
      .tint(.red)
    }
    .padding(.vertical, 64)
  }
}

#Preview {
  ErrorStateView(is503: false, subtitle: "There was an error loading this tournament.", reload: {})
}
