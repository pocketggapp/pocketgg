import SwiftUI

struct ProfileView: View {
  @StateObject private var viewModel: ProfileViewModel
  
  init(
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      ProfileViewModel(service: service)
    }())
  }
  
  var body: some View {
    ScrollView(.vertical) {
      VStack {
        switch viewModel.state {
        case .uninitialized, .loading:
          EmptyView() // TODO: Profile loading view
        case .loaded(let profile):
          if let profile {
            ProfileHeaderView(
              profile: profile
            )
          } else {
            EmptyView()
          }
          Spacer()
        case .error:
          EmptyView()
        }
      }
    }
    .task {
      await viewModel.fetchProfile()
    }
    .refreshable {
      await viewModel.fetchProfile(refreshed: true)
    }
  }
}

#Preview {
  ProfileView(
    service: MockStartggService()
  )
}
