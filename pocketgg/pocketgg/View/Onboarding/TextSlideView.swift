import SwiftUI

struct TextSlideView: View {
  private let content: OnboardingContent
  
  init(content: OnboardingContent) {
    self.content = content
  }
  
  var body: some View {
    VStack(spacing: 16) {
      Spacer()
      
      Text(content.title)
        .multilineTextAlignment(.center)
        .font(.largeTitle.bold())
      
      Text(content.subtitle)
        .multilineTextAlignment(.leading)
      
      Spacer()
    }
  }
}

#Preview {
  ImageSlideView(
    content: MockOnboardingContentService.createTextSlideContent()
  )
}
