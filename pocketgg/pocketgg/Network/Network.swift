import Foundation
import Apollo
import StartggAPI

class Network {
  static let shared = Network()
  
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
