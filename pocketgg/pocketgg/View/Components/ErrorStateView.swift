import SwiftUI

struct ErrorStateView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let is503: Bool
  private let subtitle: String
  private let reload: (() -> Void)
  
  init(is503: Bool, subtitle: String, reload: @escaping () -> Void) {
    self.is503 = is503
    self.subtitle = is503 ? "The start.gg servers are currently unavailable, please try again soon." : subtitle
    self.reload = reload
  }
  
  var body: some View {
    HStack {
      Spacer()
      VStack(spacing: 16) {
        Image(systemName: is503 ? "server.rack" : "exclamationmark.circle")
          .resizable()
          .scaledToFit()
          .frame(width: 75 * scale, height: 75 * scale)
          .fontWeight(.light)
        
        VStack(spacing: 5) {
          Text("Error")
            .font(.title2.bold())
            .multilineTextAlignment(.center)
          
          Text(subtitle)
            .multilineTextAlignment(.center)
            .foregroundStyle(.gray)
          
          Button {
            reload()
          } label: {
            Text("Reload")
              .padding(5)
          }
          .buttonStyle(.borderedProminent)
          .tint(.red)
          .padding(.top)
        }
      }
      Spacer()
    }
    .padding(.vertical, 64)
  }
}

#Preview {
  ErrorStateView(is503: false, subtitle: "There was an error loading this tournament.", reload: {})
}
