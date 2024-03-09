import SwiftUI
import CoreData

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
        Text("\($0.name ?? "INVALID NAME") \($0.id)")
      }
      
      Text("Layout:")
      HStack {
        ForEach(viewModel.layout, id: \.self) { afsd in
          Text("\(afsd)")
        }
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
      
      Button {
        viewModel.getLayout()
      } label: {
        Text("GET LAYOUT")
      }
      
      Button {
        let games = viewModel.games.map { Int($0.id) }
        UserDefaults.standard.set([-1, -2, -3] + games, forKey: Constants.homeViewSections)
      } label: {
        Text("SET LAYOUT TO DEFAULT + VIDEO GAMES")
      }
      
      Button {
        UserDefaults.standard.removeObject(forKey: Constants.homeViewSections)
      } label: {
        Text("DELETE LAYOUT")
      }
    }
  }
}

final class TESTCoreDataViewModel: ObservableObject {
  @Published var games: [VideoGameEntity]
  @Published var layout: [Int]
  
  init() {
    self.games = []
    self.layout = []
  }
  
  func getGames() {
    do {
      games = try VideoGamePreferenceService.getVideoGames()
    } catch {
      print(error)
    }
  }
  
  func getLayout() {
    layout = UserDefaults.standard.array(forKey: Constants.homeViewSections) as? [Int] ?? [-69]
  }
  
  func deleteGames() {
    VideoGamePreferenceService.deleteAllVideoGames()
    getGames()
  }
}
