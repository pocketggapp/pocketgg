import SwiftUI

private enum Constants {
  static let imageLength: CGFloat = 100
  static let buttonHeight: CGFloat = 44
}

struct LoginView: View {
  
  @StateObject private var viewModel = LoginViewModel(oAuthService: OAuthService())
  
  var body: some View {
    VStack {
      HStack {
        Image("tournament-red")
          .resizable()
          .frame(width: Constants.imageLength, height: Constants.imageLength)
        
        Text("pocket.gg")
          .font(.largeTitle)
      }
      
      Spacer()
      
      Button {
        Task {
          await viewModel.logIn()
        }
      } label: {
        Text("Log in with start.gg")
          .font(.body)
          .frame(maxWidth: .infinity)
      }
      .frame(minHeight: Constants.buttonHeight)
      .buttonStyle(.borderedProminent)
      .tint(.red)
    }
    .padding()
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
