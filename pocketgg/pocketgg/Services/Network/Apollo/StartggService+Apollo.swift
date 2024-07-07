import Foundation
import Apollo
import StartggAPI

protocol StartggServiceType {
  func getFeaturedTournaments(pageNum: Int, perPage: Int, gameIDs: [Int]) async throws -> [Tournament]
  func getUpcomingTournaments(pageNum: Int, perPage: Int, gameIDs: [Int]) async throws -> [Tournament]
  func getUpcomingTournamentsNearLocation(pageNum: Int, perPage: Int, gameIDs: [Int], coordinates: String, radius: String) async throws -> [Tournament]
  func getOnlineTournaments(pageNum: Int, perPage: Int, gameIDs: [Int]) async throws -> [Tournament]
  func getTournament(id: Int) async throws -> Tournament?
  func getTournamentDetails(id: Int) async throws -> TournamentDetails?
  func getEventDetails(id: Int) async throws -> EventDetails?
  func getEventStandings(id: Int, page: Int) async throws -> [Standing]?
  func getPhaseGroups(id: Int, numPhaseGroups: Int) async throws -> [PhaseGroup]?
  func getPhaseGroupDetails(id: Int) async throws -> PhaseGroupDetails?
  func getRemainingPhaseGroupSets(id: Int, pageNum: Int) async throws -> [PhaseGroupSet]
  func getPhaseGroupSetGames(id: Int) async throws -> [PhaseGroupSetGame]
  func getUserAdminTournaments(userID: Int, pageNum: Int, perPage: Int) async throws -> [Tournament]
  func getTournamentsBySearchTerm(name: String, pageNum: Int, perPage: Int) async throws -> [Tournament]
  func getCurrentUserProfile() async throws -> Profile?
  func getCurrentUserTournaments(pageNum: Int, perPage: Int) async throws -> [Tournament]
  func getVideoGames(name: String, page: Int, accumulatedVideoGameIDs: Set<Int>) async throws -> [VideoGame]?
}

class StartggService: StartggServiceType {
  static let shared = StartggService()
  
  private(set) var apollo = ApolloClient(url: URL(string: "https://api.start.gg/gql/alpha")!)
  
  func updateApolloClient() {
    let store = ApolloStore(cache: InMemoryNormalizedCache())
    let transport = RequestChainNetworkTransport(
      interceptorProvider: NetworkInterceptorProvider(client: URLSessionClient(), store: store),
      endpointURL: URL(string: "https://api.start.gg/gql/alpha")!
    )
    apollo = ApolloClient(networkTransport: transport, store: store)
  }
}
