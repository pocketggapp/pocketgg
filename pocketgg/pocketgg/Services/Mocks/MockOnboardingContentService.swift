final class MockOnboardingContentService {
  static func createWelcomeSlideContent() -> OnboardingContent {
    OnboardingContent(
      id: 0,
      title: "Welcome to pocketgg!",
      subtitle: "A video game tournament companion app, powered by start.gg",
      type: .welcome,
      imageName: "onboarding-0",
      videoGames: nil
    )
  }
  
  static func createImageSlideContent() -> OnboardingContent {
    OnboardingContent(
      id: 1,
      title: "Discover current & upcoming tournaments",
      subtitle: "Keep up with tournament results and view entire brackets",
      type: .image,
      imageName: "TODO",
      videoGames: nil
    )
  }
  
  static func createSelectionSlideContent() -> OnboardingContent {
    OnboardingContent(
      id: 2,
      title: "Let's get Started",
      subtitle: """
      Select your favourite video games to see tournaments that feature those games.\n
      Don't worry if you don't see a game that you're looking for, you'll be able to search from a wider list of games later.
      """,
      type: .selection,
      imageName: nil,
      videoGames: VideoGamePreferenceService.getRecommendedGames()
    )
  }
  
  static func createLocationSlideContent() -> OnboardingContent {
    OnboardingContent(
      id: 3,
      title: "Discover your local scene",
      subtitle: "Enable location services to allow pocketgg to find tournaments in your area. You can adjust the exact radius later in the app settings.",
      type: .location,
      imageName: nil,
      videoGames: nil
    )
  }
}
