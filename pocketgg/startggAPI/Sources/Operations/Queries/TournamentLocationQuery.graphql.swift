// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class TournamentLocationQuery: GraphQLQuery {
  public static let operationName: String = "TournamentLocationQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query TournamentLocationQuery($id: ID) { tournament(id: $id) { __typename venueAddress isOnline } }"#
    ))

  public var id: GraphQLNullable<ID>

  public init(id: GraphQLNullable<ID>) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: StartggAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("tournament", Tournament?.self, arguments: ["id": .variable("id")]),
    ] }

    /// Returns a tournament given its id or slug
    public var tournament: Tournament? { __data["tournament"] }

    /// Tournament
    ///
    /// Parent Type: `Tournament`
    public struct Tournament: StartggAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Tournament }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("venueAddress", String?.self),
        .field("isOnline", Bool?.self),
      ] }

      public var venueAddress: String? { __data["venueAddress"] }
      /// True if tournament has at least one online event
      public var isOnline: Bool? { __data["isOnline"] }
    }
  }
}
