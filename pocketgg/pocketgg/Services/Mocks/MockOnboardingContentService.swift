final class MockOnboardingContentService {
  static func createImageSlideContent() -> OnboardingContent {
    OnboardingContent(
      id: 0,
      title: "Welcome to pocketgg!",
      subtitle: "A video game tournament companion app, powered by start.gg",
      type: .image,
      imageName: "mang0",
      videoGames: nil
    )
  }
  
  static func createSelectionSlideContent() -> OnboardingContent {
    OnboardingContent(
      id: 1,
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
      id: 2,
      title: "Discover your local scene",
      subtitle: "Enable location services to allow pocketgg to find tournaments in your area. You can adjust the exact radius later in the app settings.",
      type: .location,
      imageName: nil,
      videoGames: nil
    )
  }
}
