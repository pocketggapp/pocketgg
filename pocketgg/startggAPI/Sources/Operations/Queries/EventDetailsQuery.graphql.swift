// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class EventDetailsQuery: GraphQLQuery {
  public static let operationName: String = "EventDetails"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query EventDetails($id: ID) { event(id: $id) { __typename phases { __typename id name state groupCount numSeeds bracketType } standings(query: {perPage: 65}) { __typename nodes { __typename placement entrant { __typename name participants { __typename gamerTag } } } } } }"#
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
      .field("event", Event?.self, arguments: ["id": .variable("id")]),
    ] }

    /// Returns an event given its id or slug
    public var event: Event? { __data["event"] }

    /// Event
    ///
    /// Parent Type: `Event`
    public struct Event: StartggAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Event }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("phases", [Phase?]?.self),
        .field("standings", Standings?.self, arguments: ["query": ["perPage": 65]]),
      ] }

      /// The phases that belong to an event.
      public var phases: [Phase?]? { __data["phases"] }
      /// Paginated list of standings
      public var standings: Standings? { __data["standings"] }

      /// Event.Phase
      ///
      /// Parent Type: `Phase`
      public struct Phase: StartggAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Phase }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", StartggAPI.ID?.self),
          .field("name", String?.self),
          .field("state", GraphQLEnum<StartggAPI.ActivityState>?.self),
          .field("groupCount", Int?.self),
          .field("numSeeds", Int?.self),
          .field("bracketType", GraphQLEnum<StartggAPI.BracketType>?.self),
        ] }

        public var id: StartggAPI.ID? { __data["id"] }
        /// Name of phase e.g. Round 1 Pools
        public var name: String? { __data["name"] }
        /// State of the phase
        public var state: GraphQLEnum<StartggAPI.ActivityState>? { __data["state"] }
        /// Number of phase groups in this phase
        public var groupCount: Int? { __data["groupCount"] }
        /// The number of seeds this phase contains.
        public var numSeeds: Int? { __data["numSeeds"] }
        /// The bracket type of this phase.
        public var bracketType: GraphQLEnum<StartggAPI.BracketType>? { __data["bracketType"] }
      }

      /// Event.Standings
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

        /// Event.Standings.Node
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

          /// Event.Standings.Node.Entrant
          ///
          /// Parent Type: `Entrant`
          public struct Entrant: StartggAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Entrant }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("name", String?.self),
              .field("participants", [Participant?]?.self),
            ] }

            /// The entrant name as it appears in bracket: gamerTag of the participant or team name
            public var name: String? { __data["name"] }
            public var participants: [Participant?]? { __data["participants"] }

            /// Event.Standings.Node.Entrant.Participant
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
