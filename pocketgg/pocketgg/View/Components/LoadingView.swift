import SwiftUI

struct LoadingView: View {
  var body: some View {
    ZStack {
      Color.gray
        .opacity(0.3)
      ProgressView()
    }
    .frame(width: 50, height: 50)
    .cornerRadius(5)
  }
}

#Preview {
  LoadingView()
}
