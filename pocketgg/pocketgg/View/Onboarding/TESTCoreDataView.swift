import SwiftUI

struct TESTCoreDataView: View {
  @StateObject private var viewModel: TESTCoreDataViewModel
  
  init() {
    self._viewModel = StateObject(wrappedValue: {
      TESTCoreDataViewModel()
    }())
  }
  var body: some View {
    VStack {
      Text("Games:")
      ForEach(viewModel.games) {
        Text("\($0.name) \($0.id)")
      }
      
      Button {
        viewModel.getGames()
      } label: {
        Text("GET GAMES")
      }
      Button {
        viewModel.deleteGames()
      } label: {
        Text("DELETE GAMES")
      }
      
      Button {
        UserDefaults.standard.set("1.1", forKey: Constants.appVersion)
      } label: {
        Text("SET USERDEFAULT APPVERSION TO 1.1")
      }
      
      Button {
        UserDefaults.standard.removeObject(forKey: Constants.appVersion)
      } label: {
        Text("DELETE USERDEFAULT APP VERSION")
      }
    }
  }
}

final class TESTCoreDataViewModel: ObservableObject {
  @Published var games: [VideoGame]
  
  init() {
    self.games = []
  }
  
  func getGames() {
    games = VideoGamePreferenceService.getVideoGames()
  }
  
  func deleteGames() {
    VideoGamePreferenceService.deleteAllVideoGames()
    getGames()
  }
}
