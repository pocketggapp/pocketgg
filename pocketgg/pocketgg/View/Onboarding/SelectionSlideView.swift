import SwiftUI

struct SelectionSlideView: View {
  private let content: OnboardingContent
  
  @Binding private var selectedItemIDs: Set<Int>
  
  init(
    content: OnboardingContent,
    selectedItemIDs: Binding<Set<Int>>
  ) {
    self.content = content
    self._selectedItemIDs = selectedItemIDs
  }
  
  var body: some View {
    VStack {
      List(content.videoGames ?? [], selection: $selectedItemIDs) {
        Text($0.name)
      }
      .listStyle(.plain)
      
      VStack(spacing: 10) {
        Text(content.title)
          .multilineTextAlignment(.center)
          .font(.largeTitle.bold())
        
        Text(content.subtitle)
          .multilineTextAlignment(.center)
      }
    }
    .environment(\.editMode, .constant(.active))
  }
}

#Preview {
  SelectionSlideView(
    content: MockOnboardingContentService.createSelectionSlideContent(),
    selectedItemIDs: .constant([])
  )
}
