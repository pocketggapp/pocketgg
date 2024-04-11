import Foundation

enum OnboardingFlowType {
  case newUser
  case appUpdate
}

enum OnboardingContentType {
  case image
  case selection
  case location
}

struct OnboardingContent: Hashable {
  let id: Int
  let title: String
  let subtitle: String
  let type: OnboardingContentType
  
  let imageName: String?
  let videoGames: [VideoGame]?
}
