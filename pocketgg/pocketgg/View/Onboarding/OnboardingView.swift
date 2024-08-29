import SwiftUI

struct OnboardingView: View {
  @Environment(\.dismiss) private var dismiss
  
  @StateObject private var viewModel: OnboardingViewModel
  @State private var selectedGameIDs = Set<Int>()
  
  private let flowType: OnboardingFlowType
  
  init(
    content: [OnboardingContent],
    flowType: OnboardingFlowType
  ) {
    self._viewModel = StateObject(wrappedValue: {
      OnboardingViewModel(content: content)
    }())
    self.flowType = flowType
  }
  
  var body: some View {
    VStack {
      HStack {
        if !viewModel.onFirstSlide {
          Button {
            viewModel.goToPrevSlide()
          } label: {
            Image(systemName: "chevron.left")
              .font(.title3)
              .foregroundColor(.red)
              .padding(10)
          }
        }
        
        Spacer()
        
        Button {
          finishOnboardingFlow(saveGames: false)
        } label: {
          Text("Skip")
            .foregroundColor(.red)
            .padding(10)
        }
      }
      
      TabView(selection: $viewModel.currentSlideIndex) {
        ForEach(viewModel.content, id: \.id) {
          switch $0.type {
          case .welcome:
            OnboardingWelcomeView(content: $0)
          case .image:
            ImageSlideView(content: $0)
          case .selection:
            SelectionSlideView(
              content: $0,
              selectedItemIDs: $selectedGameIDs
            )
          case .location:
            OnboardingLocationView(content: $0)
          }
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .padding(.bottom)
      
      Button {
        if viewModel.onLastSlide {
          finishOnboardingFlow()
        } else {
          viewModel.goToNextSlide()
        }
      } label: {
        Text(viewModel.onLastSlide ? "Done" : "Next")
          .font(.body)
          .padding(5)
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.borderedProminent)
      .tint(.red)
    }
    .padding()
  }
  
  private func finishOnboardingFlow(saveGames: Bool = true) {
    switch flowType {
    case .newUser:
      var savedGameIDs = [Int]()
      if saveGames {
        VideoGamePreferenceService.saveVideoGames(gameIDs: selectedGameIDs)
        savedGameIDs = Array(selectedGameIDs)
      }
      AppDataService.newUserOnboarding(homeViewSections: savedGameIDs)
    case .appUpdate:
      AppDataService.appV2Migration()
    }
    
    dismiss()
  }
}

#Preview {
  OnboardingView(
    content: [
      MockOnboardingContentService.createImageSlideContent(),
      MockOnboardingContentService.createSelectionSlideContent()
    ],
    flowType: .newUser
  )
}
