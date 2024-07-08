// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PhaseGroupStandingsPageQuery: GraphQLQuery {
  public static let operationName: String = "PhaseGroupStandingsPage"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query PhaseGroupStandingsPage($id: ID, $page: Int) { phaseGroup(id: $id) { __typename standings(query: {page: $page, perPage: 65}) { __typename nodes { __typename placement entrant { __typename id name participants { __typename gamerTag } } } } } }"#
    ))

  public var id: GraphQLNullable<ID>
  public var page: GraphQLNullable<Int>

  public init(
    id: GraphQLNullable<ID>,
    page: GraphQLNullable<Int>
  ) {
    self.id = id
    self.page = page
  }

  public var __variables: Variables? { [
    "id": id,
    "page": page
  ] }

  public struct Data: StartggAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("phaseGroup", PhaseGroup?.self, arguments: ["id": .variable("id")]),
    ] }

    /// Returns a phase group given its id
    public var phaseGroup: PhaseGroup? { __data["phaseGroup"] }

    /// PhaseGroup
    ///
    /// Parent Type: `PhaseGroup`
    public struct PhaseGroup: StartggAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.PhaseGroup }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("standings", Standings?.self, arguments: ["query": [
          "page": .variable("page"),
          "perPage": 65
        ]]),
      ] }

      /// Paginated list of standings
      public var standings: Standings? { __data["standings"] }

      /// PhaseGroup.Standings
      ///
      /// Parent Type: `StandingConnection`
      public struct Standings: StartggAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.StandingConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        public var nodes: [Node?]? { __data["nodes"] }

        /// PhaseGroup.Standings.Node
        ///
        /// Parent Type: `Standing`
        public struct Node: StartggAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Standing }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("placement", Int?.self),
            .field("entrant", Entrant?.self),
          ] }

          public var placement: Int? { __data["placement"] }
          /// If the entity this standing is assigned to can be resolved into an entrant, this will provide the entrant.
          public var entrant: Entrant? { __data["entrant"] }

          /// PhaseGroup.Standings.Node.Entrant
          ///
          /// Parent Type: `Entrant`
          public struct Entrant: StartggAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Entrant }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", StartggAPI.ID?.self),
              .field("name", String?.self),
              .field("participants", [Participant?]?.self),
            ] }

            public var id: StartggAPI.ID? { __data["id"] }
            /// The entrant name as it appears in bracket: gamerTag of the participant or team name
            public var name: String? { __data["name"] }
            public var participants: [Participant?]? { __data["participants"] }

            /// PhaseGroup.Standings.Node.Entrant.Participant
            ///
            /// Parent Type: `Participant`
            public struct Participant: StartggAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Participant }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("gamerTag", String?.self),
              ] }

              /// The tag that was used when the participant registered, e.g. Mang0
              public var gamerTag: String? { __data["gamerTag"] }
            }
          }
        }
      }
    }
  }
}
