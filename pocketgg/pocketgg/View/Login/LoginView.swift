import SwiftUI

private enum LoginConstants {
  static let imageLength: CGFloat = 100
  static let buttonHeight: CGFloat = 44
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
    VStack(alignment: .center, spacing: 32) {
      HStack {
        Image("tournament-red")
          .resizable()
          .frame(width: LoginConstants.imageLength, height: LoginConstants.imageLength)
        
        Text("pocket.gg")
          .font(.largeTitle)
      }
      
      VStack(alignment: .center, spacing: 16) {
        Text("A video game tournament companion app, powered by start.gg")
          .multilineTextAlignment(.center)
        
        Text("Keep up with tournament results, view entire brackets effortlessly, and discover new tournaments.")
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
  LoginView(oAuthService: MockOAuthService())
}
