import SwiftUI

struct ErrorStateView: View {
  @ScaledMetric private var scale: CGFloat = 1
  private let reload: (() -> Void)
  
  init(reload: @escaping () -> Void) {
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
          
          Text("There was an error loading this tournament")
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
  ErrorStateView(reload: {})
}
