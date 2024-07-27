import SwiftUI

struct InfoView: View {
  @Binding private var state: TournamentViewState
  
  private let reloadTournament: (() -> Void)
  
  init(state: Binding<TournamentViewState>, reloadTournament: @escaping () -> Void) {
    self._state = state
    self.reloadTournament = reloadTournament
  }
  
  var body: some View {
    VStack(spacing: 32) {
      switch state {
      case .uninitialized, .loading:
        ForEach(0..<3) { _ in
          InfoPlaceholderView()
        }
      case .loaded(let tournamentDetails):
        if let contactInfo = tournamentDetails?.contact.info,
           let contactType = tournamentDetails?.contact.type {
          ContactInfoRowView(contactInfo: contactInfo, contactType: contactType)
        }
        if let organizer = tournamentDetails?.organizer {
          TournamentOrganizerRowView(tournamentOrganizer: organizer)
        }
        RegistrationRowView(
          tournamentSlug: tournamentDetails?.slug,
          registrationOpen: tournamentDetails?.registrationOpen ?? false,
          registrationCloseDate: tournamentDetails?.registrationCloseDate ?? ""
        )
      case .error:
        ErrorStateView(subtitle: "There was an error loading this tournament.") {
          reloadTournament()
        }
      }
    }
    .padding()
  }
}

#Preview {
  InfoView(
    state: .constant(.loaded(MockStartggService.createTournamentDetails())),
    reloadTournament: { }
  )
}
