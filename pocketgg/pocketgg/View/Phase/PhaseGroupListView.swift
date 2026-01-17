import SwiftUI

struct PhaseGroupListView: View {
  @StateObject private var viewModel: PhaseGroupListViewModel
  
  private let phase: Phase
  
  init(
    phase: Phase,
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      PhaseGroupListViewModel(
        phase: phase,
        service: service
      )
    }())
    self.phase = phase
  }
  
  var body: some View {
    List {
      Section {
        VStack(alignment: .leading) {
          Text(phase.name ?? "")
            .font(.body)
          
          Text(viewModel.headerSubtitleText)
            .font(.caption)
        }
      }
      
      switch viewModel.state {
      case .uninitialized, .loading:
        ForEach(0..<20) { _ in
          Text("Phase Placeholder")
            .redacted(reason: .placeholder)
        }
      case .loaded(let phaseGroups):
        if let phaseGroups, !phaseGroups.isEmpty {
          ForEach(phaseGroups, id: \.id) { phaseGroup in
            NavigationLink(value: phaseGroup) {
              HStack {
                Text("Pool \(phaseGroup.name ?? "")")
                
                Spacer()
                
                Text(phaseGroup.state.rawValue.localizedCapitalized)
                  .foregroundStyle(.gray)
              }
            }
            .buttonStyle(.plain)
          }
        } else {
          ContentUnavailableView(
            "No Pools",
            systemImage: "questionmark.app.dashed",
            description: Text("There are currently no pools for this phase.")
          )
        }
      case .error(let is503):
        ErrorStateView(is503: is503, subtitle: "There was an error loading this phase.") {
          Task {
            await viewModel.fetchPhaseGroups(refreshed: true)
          }
        }
      }
    }
    .task {
      await viewModel.fetchPhaseGroups()
    }
    .refreshable {
      await viewModel.fetchPhaseGroups(refreshed: true)
    }
    .listStyle(.insetGrouped)
    .navigationTitle(phase.name ?? "")
    .navigationDestination(for: PhaseGroup.self) {
      PhaseGroupView(
        phaseGroup: $0,
        phaseID: nil,
        title: "Pool \($0.name ?? "")"
      )
    }
  }
}

#Preview {
  PhaseGroupListView(
    phase: MockStartggService.createPhase(),
    service: MockStartggService()
  )
}
