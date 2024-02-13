// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class TournamentDetailsQuery: GraphQLQuery {
  public static let operationName: String = "TournamentDetails"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query TournamentDetails($id: ID) { tournament(id: $id) { __typename events { __typename id name state standings(query: {perPage: 1}) { __typename nodes { __typename entrant { __typename id name participants { __typename gamerTag } } } } startAt type videogame { __typename name images { __typename url ratio } } } streams { __typename streamName streamLogo streamSource streamId } lat lng venueName venueAddress isRegistrationOpen registrationClosesAt primaryContact primaryContactType slug } }"#
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
        .field("events", [Event?]?.self),
        .field("streams", [Stream?]?.self),
        .field("lat", Double?.self),
        .field("lng", Double?.self),
        .field("venueName", String?.self),
        .field("venueAddress", String?.self),
        .field("isRegistrationOpen", Bool?.self),
        .field("registrationClosesAt", StartggAPI.Timestamp?.self),
        .field("primaryContact", String?.self),
        .field("primaryContactType", String?.self),
        .field("slug", String?.self),
      ] }

      public var events: [Event?]? { __data["events"] }
      public var streams: [Stream?]? { __data["streams"] }
      public var lat: Double? { __data["lat"] }
      public var lng: Double? { __data["lng"] }
      public var venueName: String? { __data["venueName"] }
      public var venueAddress: String? { __data["venueAddress"] }
      /// Is tournament registration open
      public var isRegistrationOpen: Bool? { __data["isRegistrationOpen"] }
      /// When does registration for the tournament end
      public var registrationClosesAt: StartggAPI.Timestamp? { __data["registrationClosesAt"] }
      public var primaryContact: String? { __data["primaryContact"] }
      public var primaryContactType: String? { __data["primaryContactType"] }
      /// The slug used to form the url
      public var slug: String? { __data["slug"] }

      /// Tournament.Event
      ///
      /// Parent Type: `Event`
      public struct Event: StartggAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Event }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", StartggAPI.ID?.self),
          .field("name", String?.self),
          .field("state", GraphQLEnum<StartggAPI.ActivityState>?.self),
          .field("standings", Standings?.self, arguments: ["query": ["perPage": 1]]),
          .field("startAt", StartggAPI.Timestamp?.self),
          .field("type", Int?.self),
          .field("videogame", Videogame?.self),
        ] }

        public var id: StartggAPI.ID? { __data["id"] }
        /// Title of event set by organizer
        public var name: String? { __data["name"] }
        /// The state of the Event.
        public var state: GraphQLEnum<StartggAPI.ActivityState>? { __data["state"] }
        /// Paginated list of standings
        public var standings: Standings? { __data["standings"] }
        /// When does this event start?
        public var startAt: StartggAPI.Timestamp? { __data["startAt"] }
        /// The type of the event, whether an entrant will have one participant or multiple
        public var type: Int? { __data["type"] }
        public var videogame: Videogame? { __data["videogame"] }

        /// Tournament.Event.Standings
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

          /// Tournament.Event.Standings.Node
          ///
          /// Parent Type: `Standing`
          public struct Node: StartggAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Standing }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("entrant", Entrant?.self),
            ] }

            /// If the entity this standing is assigned to can be resolved into an entrant, this will provide the entrant.
            public var entrant: Entrant? { __data["entrant"] }

            /// Tournament.Event.Standings.Node.Entrant
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

              /// Tournament.Event.Standings.Node.Entrant.Participant
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

        /// Tournament.Event.Videogame
        ///
        /// Parent Type: `Videogame`
        public struct Videogame: StartggAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Videogame }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("name", String?.self),
            .field("images", [Image?]?.self),
          ] }

          public var name: String? { __data["name"] }
          public var images: [Image?]? { __data["images"] }

          /// Tournament.Event.Videogame.Image
          ///
          /// Parent Type: `Image`
          public struct Image: StartggAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { StartggAPI.Objects.Image }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("url", String?.self),
              .field("ratio", Double?.self),
            ] }

            public var url: String? { __data["url"] }
            public var ratio: Double? { __data["ratio"] }
          }
        }
      }

      /// Tournament.Stream
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
    }
  }
}
