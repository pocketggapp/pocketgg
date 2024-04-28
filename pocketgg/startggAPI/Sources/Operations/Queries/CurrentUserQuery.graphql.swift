// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CurrentUserQuery: GraphQLQuery {
  public static let operationName: String = "CurrentUser"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query CurrentUser { currentUser { __typename id bio player { __typename prefix gamerTag } images { __typename type url ratio } tournaments(query: {perPage: 10, page: 1}) { __typename nodes { __typename id name startAt endAt isOnline city addrState countryCode images { __typename url type ratio } } } } }"#
    ))

  public init() {}

  public struct Data: StartggAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("currentUser", CurrentUser?.self),
    ] }

    /// Returns the authenticated user
    public var currentUser: CurrentUser? { __data["currentUser"] }

    /// CurrentUser
    ///
    /// Parent Type: `User`
    public struct CurrentUser: StartggAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", StartggAPI.ID?.self),
        .field("bio", String?.self),
        .field("player", Player?.self),
        .field("images", [Image?]?.self),
        .field("tournaments", Tournaments?.self, arguments: ["query": [
          "perPage": 10,
          "page": 1
        ]]),
      ] }

      public var id: StartggAPI.ID? { __data["id"] }
      public var bio: String? { __data["bio"] }
      /// player for user
      public var player: Player? { __data["player"] }
      public var images: [Image?]? { __data["images"] }
      /// Tournaments this user is organizing or competing in
      public var tournaments: Tournaments? { __data["tournaments"] }

      /// CurrentUser.Player
      ///
      /// Parent Type: `Player`
      public struct Player: StartggAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Player }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("prefix", String?.self),
          .field("gamerTag", String?.self),
        ] }

        public var prefix: String? { __data["prefix"] }
        public var gamerTag: String? { __data["gamerTag"] }
      }

      /// CurrentUser.Image
      ///
      /// Parent Type: `Image`
      public struct Image: StartggAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Image }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("type", String?.self),
          .field("url", String?.self),
          .field("ratio", Double?.self),
        ] }

        public var type: String? { __data["type"] }
        public var url: String? { __data["url"] }
        public var ratio: Double? { __data["ratio"] }
      }

      /// CurrentUser.Tournaments
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

        /// CurrentUser.Tournaments.Node
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

          /// CurrentUser.Tournaments.Node.Image
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
