// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PhaseGroupQuery: GraphQLQuery {
  public static let operationName: String = "PhaseGroup"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query PhaseGroup($id: ID) { phaseGroup(id: $id) { __typename bracketType progressionsOut { __typename originPlacement } standings(query: {page: 1, perPage: 65}) { __typename nodes { __typename placement entrant { __typename id name participants { __typename gamerTag } } } } sets(page: 1, perPage: 90) { __typename nodes { __typename id state round identifier fullRoundText displayScore winnerId slots { __typename prereqId entrant { __typename id name participants { __typename gamerTag } } } } } } }"#
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
        .field("bracketType", GraphQLEnum<StartggAPI.BracketType>?.self),
        .field("progressionsOut", [ProgressionsOut?]?.self),
        .field("standings", Standings?.self, arguments: ["query": [
          "page": 1,
          "perPage": 65
        ]]),
        .field("sets", Sets?.self, arguments: [
          "page": 1,
          "perPage": 90
        ]),
      ] }

      /// The bracket type of this group's phase.
      public var bracketType: GraphQLEnum<StartggAPI.BracketType>? { __data["bracketType"] }
      /// The progressions out of this phase group
      public var progressionsOut: [ProgressionsOut?]? { __data["progressionsOut"] }
      /// Paginated list of standings
      public var standings: Standings? { __data["standings"] }
      /// Paginated sets on this phaseGroup
      public var sets: Sets? { __data["sets"] }

      /// PhaseGroup.ProgressionsOut
      ///
      /// Parent Type: `Progression`
      public struct ProgressionsOut: StartggAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Progression }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("originPlacement", Int?.self),
        ] }

        public var originPlacement: Int? { __data["originPlacement"] }
      }

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

      /// PhaseGroup.Sets
      ///
      /// Parent Type: `SetConnection`
      public struct Sets: StartggAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.SetConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        public var nodes: [Node?]? { __data["nodes"] }

        /// PhaseGroup.Sets.Node
        ///
        /// Parent Type: `Set`
        public struct Node: StartggAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Set }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", StartggAPI.ID?.self),
            .field("state", Int?.self),
            .field("round", Int?.self),
            .field("identifier", String?.self),
            .field("fullRoundText", String?.self),
            .field("displayScore", String?.self),
            .field("winnerId", Int?.self),
            .field("slots", [Slot?]?.self),
          ] }

          public var id: StartggAPI.ID? { __data["id"] }
          public var state: Int? { __data["state"] }
          /// The round number of the set. Negative numbers are losers bracket
          public var round: Int? { __data["round"] }
          /// The letters that describe a unique identifier within the pool. Eg. F, AT
          public var identifier: String? { __data["identifier"] }
          /// Full round text of this set.
          public var fullRoundText: String? { __data["fullRoundText"] }
          public var displayScore: String? { __data["displayScore"] }
          public var winnerId: Int? { __data["winnerId"] }
          /// A possible spot in a set. Use this to get all entrants in a set. Use this for all bracket types (FFA, elimination, etc)
          public var slots: [Slot?]? { __data["slots"] }

          /// PhaseGroup.Sets.Node.Slot
          ///
          /// Parent Type: `SetSlot`
          public struct Slot: StartggAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.SetSlot }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("prereqId", String?.self),
              .field("entrant", Entrant?.self),
            ] }

            /// Pairs with prereqType, is the ID of the prereq.
            public var prereqId: String? { __data["prereqId"] }
            public var entrant: Entrant? { __data["entrant"] }

            /// PhaseGroup.Sets.Node.Slot.Entrant
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

              /// PhaseGroup.Sets.Node.Slot.Entrant.Participant
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
}
