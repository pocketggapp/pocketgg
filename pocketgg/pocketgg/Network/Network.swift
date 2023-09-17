import Foundation
import Apollo
import StartggAPI

class Network {
  static let shared = Network()

  private(set) lazy var apollo = ApolloClient(url: URL(string: "https://api.start.gg/gql/alpha")!)
}
