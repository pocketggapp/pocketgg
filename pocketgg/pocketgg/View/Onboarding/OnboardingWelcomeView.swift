import SwiftUI

struct OnboardingWelcomeView: View {
  private let content: OnboardingContent
  
  init(content: OnboardingContent) {
    self.content = content
  }
  
  var body: some View {
    VStack {
      Spacer()
      
      Image(content.imageName ?? "")
        .resizable()
        .frame(width: 250, height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 20))
      
      Spacer()
      
      VStack(spacing: 10) {
        Text(content.title)
          .multilineTextAlignment(.center)
          .font(.largeTitle.bold())
        
        Text(content.subtitle)
          .multilineTextAlignment(.center)
      }
    }
  }
}

#Preview {
  OnboardingWelcomeView(
    content: MockOnboardingContentService.createWelcomeSlideContent()
  )
}
