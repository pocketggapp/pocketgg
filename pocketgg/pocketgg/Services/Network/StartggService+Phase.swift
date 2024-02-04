import Foundation
import StartggAPI

extension StartggService {
  func getPhaseGroups(id: Int, numPhaseGroups: Int) async throws -> [PhaseGroup]? {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: PhaseGroupsQuery(id: .some(String(id)), perPage: .some(numPhaseGroups))
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let nodes = graphQLResult.data?.phase?.phaseGroups?.nodes else {
            continuation.resume(returning: nil)
            return
          }
          
          let phaseGroups: [PhaseGroup] = nodes.compactMap {
            guard let id = Int($0?.id ?? "nil") else { return nil }
            
            return PhaseGroup(
              id: id,
              name: $0?.displayIdentifier,
              state: ActivityState.allCases[($0?.state ?? 5) - 1].rawValue.capitalized
            )
          }
          
          continuation.resume(returning: (phaseGroups))
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
