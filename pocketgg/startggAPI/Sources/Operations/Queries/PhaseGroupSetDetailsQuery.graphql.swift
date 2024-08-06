// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PhaseGroupSetDetailsQuery: GraphQLQuery {
  public static let operationName: String = "PhaseGroupSetDetails"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query PhaseGroupSetDetails($id: ID!) { set(id: $id) { __typename state round identifier fullRoundText displayScore winnerId slots { __typename prereqId entrant { __typename id name participants { __typename gamerTag } initialSeedNum } } station { __typename number } stream { __typename streamName streamLogo streamSource streamId } games { __typename id orderNum winnerId stage { __typename name } } } }"#
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
        .field("state", Int?.self),
        .field("round", Int?.self),
        .field("identifier", String?.self),
        .field("fullRoundText", String?.self),
        .field("displayScore", String?.self),
        .field("winnerId", Int?.self),
        .field("slots", [Slot?]?.self),
        .field("station", Station?.self),
        .field("stream", Stream?.self),
        .field("games", [Game?]?.self),
      ] }

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
      /// Tournament event station for a set
      public var station: Station? { __data["station"] }
      /// Tournament event stream for a set
      public var stream: Stream? { __data["stream"] }
      public var games: [Game?]? { __data["games"] }

      /// Set.Slot
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

        /// Set.Slot.Entrant
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
            .field("initialSeedNum", Int?.self),
          ] }

          public var id: StartggAPI.ID? { __data["id"] }
          /// The entrant name as it appears in bracket: gamerTag of the participant or team name
          public var name: String? { __data["name"] }
          public var participants: [Participant?]? { __data["participants"] }
          /// Entrant's seed number in the first phase of the event.
          public var initialSeedNum: Int? { __data["initialSeedNum"] }

          /// Set.Slot.Entrant.Participant
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

      /// Set.Station
      ///
      /// Parent Type: `Stations`
      public struct Station: StartggAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Stations }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("number", Int?.self),
        ] }

        public var number: Int? { __data["number"] }
      }

      /// Set.Stream
      ///
      /// Parent Type: `Streams`
      public struct Stream: StartggAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Streams }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("streamName", String?.self),
          .field("streamLogo", String?.self),
          .field("streamSource", GraphQLEnum<StartggAPI.StreamSource>?.self),
          .field("streamId", String?.self),
        ] }

        public var streamName: String? { __data["streamName"] }
        public var streamLogo: String? { __data["streamLogo"] }
        public var streamSource: GraphQLEnum<StartggAPI.StreamSource>? { __data["streamSource"] }
        public var streamId: String? { __data["streamId"] }
      }

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
