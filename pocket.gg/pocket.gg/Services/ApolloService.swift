import Foundation
import Apollo

class ApolloService {
    static let shared = ApolloService()
    
    private(set) lazy var client: ApolloClient = {
        let urlSessionClient = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(client: urlSessionClient, store: store)
        guard let url = URL(string: k.API.endpoint) else { fatalError() }
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
        return ApolloClient(networkTransport: transport, store: store)
    }()
    
    func updateApolloClient() {
        let urlSessionClient = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(client: urlSessionClient, store: store)
        guard let url = URL(string: k.API.endpoint) else { fatalError() }
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
        client = ApolloClient(networkTransport: transport, store: store)
    }
}

class NetworkInterceptorProvider: LegacyInterceptorProvider {
    override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(CustomInterceptor(), at: 0)
        return interceptors
    }
}

class CustomInterceptor: ApolloInterceptor {
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        
        let authToken = UserDefaults.standard.string(forKey: k.UserDefaults.authToken) ?? ""
        request.addHeader(name: "authorization", value: "Bearer \(authToken)")
        chain.proceedAsync(request: request, response: response, completion: completion)
    }
}
