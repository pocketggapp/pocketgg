import SwiftUI

struct FollowingView: View {
  var body: some View {
    EmptyStateView(
      systemImageName: "person.fill.questionmark",
      title: "No tournament organizers followed",
      subtitle: """
      To follow a tournament organizer, tap the Info section on any tournament page, tap the tournament organizer's name, \
      then tap Follow.
      """
    )
  }
}

#Preview {
  FollowingView()
}
