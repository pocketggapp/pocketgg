import SwiftUI

struct VideoGameSearchView: View {
  @StateObject private var viewModel: VideoGameSearchViewModel
  
  init(
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      VideoGameSearchViewModel(
        service: service
      )
    }())
  }
  
  var body: some View {
    List {
      Section {
        HStack {
          Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
          
          TextField("Search", text: $viewModel.searchText)
            .onSubmit {
              Task {
                await viewModel.fetchVideoGames(newSearch: true)
              }
            }
            .submitLabel(.search)
        }
      }
      
      switch viewModel.state {
      case .uninitialized:
        EmptyStateView(
          systemImageName: "magnifyingglass",
          title: "Search for Video Games",
          subtitle: "Find video games by typing the name of a video game and tapping search"
        )
      case .loading:
        ForEach(0..<20) { _ in
          Text("Video Game Placeholder")
            .redacted(reason: .placeholder)
        }
      case .loaded(let videoGames):
        if !videoGames.isEmpty {
          ForEach(videoGames) { videoGame in
            Button {
              viewModel.videoGameTapped(videoGame)
            } label: {
              HStack {
                Text(videoGame.name)
                  .foregroundColor(Color(uiColor: .label))
                Spacer()
                if viewModel.videoGameEnabled(videoGame.id) {
                  Image(systemName: "checkmark")
                    .foregroundColor(.red)
                }
              }
            }
          }
          
          if !viewModel.noMoreVideoGames {
            Text("Video Game Placeholder")
              .redacted(reason: .placeholder)
              .onAppear {
                Task {
                  await viewModel.fetchVideoGames(getNextPage: true)
                }
              }
          }
        } else {
          EmptyStateView(
            systemImageName: "questionmark.app.dashed",
            title: "No Search Results",
            subtitle: "Check your spelling or try another search term"
          )
        }
      case .error:
        ErrorStateView(subtitle: "There was an error loading search results") {
          Task {
            await viewModel.fetchVideoGames(newSearch: true)
          }
        }
      }
    }
    .listStyle(.insetGrouped)
    .task {
      viewModel.getEnabledVideoGames()
    }
    .onAppear {
      viewModel.resetVideoGamesChangedNotification()
    }
    .scrollDismissesKeyboard(.immediately)
  }
}

#Preview {
  VideoGameSearchView(
    service: MockStartggService()
  )
}
