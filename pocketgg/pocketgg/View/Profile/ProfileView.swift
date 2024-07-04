import SwiftUI

struct ProfileView: View {
  @StateObject private var viewModel: ProfileViewModel
  
  init(service: StartggServiceType = StartggService.shared) {
    self._viewModel = StateObject(wrappedValue: {
      ProfileViewModel(service: service)
    }())
  }
  
  var body: some View {
    NavigationStack {
      ScrollView(.vertical) {
        VStack(spacing: 32) {
          switch viewModel.state {
          case .uninitialized, .loading:
            ProfilePlaceholderView()
          case .loaded(let profile):
            if let profile {
              ProfileHeaderView(
                profile: profile
              )
              
              if !profile.tournaments.isEmpty {
                VStack(alignment: .leading) {
                  HStack {
                    Text("Recent Tournaments")
                      .font(.title2.bold())
                    
                    Spacer()
                    
                    NavigationLink(value: 0) {
                      Text("View all")
                    }
                  }
                  
                  ForEach(profile.tournaments, id: \.id) { tournament in
                    NavigationLink(value: tournament) {
                      ZStack {
                        Color(UIColor.systemBackground)
                        
                        HStack {
                          TournamentRowView(tournament: tournament)
                          
                          Spacer()
                          
                          Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                        }
                      }
                    }
                    .buttonStyle(.plain)
                  }
                }
                .padding(.horizontal)
              } else {
                EmptyStateView(
                  systemImageName: "trophy.fill",
                  title: "No Recent Tournaments",
                  subtitle: "Your recent tournaments will show up here."
                )
              }
            } else {
              EmptyStateView(
                systemImageName: "person.crop.circle",
                title: "Guest Mode",
                subtitle: "Log in to view your profile and recent tournaments."
              )
            }
          case .error:
            ErrorStateView(subtitle: "There was an error loading your profile.") {
              Task {
                await viewModel.fetchProfile(refreshed: true)
              }
            }
          }
        }
      }
      .task {
        await viewModel.fetchProfile()
      }
      .refreshable {
        await viewModel.fetchProfile(refreshed: true)
      }
      .navigationDestination(for: Int.self) { _ in
        CurrentUserTournamentsView()
      }
      .navigationDestination(for: Tournament.self) {
        TournamentView(tournament: $0)
      }
      .navigationDestination(for: Event.self) {
        EventView(event: $0)
      }
      .navigationDestination(for: Entrant.self) {
        UserAdminTournamentListView(user: $0)
      }
      .navigationTitle("Profile")
    }
  }
}

#Preview {
  ProfileView(
    service: MockStartggService()
  )
}
