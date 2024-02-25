// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class VideoGamesQuery: GraphQLQuery {
  public static let operationName: String = "VideoGames"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query VideoGames($name: String, $pageNum: Int) { videogames(query: {perPage: 50, page: $pageNum, filter: {name: $name}}) { __typename nodes { __typename name id } } }"#
    ))

  public var name: GraphQLNullable<String>
  public var pageNum: GraphQLNullable<Int>

  public init(
    name: GraphQLNullable<String>,
    pageNum: GraphQLNullable<Int>
  ) {
    self.name = name
    self.pageNum = pageNum
  }

  public var __variables: Variables? { [
    "name": name,
    "pageNum": pageNum
  ] }

  public struct Data: StartggAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("videogames", Videogames?.self, arguments: ["query": [
        "perPage": 50,
        "page": .variable("pageNum"),
        "filter": ["name": .variable("name")]
      ]]),
    ] }

    /// Returns paginated list of videogames matching the search criteria.
    public var videogames: Videogames? { __data["videogames"] }

    /// Videogames
    ///
    /// Parent Type: `VideogameConnection`
    public struct Videogames: StartggAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.VideogameConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("nodes", [Node?]?.self),
      ] }

      public var nodes: [Node?]? { __data["nodes"] }

      /// Videogames.Node
      ///
      /// Parent Type: `Videogame`
      public struct Node: StartggAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Videogame }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String?.self),
          .field("id", StartggAPI.ID?.self),
        ] }

        public var name: String? { __data["name"] }
        public var id: StartggAPI.ID? { __data["id"] }
      }
    }
  }
}
