import SwiftUI

struct PhaseGroupSetView: View {
  @StateObject private var viewModel: PhaseGroupSetViewModel
  
  init(
    id: Int,
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      PhaseGroupSetViewModel(
        id: id,
        service: service
      )
    }())
  }
  
  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading) {
        switch viewModel.state {
        case .uninitialized, .loading:
          MatchRowPlaceholderView()
            .padding(.bottom, 32)
          
          ForEach(0..<5) { _ in
            TextWithCaptionPlaceholderView()
          }
        case .loaded(let setDetails):
          if let phaseGroupSet = setDetails?.phaseGroupSet {
            MatchRowView(phaseGroupSet: phaseGroupSet)
              .padding(.bottom, 32)
          }
          
          if let stationNum = setDetails?.stationNum {
            StationSectionView(stationNum)
              .padding(.bottom)
          }
          
          if let stream = setDetails?.stream {
            StreamSectionView(stream)
              .padding(.bottom)
          }
          
          Text("Games")
            .font(.headline)
          
          if let games = setDetails?.games, !games.isEmpty {
            GamesSectionView(
              games: games,
              entrants: setDetails?.phaseGroupSet.entrants
            )
          } else {
            ContentUnavailableView(
              "No Games Reported",
              systemImage: "questionmark.app.dashed",
              description: Text("Once games are reported, the results will display here.")
            )
          }
        case .error(let is503):
          ErrorStateView(is503: is503, subtitle: "There was an error loading this set.") {
            Task {
              await viewModel.fetchPhaseGroupSet(refreshed: true)
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
  
  // MARK: Sections
  
  @ViewBuilder
  private func StationSectionView(_ stationNum: Int) -> some View {
    VStack(alignment: .leading,spacing: 5) {
      Text("Station")
        .font(.headline)
      
      Text("Station \(stationNum)")
        .font(.title3)
    }
  }
  
  @ViewBuilder
  private func StreamSectionView(_ stream: Stream) -> some View {
    VStack(alignment: .leading, spacing: 5) {
      Text("Stream")
        .font(.headline)
      
      StreamRowView(stream: stream)
    }
  }
  
  @ViewBuilder
  private func GamesSectionView(games: [PhaseGroupSetGame], entrants: [PhaseGroupSetEntrant]?) -> some View {
    ForEach(games, id: \.id) {
      PhaseGroupSetGameRowView(
        game: $0,
        setEntrants: entrants?.compactMap { $0.entrant } ?? []
      )
    }
  }
}

#Preview {
  PhaseGroupSetView(
    id: 1,
    service: MockStartggService()
  )
}
