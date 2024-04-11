final class OnboardingContentService {
  static func createNewUserContent() -> [OnboardingContent] {
    [
      OnboardingContent(
        id: 0,
        title: "Welcome to pocketgg!",
        subtitle: "A video game tournament companion app, powered by start.gg",
        type: .image,
        imageName: "TODO", // TODO: Make images
        videoGames: nil
      ),
      OnboardingContent(
        id: 1,
        title: "Discover current & upcoming tournaments",
        subtitle: "Keep up with tournament results and view entire brackets",
        type: .image,
        imageName: "TODO",
        videoGames: nil
      ),
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
      ),
      OnboardingContent(
        id: 3,
        title: "Discover your local scene",
        subtitle: "Enable location services to allow pocketgg to find tournaments in your area. You can adjust the exact radius later in the app settings.",
        type: .location,
        imageName: nil,
        videoGames: nil
      ),
      OnboardingContent(
        id: 4,
        title: "All Done!",
        subtitle: "You can change your chosen video games or rearrange the main screen sections at any time in the app settings",
        type: .image,
        imageName: "TODO",
        videoGames: nil
      )
    ]
  }
  
  static func createWhatsNewContent() -> [OnboardingContent] {
    [
      OnboardingContent(
        id: 0,
        title: "APP UPDATED",
        subtitle: "A video game tournament companion app, powered by start.gg",
        type: .image,
        imageName: "TODO",
        videoGames: nil
      ),
      OnboardingContent(
        id: 1,
        title: "Improved location settings",
        subtitle: "You can now enable location services to find tournaments in your area. You can adjust the exact radius later in the app settings.",
        type: .location,
        imageName: nil,
        videoGames: nil
      ),
      OnboardingContent(
        id: 2,
        title: "APP UPDATED 2",
        subtitle: "A video game tournament companion app, powered by start.gg",
        type: .image,
        imageName: "TODO",
        videoGames: nil
      )
    ]
  }
}
