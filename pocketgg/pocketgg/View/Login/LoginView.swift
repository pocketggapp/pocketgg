import SwiftUI

private enum LoginConstants {
  static let imageLength: CGFloat = 100
  static let buttonHeight: CGFloat = 44
}

struct LoginView: View {
  @EnvironmentObject private var appRootManager: AppRootManager
  @StateObject private var viewModel: LoginViewModel
  
  init(viewModel: LoginViewModel) {
    self._viewModel = StateObject(wrappedValue: { viewModel }())
  }
  
  var body: some View {
    VStack {
      HStack {
        Image("tournament-red")
          .resizable()
          .frame(width: LoginConstants.imageLength, height: LoginConstants.imageLength)
        
        Text("pocket.gg")
          .font(.largeTitle)
      }
      
      Spacer()
      
      Button {
        Task {
          await viewModel.logIn()
          if viewModel.loggedInSuccessfully {
            appRootManager.currentRoot = .home
          }
        }
      } label: {
        Text("Log in with start.gg")
          .font(.body)
          .frame(maxWidth: .infinity)
      }
      .frame(minHeight: LoginConstants.buttonHeight)
      .buttonStyle(.borderedProminent)
      .tint(.red)
    }
    .padding()
    .alert("Error", isPresented: $viewModel.showingAlert, actions: {}, message: {
      Text(viewModel.alertMessage)
    })
  }
}

#Preview {
  LoginView(viewModel: LoginViewModel(oAuthService: OAuthService()))
}
