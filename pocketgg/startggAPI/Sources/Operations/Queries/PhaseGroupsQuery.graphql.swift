// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PhaseGroupsQuery: GraphQLQuery {
  public static let operationName: String = "PhaseGroups"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query PhaseGroups($id: ID, $perPage: Int) { phase(id: $id) { __typename phaseGroups(query: {perPage: $perPage}) { __typename nodes { __typename id displayIdentifier state } } } }"#
    ))

  public var id: GraphQLNullable<ID>
  public var perPage: GraphQLNullable<Int>

  public init(
    id: GraphQLNullable<ID>,
    perPage: GraphQLNullable<Int>
  ) {
    self.id = id
    self.perPage = perPage
  }

  public var __variables: Variables? { [
    "id": id,
    "perPage": perPage
  ] }

  public struct Data: StartggAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("phase", Phase?.self, arguments: ["id": .variable("id")]),
    ] }

    /// Returns a phase given its id
    public var phase: Phase? { __data["phase"] }

    /// Phase
    ///
    /// Parent Type: `Phase`
    public struct Phase: StartggAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Phase }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("phaseGroups", PhaseGroups?.self, arguments: ["query": ["perPage": .variable("perPage")]]),
      ] }

      /// Phase groups under this phase, paginated
      public var phaseGroups: PhaseGroups? { __data["phaseGroups"] }

      /// Phase.PhaseGroups
      ///
      /// Parent Type: `PhaseGroupConnection`
      public struct PhaseGroups: StartggAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.PhaseGroupConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        public var nodes: [Node?]? { __data["nodes"] }

        /// Phase.PhaseGroups.Node
        ///
        /// Parent Type: `PhaseGroup`
        public struct Node: StartggAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.PhaseGroup }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", StartggAPI.ID?.self),
            .field("displayIdentifier", String?.self),
            .field("state", Int?.self),
          ] }

          public var id: StartggAPI.ID? { __data["id"] }
          /// Unique identifier for this group within the context of its phase
          public var displayIdentifier: String? { __data["displayIdentifier"] }
          public var state: Int? { __data["state"] }
        }
      }
    }
  }
}
