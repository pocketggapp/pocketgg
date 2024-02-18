import SwiftUI

struct FollowingView: View {
  var body: some View {
    EmptyStateView(
      systemImageName: "person.fill.questionmark",
      title: "No tournament organizers followed",
      subtitle: """
      To follow a tournament organizer, tap the … icon at the top right of any tournament page, then tap "View more tournaments \
      by this tournament organizer", then tap "Follow".
      """
    )
  }
}

#Preview {
  FollowingView()
}
