import SwiftUI

struct VideoGamesView: View {
  @State private var enabledGames = ["Test1", "Test2", "Test3"]
  
  var body: some View {
    List {
      Section {
        ForEach(enabledGames, id: \.self) { game in
          Text(game)
        }
        .onDelete(perform: delete)
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
          .foregroundColor(.red)
        }
      }
    }
    .listStyle(.insetGrouped)
    .toolbar { EditButton() }
    .navigationTitle("Video Game Selection")
  }
  
  private func delete(at offsets: IndexSet) {
    
  }
}

#Preview {
  VideoGamesView()
}
