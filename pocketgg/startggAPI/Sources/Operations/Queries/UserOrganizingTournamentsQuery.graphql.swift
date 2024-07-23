// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UserOrganizingTournamentsQuery: GraphQLQuery {
  public static let operationName: String = "UserOrganizingTournaments"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query UserOrganizingTournaments($id: ID, $pageNum: Int, $perPage: Int) { user(id: $id) { __typename tournaments( query: {perPage: $perPage, page: $pageNum, filter: {tournamentView: "organizing"}} ) { __typename nodes { __typename id name startAt endAt isOnline city addrState countryCode images { __typename url type ratio } } } } }"#
    ))

  public var id: GraphQLNullable<ID>
  public var pageNum: GraphQLNullable<Int>
  public var perPage: GraphQLNullable<Int>

  public init(
    id: GraphQLNullable<ID>,
    pageNum: GraphQLNullable<Int>,
    perPage: GraphQLNullable<Int>
  ) {
    self.id = id
    self.pageNum = pageNum
    self.perPage = perPage
  }

  public var __variables: Variables? { [
    "id": id,
    "pageNum": pageNum,
    "perPage": perPage
  ] }

  public struct Data: StartggAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User?.self, arguments: ["id": .variable("id")]),
    ] }

    /// Returns a user given a user slug of the form user/abc123, or id
    public var user: User? { __data["user"] }

    /// User
    ///
    /// Parent Type: `User`
    public struct User: StartggAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("tournaments", Tournaments?.self, arguments: ["query": [
          "perPage": .variable("perPage"),
          "page": .variable("pageNum"),
          "filter": ["tournamentView": "organizing"]
        ]]),
      ] }

      /// Tournaments this user is organizing or competing in
      public var tournaments: Tournaments? { __data["tournaments"] }

      /// User.Tournaments
      ///
      /// Parent Type: `TournamentConnection`
      public struct Tournaments: StartggAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.TournamentConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        public var nodes: [Node?]? { __data["nodes"] }

        /// User.Tournaments.Node
        ///
        /// Parent Type: `Tournament`
        public struct Node: StartggAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Tournament }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", StartggAPI.ID?.self),
            .field("name", String?.self),
            .field("startAt", StartggAPI.Timestamp?.self),
            .field("endAt", StartggAPI.Timestamp?.self),
            .field("isOnline", Bool?.self),
            .field("city", String?.self),
            .field("addrState", String?.self),
            .field("countryCode", String?.self),
            .field("images", [Image?]?.self),
          ] }

          public var id: StartggAPI.ID? { __data["id"] }
          /// The tournament name
          public var name: String? { __data["name"] }
          /// When the tournament Starts
          public var startAt: StartggAPI.Timestamp? { __data["startAt"] }
          /// When the tournament ends
          public var endAt: StartggAPI.Timestamp? { __data["endAt"] }
          /// True if tournament has at least one online event
          public var isOnline: Bool? { __data["isOnline"] }
          public var city: String? { __data["city"] }
          public var addrState: String? { __data["addrState"] }
          public var countryCode: String? { __data["countryCode"] }
          public var images: [Image?]? { __data["images"] }

          /// User.Tournaments.Node.Image
          ///
          /// Parent Type: `Image`
          public struct Image: StartggAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Image }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("url", String?.self),
              .field("type", String?.self),
              .field("ratio", Double?.self),
            ] }

            public var url: String? { __data["url"] }
            public var type: String? { __data["type"] }
            public var ratio: Double? { __data["ratio"] }
          }
        }
      }
    }
  }
}
