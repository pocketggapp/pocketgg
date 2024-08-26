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
        title: "pocketgg updated to version 2.0",
        subtitle: "Here's whats new in this update:",
        type: .image,
        imageName: "TODO",
        videoGames: nil
      ),
      OnboardingContent(
        id: 1,
        title: "OAuth Login Support",
        subtitle: "You can now log in to pocketgg using your start.gg account, instead of having to manually create and copy an access token.",
        type: .image,
        imageName: "TODO",
        videoGames: nil
      ),
      OnboardingContent(
        id: 2,
        title: "Improved Location Settings",
        subtitle: """
        You can now set a more precise location in pocketgg, to find tournaments close to your area. \
        This feature requires Location Services to be enabled for pocketgg.
        """,
        type: .image,
        imageName: "TODO",
        videoGames: nil
      ),
      OnboardingContent(
        id: 3,
        title: "Improvements to Searching",
        subtitle: """
        Searching for tournaments now delivers much more accurate results. \
        Also, you no longer have to send Video Game Update Requests; all video games on start.gg are now available on pocketgg.
        """,
        type: .image,
        imageName: "TODO",
        videoGames: nil
      ),
      OnboardingContent(
        id: 4,
        title: "Other Changes",
        subtitle: """
        • Tapping a set/match now shows the station and stream it's being played on (if available), as well as the seeds of both players
        • Added color indicators to indicate which sets/matches are in progress
        • Added support for Swiss brackets
        • Added the ability to add a tournament directly to your calendar
        • Added the ability to filter a TO's tournaments to those that they are directly organizing, are an admin of, or are competing in
        • Added an 'Online' section to the main screen for all online tournaments
        • Many other bug fixes and improvements
        """,
        type: .image,
        imageName: "TODO",
        videoGames: nil
      )
    ]
  }
}
