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
          EmptyStateView(
            systemImageName: "person.fill.questionmark",
            title: "No Contact Info",
            subtitle: "There is currently no contact info for this tournament"
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
