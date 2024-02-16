// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PhaseGroupSetGamesQuery: GraphQLQuery {
  public static let operationName: String = "PhaseGroupSetGames"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query PhaseGroupSetGames($id: ID!) { set(id: $id) { __typename games { __typename id orderNum winnerId stage { __typename name } } } }"#
    ))

  public var id: ID

  public init(id: ID) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: StartggAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("set", Set?.self, arguments: ["id": .variable("id")]),
    ] }

    /// Returns a set given its id
    public var set: Set? { __data["set"] }

    /// Set
    ///
    /// Parent Type: `Set`
    public struct Set: StartggAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Set }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("games", [Game?]?.self),
      ] }

      public var games: [Game?]? { __data["games"] }

      /// Set.Game
      ///
      /// Parent Type: `Game`
      public struct Game: StartggAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Game }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", StartggAPI.ID?.self),
          .field("orderNum", Int?.self),
          .field("winnerId", Int?.self),
          .field("stage", Stage?.self),
        ] }

        public var id: StartggAPI.ID? { __data["id"] }
        public var orderNum: Int? { __data["orderNum"] }
        public var winnerId: Int? { __data["winnerId"] }
        /// The stage that this game was played on (if applicable)
        public var stage: Stage? { __data["stage"] }

        /// Set.Game.Stage
        ///
        /// Parent Type: `Stage`
        public struct Stage: StartggAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Stage }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("name", String?.self),
          ] }

          /// Stage name
          public var name: String? { __data["name"] }
        }
      }
    }
  }
}
