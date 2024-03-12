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
        ForEach(1..<10) { _ in
          StreamPlaceholderView()
        }
      case .loaded(let tournamentDetails):
        if let streams = tournamentDetails?.streams, !streams.isEmpty {
          ForEach(streams, id: \.id) { stream in
            StreamRowView(stream: stream)
          }
        } else {
          EmptyStateView(
            systemImageName: "questionmark.video",
            title: "No Streams",
            subtitle: "There are currently no streams for this tournament"
          )
        }
      case .error:
        ErrorStateView(subtitle: "There was an error loading this tournament") {
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
