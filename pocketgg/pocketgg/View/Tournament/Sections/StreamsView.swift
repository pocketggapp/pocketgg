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
        StreamPlaceholderView()
        StreamPlaceholderView()
        StreamPlaceholderView()
        StreamPlaceholderView()
        StreamPlaceholderView()
      case .loaded(let tournamentDetails):
        if let streams = tournamentDetails?.streams, !streams.isEmpty {
          ForEach(streams) { stream in
            StreamRowView(stream: stream)
          }
        } else {
          NoStreamsView()
        }
      case .error:
        ErrorStateView {
          reloadTournament()
        }
      }
    }
    .padding()
  }
}

#Preview {
  let tournamentDetails = TournamentDetails(
    events: [],
    streams: MockStartggService.createStreams(),
    location: nil,
    contact: (nil, nil)
  )
  return StreamsView(
    state: .constant(.loaded(tournamentDetails)),
    reloadTournament: { }
  )
}
