import SwiftUI

final class OnboardingViewModel: ObservableObject {
  @Published var currentSlideIndex: Int
  
  let content: [OnboardingContent]
  private let userDefaults: UserDefaults
  
  init(
    content: [OnboardingContent],
    userDefaults: UserDefaults = .standard
  ) {
    self.currentSlideIndex = 0
    self.content = content
    self.userDefaults = userDefaults
  }
  
  var onFirstSlide: Bool {
    currentSlideIndex == 0
  }
  
  var onLastSlide: Bool {
    currentSlideIndex == content.count - 1
  }
  
  func goToPrevSlide() {
    guard currentSlideIndex > 0 else { return }
    currentSlideIndex -= 1
  }
  
  func goToNextSlide() {
    guard currentSlideIndex < content.count - 1 else { return }
    currentSlideIndex += 1
  }
  
  func setMostRecentAppVersion() {
    userDefaults.set(Constants.currentAppVersion, forKey: Constants.appVersion)
  }
}
