import SwiftUI

struct ErrorStateView: View {
  @ScaledMetric private var scale: CGFloat = 1
  private let subtitle: String
  private let reload: (() -> Void)
  
  init(subtitle: String, reload: @escaping () -> Void) {
    self.subtitle = subtitle
    self.reload = reload
  }
  
  var body: some View {
    HStack {
      Spacer()
      VStack {
        Image(systemName: "exclamationmark.circle")
          .resizable()
          .scaledToFit()
          .frame(width: 75 * scale, height: 75 * scale)
        
        VStack {
          Text("**Error**")
            .font(.title)
            .multilineTextAlignment(.center)
          
          Text(subtitle)
            .font(.title3)
            .multilineTextAlignment(.center)
          
          Button {
            reload()
          } label: {
            Text("Reload")
              .font(.body)
              .padding(5)
          }
          .buttonStyle(.borderedProminent)
          .tint(.red)
        }
      }
      Spacer()
    }
    .padding(.top, 64)
  }
}

#Preview {
  ErrorStateView(subtitle: "There was an error loading this tournament", reload: {})
}
