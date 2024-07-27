import SwiftUI

struct VideoGamesView: View {
  @StateObject private var viewModel: VideoGamesViewModel
  
  init() {
    self._viewModel = StateObject(wrappedValue: {
      VideoGamesViewModel()
    }())
  }
  
  var body: some View {
    List {
      Section {
        switch viewModel.state {
        case .uninitialized, .loading:
          ForEach(0..<20) { _ in
            Text("Video Game Placeholder")
              .redacted(reason: .placeholder)
          }
        case .loaded(let videoGames):
          if !videoGames.isEmpty {
            ForEach(videoGames) {
              Text($0.name ?? "")
            }
            .onDelete(perform: viewModel.deleteVideoGame)
          } else {
            EmptyStateView(
              systemImageName: "gamecontroller",
              title: "No Video Games",
              subtitle: "Select your favorite video games to see tournaments that feature those games."
            )
          }
        case .error:
          ErrorStateView(is503: false, subtitle: "There was an error loading your saved video games.") {
            Task {
              viewModel.getSavedVideoGames()
            }
          }
        }
      } header: {
        Text("Enabled Games")
      }
      
      Section {
        NavigationLink {
          VideoGameSearchView()
        } label: {
          HStack {
            Image(systemName: "plus")
            Text("Add more games")
          }
          .foregroundColor(.blue)
        }
      }
    }
    .listStyle(.insetGrouped)
    .onAppear {
      viewModel.resetHomeViewRefreshNotification()
    }
    .task {
      viewModel.getSavedVideoGames()
    }
    .toolbar { EditButton() }
    .navigationTitle("Video Game Selection")
  }
}

#Preview {
  VideoGamesView()
}
