import Foundation
import Apollo
import StartggAPI

protocol StartggServiceType {
  func getFeaturedTournaments(pageNum: Int, gameIDs: [Int]) async throws -> [TournamentData]
  func getTournamentDetails(id: Int) async throws -> TournamentDetails?
  func getTournamentLocation(id: Int) async throws -> String?
}

class StartggService: StartggServiceType {
  static let shared = StartggService()
  
  private(set) lazy var apollo: ApolloClient = {
    let client = URLSessionClient()
    let cache = InMemoryNormalizedCache()
    let store = ApolloStore(cache: cache)
    let provider = NetworkInterceptorProvider(client: client, store: store)
    let url = URL(string: "https://api.start.gg/gql/alpha")!
    let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
    return ApolloClient(networkTransport: transport, store: store)
  }()
  
  func updateApolloClient() {
    let client = URLSessionClient()
    let cache = InMemoryNormalizedCache()
    let store = ApolloStore(cache: cache)
    let provider = NetworkInterceptorProvider(client: client, store: store)
    let url = URL(string: "https://api.start.gg/gql/alpha")!
    let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
    apollo = ApolloClient(networkTransport: transport, store: store)
  }
}
