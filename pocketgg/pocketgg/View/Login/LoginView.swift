import SwiftUI

private enum LoginConstants {
  static let imageLength: CGFloat = 100
}

struct LoginView: View {
  @EnvironmentObject private var appRootManager: AppRootManager
  @StateObject private var viewModel: LoginViewModel
  
  init(oAuthService: OAuthServiceType = OAuthService.shared) {
    self._viewModel = StateObject(wrappedValue: {
      LoginViewModel(oAuthService: oAuthService)
    }())
  }
  
  var body: some View {
    VStack {
      Spacer()
      
        Image("tournament-red")
          .resizable()
          .frame(width: LoginConstants.imageLength, height: LoginConstants.imageLength)
      
      VStack(spacing: 10) {
        Text("pocketgg")
          .font(.largeTitle.bold())
        
        Text("A video game tournament companion app, powered by start.gg")
          .multilineTextAlignment(.center)
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
          .padding(5)
          .frame(maxWidth: .infinity)
      }
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
  LoginView(oAuthService: MockOAuthService())
}
