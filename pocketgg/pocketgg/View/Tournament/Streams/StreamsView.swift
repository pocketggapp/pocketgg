import SwiftUI

struct StreamsView: View {
  @Binding private var state: TournamentViewState
  
  private let reloadTournament: (() -> Void)
  
  init(state: Binding<TournamentViewState>, reloadTournament: @escaping () -> Void) {
    self._state = state
    self.reloadTournament = reloadTournament
  }
  
  var body: some View {
    VStack {
      switch state {
      case .uninitialized, .loading:
        ForEach(0..<10) { _ in
          StreamPlaceholderView()
        }
      case .loaded(let tournamentDetails):
        if let streams = tournamentDetails?.streams, !streams.isEmpty {
          ForEach(streams, id: \.self) { stream in
            StreamRowView(stream: stream)
          }
        } else {
          ContentUnavailableView(
            "No Streams",
            systemImage: "questionmark.video",
            description: Text("There are currently no streams for this tournament.")
          )
        }
      case .error(let is503):
        ErrorStateView(is503: is503, subtitle: "There was an error loading this tournament.") {
          reloadTournament()
        }
      }
    }
    .padding()
  }
}

#Preview {
  StreamsView(
    state: .constant(.loaded(MockStartggService.createTournamentDetails())),
    reloadTournament: { }
  )
}
