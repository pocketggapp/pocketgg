import SwiftUI

struct HomeView: View {
  @StateObject private var viewModel: HomeViewModel
  @State private var showingEditView = false
  
  init(viewModel: HomeViewModel) {
    self._viewModel = StateObject(wrappedValue: { viewModel }())
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVStack(spacing: 32) {
          ForEach(viewModel.tournamentGroups) { tournamentGroup in
            TournamentHorizontalListView(tournamentsGroup: tournamentGroup)
                .listRowInsets(EdgeInsets())
          }
        }
      }
      .navigationTitle("Tournaments")
      .navigationDestination(for: TournamentData.self) { tournament in
        EmptyView()
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Edit") {
            showingEditView = true
          }
        }
      }
      .alert("Error", isPresented: $viewModel.showingAlert, actions: {}, message: {
        Text(viewModel.alertMessage)
      })
    }
    .onAppear {
      viewModel.onViewAppear()
    }
    .sheet(isPresented: $showingEditView) {
      print("EDIT HOME DISMISSED")
    } content: {
      EditHomeView()
    }
  }
}

#Preview {
  HomeView(viewModel: HomeViewModel(oAuthService: OAuthService()))
}
