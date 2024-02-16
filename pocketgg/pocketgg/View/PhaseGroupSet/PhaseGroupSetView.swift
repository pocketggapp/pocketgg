import SwiftUI

struct PhaseGroupSetView: View {
  @StateObject private var viewModel: PhaseGroupSetViewModel
  
  private let phaseGroupSet: PhaseGroupSet
  
  init(
    phaseGroupSet: PhaseGroupSet,
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      PhaseGroupSetViewModel(
        phaseGroupSet: phaseGroupSet,
        service: service
      )
    }())
    self.phaseGroupSet = phaseGroupSet
  }
  
  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading) {
        MatchRowView(phaseGroupSet: phaseGroupSet)
          .padding(.bottom, 32)
        
        Text("Games")
          .font(.headline)
        
        VStack(alignment: .leading) {
          switch viewModel.state {
          case .uninitialized, .loading:
            ForEach(0..<5) { _ in
              TextWithCaptionPlaceholderView()
            }
          case .loaded(let games):
            if !games.isEmpty {
              ForEach(games) {
                PhaseGroupSetGameRowView(
                  game: $0,
                  setEntrants: phaseGroupSet.entrants?.compactMap { $0.entrant } ?? []
                )
              }
            } else {
              EmptyStateView(
                systemImageName: "questionmark.app.dashed",
                title: "No Games Reported",
                subtitle: "Once games are reported, the results will display here"
              )
            }
          case .error:
            ErrorStateView(subtitle: "There was an error loading this set") {
              Task {
                await viewModel.fetchPhaseGroupSet(refreshed: true)
              }
            }
          }
        }
        Spacer()
      }
    }
    .task {
      await viewModel.fetchPhaseGroupSet()
    }
    .refreshable {
      await viewModel.fetchPhaseGroupSet(refreshed: true)
    }
  }
}

#Preview {
  PhaseGroupSetView(
    phaseGroupSet: MockStartggService.createPhaseGroupSet(),
    service: MockStartggService()
  )
}
