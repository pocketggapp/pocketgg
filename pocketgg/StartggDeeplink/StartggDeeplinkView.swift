import SwiftUI

struct StartggDeeplinkView: View {
  @StateObject private var viewModel: StartggDeeplinkViewModel
  
  init(viewModel: StartggDeeplinkViewModel) {
    self._viewModel = StateObject(wrappedValue: { viewModel }())
  }
  
  var body: some View {
    VStack(spacing: 16) {
      Image("tournament-red")
        .resizable()
        .frame(width: 100, height: 100)
      
      VStack(spacing: 5) {
        Text(viewModel.titleText)
          .font(.title2.bold())
          .multilineTextAlignment(.center)
        
        Text(viewModel.messageText)
          .multilineTextAlignment(.center)
          .foregroundColor(.gray)
      }
    }
    .onAppear {
      Task {
        await viewModel.onViewAppear()
      }
    }
  }
}
