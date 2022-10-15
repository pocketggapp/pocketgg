//
//  OnboardingContentFactory.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2022-03-03.
//  Copyright © 2022 Gabriel Siu. All rights reserved.
//

import Foundation

final class OnboardingContentFactory {
  static func generateOnboardingContent() -> [Any] {
    let suggestedGames = [VideoGame(id: 1, name: "Super Smash Bros. Melee"),
                          VideoGame(id: 1386, name: "Super Smash Bros. Ultimate"),
                          VideoGame(id: 33602, name: "Project+"),
                          VideoGame(id: 14, name: "Rocket League"),
                          VideoGame(id: 17, name: "TEKKEN 7"),
                          VideoGame(id: 15, name: "Brawlhalla"),
                          VideoGame(id: 287, name: "DRAGON BALL FighterZ"),
                          VideoGame(id: 36865, name: "Melty Blood: Type Lumina"),
                          VideoGame(id: 33945, name: "Guilty Gear: Strive"),
                          VideoGame(id: 39281, name: "Nickelodeon All-Star Brawl")]
    return [OnboardingContent(title: "Welcome to pocket.gg",
                              subtitle: "An unofficial smash.gg client for iOS",
                              imageName: "onboarding-0", imagePadding: 50),
            OnboardingContent(title: "Discover current & upcoming tournaments",
                              subtitle: "Keep up with tournament results and view entire brackets",
                              imageName: "onboarding-1", imagePadding: 0),
            SelectionContent(title: "Let's get Started",
                             subtitle: """
                             Select your favourite video games to see tournaments that feature those games. \
                             Don't worry if you don't see a game that you're looking for, you'll be able to search from a wider list of games later.
                             """,
                             items: suggestedGames),
            OnboardingContent(title: "All Done!",
                              subtitle: "You can change your chosen video games or rearrange the main screen sections at any time using the Edit button.",
                              imageName: "onboarding-3", imagePadding: 0)]
  }

  static func generateUpdateContent() -> [Any] {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? k.UserDefaults.currentAppVersion
    let updateTitle = "pocket.gg updated to v" + appVersion

    return [OnboardingContent(title: updateTitle,
                              subtitle: "Here's whats new in this update",
                              imageName: "onboarding-0", imagePadding: 50),
            OnboardingContent(title: "Rearrange main screen sections",
                              subtitle: """
                              You can now fully customize the order of the sections on the main screen. \
                              To do so, tap the Edit button at the top right, and drag around the sections to your liking. \
                              To hide a section, drag it under Disabled Sections.
                              """,
                              imageName: "onboarding-3", imagePadding: 0),
            OnboardingContent(title: "Video Game Selection",
                              subtitle: """
                              The location of the Video Game Selection has also changed. \
                              It can now be found by tapping the Edit button at the top right.
                              """,
                              imageName: "update-1", imagePadding: 0),
            TextContent(title: "Other Changes", message: """
                        • Added the following games to the Video Game Selection:
                            ◦ Rocket League Sideswipe
                            ◦ Melty Blood: Type Lumina
                            ◦ The King of Fighters XV
                        • Made some buttons easier to tap
                        • Other miscellaneous improvements and bug fixes
                        """)]
  }
}
