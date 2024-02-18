// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CurrentUserQuery: GraphQLQuery {
  public static let operationName: String = "CurrentUser"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query CurrentUser { currentUser { __typename id bio player { __typename prefix gamerTag } images { __typename type url ratio } } }"#
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
      ] }

      public var id: StartggAPI.ID? { __data["id"] }
      public var bio: String? { __data["bio"] }
      /// player for user
      public var player: Player? { __data["player"] }
      public var images: [Image?]? { __data["images"] }

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
    }
  }
}
