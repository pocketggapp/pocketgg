import SwiftUI

struct ImageSlideView: View {
  private let content: OnboardingContent
  
  init(content: OnboardingContent) {
    self.content = content
  }
  
  var body: some View {
    VStack {
      Image(content.imageName ?? "")
        .resizable()
        .scaledToFit()
      
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
  ImageSlideView(
    content: MockOnboardingContentService.createImageSlideContent()
  )
}
