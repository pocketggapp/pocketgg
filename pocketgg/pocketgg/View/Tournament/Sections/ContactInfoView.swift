import SwiftUI

struct ContactInfoView: View {
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
        LocationPlaceholderView()
      case .loaded(let tournamentDetails):
        if let contactInfo = tournamentDetails?.contact.info,
           let contactType = tournamentDetails?.contact.type {
          ContactInfoRowView(contactInfo: contactInfo, contactType: contactType)
        } else {
          NoContactInfoView()
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
    streams: [],
    location: nil,
    contact: MockStartggService.createContactInfo()
  )
  return ContactInfoView(
    state: .constant(.loaded(tournamentDetails)),
    reloadTournament: { }
  )
}
