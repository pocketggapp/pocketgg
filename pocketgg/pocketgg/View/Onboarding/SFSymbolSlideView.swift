import SwiftUI

struct SFSymbolSlideView: View {
  private let content: OnboardingContent
  
  init(content: OnboardingContent) {
    self.content = content
  }
  
  var body: some View {
    VStack {
      Spacer()
      Image(systemName: content.imageName ?? "gamecontroller")
        .resizable()
        .frame(width: 100, height: 100)
        .fontWeight(.light)
        .foregroundColor(content.sfSymbolColor ?? .gray)
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
  SFSymbolSlideView(
    content: MockOnboardingContentService.createSfSymbolSlideContent()
  )
}
