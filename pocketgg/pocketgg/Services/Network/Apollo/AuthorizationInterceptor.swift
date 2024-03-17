import Foundation
import Apollo
import ApolloAPI

class AuthorizationInterceptor: ApolloInterceptor {
  var id: String = ""
  
  func interceptAsync<Operation>(
    chain: RequestChain,
    request: HTTPRequest<Operation>,
    response: HTTPResponse<Operation>?,
    completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
  ) where Operation : GraphQLOperation {
    var accessToken = ""
    do {
      accessToken = try KeychainService.getToken(.accessToken)
      request.addHeader(name: "authorization", value: "Bearer \(accessToken)")
    } catch {
      #if DEBUG
      print("AuthorizationInterceptor: \(error)")
      #endif
    }

    chain.proceedAsync(request: request, response: response, interceptor: self, completion: completion)
  }
}

class NetworkInterceptorProvider: DefaultInterceptorProvider {
  override func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation : GraphQLOperation {
    var interceptors = super.interceptors(for: operation)
    interceptors.insert(AuthorizationInterceptor(), at: 0)
    return interceptors
  }
}
