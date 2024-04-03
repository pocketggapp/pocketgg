import SwiftUI

struct EditPinnedTournamentsView: View {
  @Environment(\.dismiss) private var dismiss
  
  @StateObject private var viewModel: EditPinnedTournamentsViewModel
  
  init(_ pinnedTournaments: [Tournament]) {
    self._viewModel = StateObject(wrappedValue: {
      EditPinnedTournamentsViewModel(pinnedTournaments)
    }())
  }
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(viewModel.pinnedTournaments, id: \.id) {
          TournamentRowView(tournament: $0)
        }
        .onMove(perform: viewModel.movePinnedTournament)
        .onDelete(perform: viewModel.deletePinnedTournament)
      }
      .environment(\.editMode, .constant(.active))
      .toolbar {
        ToolbarItemGroup(placement: .topBarTrailing) {
          Button {
            dismiss()
          } label: {
            Text("Done")
              .font(.headline)
          }
        }
      }
      .navigationTitle("Edit Pinned Tournaments")
    }
  }
}

#Preview {
  EditPinnedTournamentsView(
    [MockStartggService.createTournament(id: 0)]
  )
}
