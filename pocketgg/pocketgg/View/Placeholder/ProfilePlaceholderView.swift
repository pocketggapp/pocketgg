import SwiftUI

struct ProfilePlaceholderView: View {
  var body: some View {
    VStack(spacing: 32) {
      ProfileHeaderPlaceholderView()
      
      VStack(alignment: .leading) {
        Text("Recent Tournaments")
          .font(.title2.bold())
        
        ForEach(0..<10) { _ in
          HStack {
            TournamentRowPlaceholderView()
            Spacer()
          }
        }
      }
      .padding(.horizontal)
    }
    .redacted(reason: .placeholder)
  }
}

#Preview {
  ProfilePlaceholderView()
}
