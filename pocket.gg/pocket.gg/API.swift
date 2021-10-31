// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// Represents the state of an activity
public enum ActivityState: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// Activity is created
  case created
  /// Activity is active or in progress
  case active
  /// Activity is done
  case completed
  /// Activity is ready to be started
  case ready
  /// Activity is invalid
  case invalid
  /// Activity, like a set, has been called to start
  case called
  /// Activity is queued to run
  case queued
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "CREATED": self = .created
      case "ACTIVE": self = .active
      case "COMPLETED": self = .completed
      case "READY": self = .ready
      case "INVALID": self = .invalid
      case "CALLED": self = .called
      case "QUEUED": self = .queued
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .created: return "CREATED"
      case .active: return "ACTIVE"
      case .completed: return "COMPLETED"
      case .ready: return "READY"
      case .invalid: return "INVALID"
      case .called: return "CALLED"
      case .queued: return "QUEUED"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: ActivityState, rhs: ActivityState) -> Bool {
    switch (lhs, rhs) {
      case (.created, .created): return true
      case (.active, .active): return true
      case (.completed, .completed): return true
      case (.ready, .ready): return true
      case (.invalid, .invalid): return true
      case (.called, .called): return true
      case (.queued, .queued): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [ActivityState] {
    return [
      .created,
      .active,
      .completed,
      .ready,
      .invalid,
      .called,
      .queued,
    ]
  }
}

/// The type of Bracket format that a Phase is configured with.
public enum BracketType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case singleElimination
  case doubleElimination
  case roundRobin
  case swiss
  case exhibition
  case customSchedule
  case matchmaking
  case eliminationRounds
  case race
  case circuit
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "SINGLE_ELIMINATION": self = .singleElimination
      case "DOUBLE_ELIMINATION": self = .doubleElimination
      case "ROUND_ROBIN": self = .roundRobin
      case "SWISS": self = .swiss
      case "EXHIBITION": self = .exhibition
      case "CUSTOM_SCHEDULE": self = .customSchedule
      case "MATCHMAKING": self = .matchmaking
      case "ELIMINATION_ROUNDS": self = .eliminationRounds
      case "RACE": self = .race
      case "CIRCUIT": self = .circuit
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .singleElimination: return "SINGLE_ELIMINATION"
      case .doubleElimination: return "DOUBLE_ELIMINATION"
      case .roundRobin: return "ROUND_ROBIN"
      case .swiss: return "SWISS"
      case .exhibition: return "EXHIBITION"
      case .customSchedule: return "CUSTOM_SCHEDULE"
      case .matchmaking: return "MATCHMAKING"
      case .eliminationRounds: return "ELIMINATION_ROUNDS"
      case .race: return "RACE"
      case .circuit: return "CIRCUIT"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: BracketType, rhs: BracketType) -> Bool {
    switch (lhs, rhs) {
      case (.singleElimination, .singleElimination): return true
      case (.doubleElimination, .doubleElimination): return true
      case (.roundRobin, .roundRobin): return true
      case (.swiss, .swiss): return true
      case (.exhibition, .exhibition): return true
      case (.customSchedule, .customSchedule): return true
      case (.matchmaking, .matchmaking): return true
      case (.eliminationRounds, .eliminationRounds): return true
      case (.race, .race): return true
      case (.circuit, .circuit): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [BracketType] {
    return [
      .singleElimination,
      .doubleElimination,
      .roundRobin,
      .swiss,
      .exhibition,
      .customSchedule,
      .matchmaking,
      .eliminationRounds,
      .race,
      .circuit,
    ]
  }
}

public struct PhaseUpsertInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - name: The name of the Phase. For example, "Top 8" or "Pools"
  ///   - groupCount: The number of pools to configure for the Phase. Only applies to brackets that support pools
  ///   - bracketType
  public init(name: Swift.Optional<String?> = nil, groupCount: Swift.Optional<Int?> = nil, bracketType: Swift.Optional<BracketType?> = nil) {
    graphQLMap = ["name": name, "groupCount": groupCount, "bracketType": bracketType]
  }

  /// The name of the Phase. For example, "Top 8" or "Pools"
  public var name: Swift.Optional<String?> {
    get {
      return graphQLMap["name"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  /// The number of pools to configure for the Phase. Only applies to brackets that support pools
  public var groupCount: Swift.Optional<Int?> {
    get {
      return graphQLMap["groupCount"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "groupCount")
    }
  }

  public var bracketType: Swift.Optional<BracketType?> {
    get {
      return graphQLMap["bracketType"] as? Swift.Optional<BracketType?> ?? Swift.Optional<BracketType?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "bracketType")
    }
  }
}

/// Represents the source of a stream
public enum StreamSource: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// Stream is on twitch.tv channel
  case twitch
  /// Stream is on smashcast.tv channel
  case hitbox
  /// Stream is on a stream.me channel
  case streamme
  /// Stream is on a mixer.com channel
  case mixer
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "TWITCH": self = .twitch
      case "HITBOX": self = .hitbox
      case "STREAMME": self = .streamme
      case "MIXER": self = .mixer
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .twitch: return "TWITCH"
      case .hitbox: return "HITBOX"
      case .streamme: return "STREAMME"
      case .mixer: return "MIXER"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: StreamSource, rhs: StreamSource) -> Bool {
    switch (lhs, rhs) {
      case (.twitch, .twitch): return true
      case (.hitbox, .hitbox): return true
      case (.streamme, .streamme): return true
      case (.mixer, .mixer): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [StreamSource] {
    return [
      .twitch,
      .hitbox,
      .streamme,
      .mixer,
    ]
  }
}

public final class TournamentEventsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query TournamentEvents($id: ID) {
      tournament(id: $id) {
        __typename
        events {
          __typename
          id
          name
          state
          videogame {
            __typename
            name
            images {
              __typename
              url
              ratio
            }
          }
        }
      }
    }
    """

  public let operationName: String = "TournamentEvents"

  public var id: GraphQLID?

  public init(id: GraphQLID? = nil) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("tournament", arguments: ["id": GraphQLVariable("id")], type: .object(Tournament.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(tournament: Tournament? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "tournament": tournament.flatMap { (value: Tournament) -> ResultMap in value.resultMap }])
    }

    /// Returns a tournament given its id or slug
    public var tournament: Tournament? {
      get {
        return (resultMap["tournament"] as? ResultMap).flatMap { Tournament(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "tournament")
      }
    }

    public struct Tournament: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Tournament"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("events", type: .list(.object(Event.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(events: [Event?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Tournament", "events": events.flatMap { (value: [Event?]) -> [ResultMap?] in value.map { (value: Event?) -> ResultMap? in value.flatMap { (value: Event) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var events: [Event?]? {
        get {
          return (resultMap["events"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Event?] in value.map { (value: ResultMap?) -> Event? in value.flatMap { (value: ResultMap) -> Event in Event(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Event?]) -> [ResultMap?] in value.map { (value: Event?) -> ResultMap? in value.flatMap { (value: Event) -> ResultMap in value.resultMap } } }, forKey: "events")
        }
      }

      public struct Event: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Event"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("state", type: .scalar(ActivityState.self)),
            GraphQLField("videogame", type: .object(Videogame.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, name: String? = nil, state: ActivityState? = nil, videogame: Videogame? = nil) {
          self.init(unsafeResultMap: ["__typename": "Event", "id": id, "name": name, "state": state, "videogame": videogame.flatMap { (value: Videogame) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// Title of event set by organizer
        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        /// The state of the Event.
        public var state: ActivityState? {
          get {
            return resultMap["state"] as? ActivityState
          }
          set {
            resultMap.updateValue(newValue, forKey: "state")
          }
        }

        public var videogame: Videogame? {
          get {
            return (resultMap["videogame"] as? ResultMap).flatMap { Videogame(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "videogame")
          }
        }

        public struct Videogame: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Videogame"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .scalar(String.self)),
              GraphQLField("images", type: .list(.object(Image.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String? = nil, images: [Image?]? = nil) {
            self.init(unsafeResultMap: ["__typename": "Videogame", "name": name, "images": images.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          public var images: [Image?]? {
            get {
              return (resultMap["images"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Image?] in value.map { (value: ResultMap?) -> Image? in value.flatMap { (value: ResultMap) -> Image in Image(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }, forKey: "images")
            }
          }

          public struct Image: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Image"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("url", type: .scalar(String.self)),
                GraphQLField("ratio", type: .scalar(Double.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(url: String? = nil, ratio: Double? = nil) {
              self.init(unsafeResultMap: ["__typename": "Image", "url": url, "ratio": ratio])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var url: String? {
              get {
                return resultMap["url"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "url")
              }
            }

            public var ratio: Double? {
              get {
                return resultMap["ratio"] as? Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "ratio")
              }
            }
          }
        }
      }
    }
  }
}

public final class EventPhasesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query EventPhases($id: ID) {
      event(id: $id) {
        __typename
        phases {
          __typename
          id
          name
          bracketType
          groupCount
        }
      }
    }
    """

  public let operationName: String = "EventPhases"

  public var id: GraphQLID?

  public init(id: GraphQLID? = nil) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("event", arguments: ["id": GraphQLVariable("id")], type: .object(Event.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(event: Event? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "event": event.flatMap { (value: Event) -> ResultMap in value.resultMap }])
    }

    /// Returns an event given its id or slug
    public var event: Event? {
      get {
        return (resultMap["event"] as? ResultMap).flatMap { Event(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "event")
      }
    }

    public struct Event: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Event"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("phases", type: .list(.object(Phase.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(phases: [Phase?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Event", "phases": phases.flatMap { (value: [Phase?]) -> [ResultMap?] in value.map { (value: Phase?) -> ResultMap? in value.flatMap { (value: Phase) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The phases that belong to an event.
      public var phases: [Phase?]? {
        get {
          return (resultMap["phases"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Phase?] in value.map { (value: ResultMap?) -> Phase? in value.flatMap { (value: ResultMap) -> Phase in Phase(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Phase?]) -> [ResultMap?] in value.map { (value: Phase?) -> ResultMap? in value.flatMap { (value: Phase) -> ResultMap in value.resultMap } } }, forKey: "phases")
        }
      }

      public struct Phase: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Phase"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("bracketType", type: .scalar(BracketType.self)),
            GraphQLField("groupCount", type: .scalar(Int.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, name: String? = nil, bracketType: BracketType? = nil, groupCount: Int? = nil) {
          self.init(unsafeResultMap: ["__typename": "Phase", "id": id, "name": name, "bracketType": bracketType, "groupCount": groupCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// Name of phase e.g. Round 1 Pools
        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        /// The bracket type of this phase.
        public var bracketType: BracketType? {
          get {
            return resultMap["bracketType"] as? BracketType
          }
          set {
            resultMap.updateValue(newValue, forKey: "bracketType")
          }
        }

        /// Number of phase groups in this phase
        public var groupCount: Int? {
          get {
            return resultMap["groupCount"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "groupCount")
          }
        }
      }
    }
  }
}

public final class CreatePhaseMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation CreatePhase($eventID: ID, $payload: PhaseUpsertInput!) {
      upsertPhase(eventId: $eventID, payload: $payload) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "CreatePhase"

  public var eventID: GraphQLID?
  public var payload: PhaseUpsertInput

  public init(eventID: GraphQLID? = nil, payload: PhaseUpsertInput) {
    self.eventID = eventID
    self.payload = payload
  }

  public var variables: GraphQLMap? {
    return ["eventID": eventID, "payload": payload]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("upsertPhase", arguments: ["eventId": GraphQLVariable("eventID"), "payload": GraphQLVariable("payload")], type: .object(UpsertPhase.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(upsertPhase: UpsertPhase? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "upsertPhase": upsertPhase.flatMap { (value: UpsertPhase) -> ResultMap in value.resultMap }])
    }

    /// Create or update a Phase
    public var upsertPhase: UpsertPhase? {
      get {
        return (resultMap["upsertPhase"] as? ResultMap).flatMap { UpsertPhase(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "upsertPhase")
      }
    }

    public struct UpsertPhase: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Phase"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil) {
        self.init(unsafeResultMap: ["__typename": "Phase", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class UpdatePhaseMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation UpdatePhase($phaseID: ID, $payload: PhaseUpsertInput!) {
      upsertPhase(phaseId: $phaseID, payload: $payload) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "UpdatePhase"

  public var phaseID: GraphQLID?
  public var payload: PhaseUpsertInput

  public init(phaseID: GraphQLID? = nil, payload: PhaseUpsertInput) {
    self.phaseID = phaseID
    self.payload = payload
  }

  public var variables: GraphQLMap? {
    return ["phaseID": phaseID, "payload": payload]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("upsertPhase", arguments: ["phaseId": GraphQLVariable("phaseID"), "payload": GraphQLVariable("payload")], type: .object(UpsertPhase.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(upsertPhase: UpsertPhase? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "upsertPhase": upsertPhase.flatMap { (value: UpsertPhase) -> ResultMap in value.resultMap }])
    }

    /// Create or update a Phase
    public var upsertPhase: UpsertPhase? {
      get {
        return (resultMap["upsertPhase"] as? ResultMap).flatMap { UpsertPhase(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "upsertPhase")
      }
    }

    public struct UpsertPhase: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Phase"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil) {
        self.init(unsafeResultMap: ["__typename": "Phase", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class DeletePhaseMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation DeletePhase($phaseID: ID!) {
      deletePhase(phaseId: $phaseID)
    }
    """

  public let operationName: String = "DeletePhase"

  public var phaseID: GraphQLID

  public init(phaseID: GraphQLID) {
    self.phaseID = phaseID
  }

  public var variables: GraphQLMap? {
    return ["phaseID": phaseID]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deletePhase", arguments: ["phaseId": GraphQLVariable("phaseID")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deletePhase: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deletePhase": deletePhase])
    }

    /// Delete a phase by id
    public var deletePhase: Bool? {
      get {
        return resultMap["deletePhase"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "deletePhase")
      }
    }
  }
}

public final class SwapSeedsMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation SwapSeeds($phaseID: ID!, $seed1ID: ID!, $seed2ID: ID!) {
      swapSeeds(phaseId: $phaseID, seed1Id: $seed1ID, seed2Id: $seed2ID) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "SwapSeeds"

  public var phaseID: GraphQLID
  public var seed1ID: GraphQLID
  public var seed2ID: GraphQLID

  public init(phaseID: GraphQLID, seed1ID: GraphQLID, seed2ID: GraphQLID) {
    self.phaseID = phaseID
    self.seed1ID = seed1ID
    self.seed2ID = seed2ID
  }

  public var variables: GraphQLMap? {
    return ["phaseID": phaseID, "seed1ID": seed1ID, "seed2ID": seed2ID]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("swapSeeds", arguments: ["phaseId": GraphQLVariable("phaseID"), "seed1Id": GraphQLVariable("seed1ID"), "seed2Id": GraphQLVariable("seed2ID")], type: .list(.object(SwapSeed.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(swapSeeds: [SwapSeed?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "swapSeeds": swapSeeds.flatMap { (value: [SwapSeed?]) -> [ResultMap?] in value.map { (value: SwapSeed?) -> ResultMap? in value.flatMap { (value: SwapSeed) -> ResultMap in value.resultMap } } }])
    }

    /// Swap two seed ids in a phase
    public var swapSeeds: [SwapSeed?]? {
      get {
        return (resultMap["swapSeeds"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [SwapSeed?] in value.map { (value: ResultMap?) -> SwapSeed? in value.flatMap { (value: ResultMap) -> SwapSeed in SwapSeed(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [SwapSeed?]) -> [ResultMap?] in value.map { (value: SwapSeed?) -> ResultMap? in value.flatMap { (value: SwapSeed) -> ResultMap in value.resultMap } } }, forKey: "swapSeeds")
      }
    }

    public struct SwapSeed: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Seed"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil) {
        self.init(unsafeResultMap: ["__typename": "Seed", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class DeleteStationMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation DeleteStation($stationID: ID!) {
      deleteStation(stationId: $stationID)
    }
    """

  public let operationName: String = "DeleteStation"

  public var stationID: GraphQLID

  public init(stationID: GraphQLID) {
    self.stationID = stationID
  }

  public var variables: GraphQLMap? {
    return ["stationID": stationID]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deleteStation", arguments: ["stationId": GraphQLVariable("stationID")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteStation: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deleteStation": deleteStation])
    }

    /// Delete a station by id
    public var deleteStation: Bool? {
      get {
        return resultMap["deleteStation"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "deleteStation")
      }
    }
  }
}

public final class AuthTokenTestQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query AuthTokenTest {
      tournament(id: 2018) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "AuthTokenTest"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("tournament", arguments: ["id": 2018], type: .object(Tournament.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(tournament: Tournament? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "tournament": tournament.flatMap { (value: Tournament) -> ResultMap in value.resultMap }])
    }

    /// Returns a tournament given its id or slug
    public var tournament: Tournament? {
      get {
        return (resultMap["tournament"] as? ResultMap).flatMap { Tournament(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "tournament")
      }
    }

    public struct Tournament: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Tournament"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil) {
        self.init(unsafeResultMap: ["__typename": "Tournament", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class FeaturedTournamentsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query FeaturedTournaments($perPage: Int, $pageNum: Int, $videogameIds: [ID]) {
      tournaments(query: {perPage: $perPage, page: $pageNum, sortBy: "startAt asc", filter: {videogameIds: $videogameIds, staffPicks: true}}) {
        __typename
        nodes {
          __typename
          id
          name
          startAt
          endAt
          venueAddress
          isOnline
          images {
            __typename
            url
            type
            ratio
          }
        }
      }
    }
    """

  public let operationName: String = "FeaturedTournaments"

  public var perPage: Int?
  public var pageNum: Int?
  public var videogameIds: [GraphQLID?]?

  public init(perPage: Int? = nil, pageNum: Int? = nil, videogameIds: [GraphQLID?]? = nil) {
    self.perPage = perPage
    self.pageNum = pageNum
    self.videogameIds = videogameIds
  }

  public var variables: GraphQLMap? {
    return ["perPage": perPage, "pageNum": pageNum, "videogameIds": videogameIds]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("tournaments", arguments: ["query": ["perPage": GraphQLVariable("perPage"), "page": GraphQLVariable("pageNum"), "sortBy": "startAt asc", "filter": ["videogameIds": GraphQLVariable("videogameIds"), "staffPicks": true]]], type: .object(Tournament.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(tournaments: Tournament? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "tournaments": tournaments.flatMap { (value: Tournament) -> ResultMap in value.resultMap }])
    }

    /// Paginated, filterable list of tournaments
    public var tournaments: Tournament? {
      get {
        return (resultMap["tournaments"] as? ResultMap).flatMap { Tournament(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "tournaments")
      }
    }

    public struct Tournament: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["TournamentConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nodes", type: .list(.object(Node.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(nodes: [Node?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "TournamentConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var nodes: [Node?]? {
        get {
          return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
        }
      }

      public struct Node: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Tournament"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("startAt", type: .scalar(String.self)),
            GraphQLField("endAt", type: .scalar(String.self)),
            GraphQLField("venueAddress", type: .scalar(String.self)),
            GraphQLField("isOnline", type: .scalar(Bool.self)),
            GraphQLField("images", type: .list(.object(Image.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, name: String? = nil, startAt: String? = nil, endAt: String? = nil, venueAddress: String? = nil, isOnline: Bool? = nil, images: [Image?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "Tournament", "id": id, "name": name, "startAt": startAt, "endAt": endAt, "venueAddress": venueAddress, "isOnline": isOnline, "images": images.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// The tournament name
        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        /// When the tournament Starts
        public var startAt: String? {
          get {
            return resultMap["startAt"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "startAt")
          }
        }

        /// When the tournament ends
        public var endAt: String? {
          get {
            return resultMap["endAt"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "endAt")
          }
        }

        public var venueAddress: String? {
          get {
            return resultMap["venueAddress"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "venueAddress")
          }
        }

        /// True if tournament has at least one online event
        public var isOnline: Bool? {
          get {
            return resultMap["isOnline"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "isOnline")
          }
        }

        public var images: [Image?]? {
          get {
            return (resultMap["images"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Image?] in value.map { (value: ResultMap?) -> Image? in value.flatMap { (value: ResultMap) -> Image in Image(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }, forKey: "images")
          }
        }

        public struct Image: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Image"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("url", type: .scalar(String.self)),
              GraphQLField("type", type: .scalar(String.self)),
              GraphQLField("ratio", type: .scalar(Double.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(url: String? = nil, type: String? = nil, ratio: Double? = nil) {
            self.init(unsafeResultMap: ["__typename": "Image", "url": url, "type": type, "ratio": ratio])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var url: String? {
            get {
              return resultMap["url"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }

          public var type: String? {
            get {
              return resultMap["type"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "type")
            }
          }

          public var ratio: Double? {
            get {
              return resultMap["ratio"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "ratio")
            }
          }
        }
      }
    }
  }
}

public final class TournamentsByVideogamesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query TournamentsByVideogames($perPage: Int, $pageNum: Int, $videogameIds: [ID], $featured: Boolean, $upcoming: Boolean, $countryCode: String, $addrState: String) {
      tournaments(query: {perPage: $perPage, page: $pageNum, sortBy: "startAt asc", filter: {upcoming: $upcoming, videogameIds: $videogameIds, isFeatured: $featured, countryCode: $countryCode, addrState: $addrState}}) {
        __typename
        nodes {
          __typename
          id
          name
          startAt
          endAt
          venueAddress
          isOnline
          images {
            __typename
            url
            ratio
          }
        }
      }
    }
    """

  public let operationName: String = "TournamentsByVideogames"

  public var perPage: Int?
  public var pageNum: Int?
  public var videogameIds: [GraphQLID?]?
  public var featured: Bool?
  public var upcoming: Bool?
  public var countryCode: String?
  public var addrState: String?

  public init(perPage: Int? = nil, pageNum: Int? = nil, videogameIds: [GraphQLID?]? = nil, featured: Bool? = nil, upcoming: Bool? = nil, countryCode: String? = nil, addrState: String? = nil) {
    self.perPage = perPage
    self.pageNum = pageNum
    self.videogameIds = videogameIds
    self.featured = featured
    self.upcoming = upcoming
    self.countryCode = countryCode
    self.addrState = addrState
  }

  public var variables: GraphQLMap? {
    return ["perPage": perPage, "pageNum": pageNum, "videogameIds": videogameIds, "featured": featured, "upcoming": upcoming, "countryCode": countryCode, "addrState": addrState]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("tournaments", arguments: ["query": ["perPage": GraphQLVariable("perPage"), "page": GraphQLVariable("pageNum"), "sortBy": "startAt asc", "filter": ["upcoming": GraphQLVariable("upcoming"), "videogameIds": GraphQLVariable("videogameIds"), "isFeatured": GraphQLVariable("featured"), "countryCode": GraphQLVariable("countryCode"), "addrState": GraphQLVariable("addrState")]]], type: .object(Tournament.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(tournaments: Tournament? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "tournaments": tournaments.flatMap { (value: Tournament) -> ResultMap in value.resultMap }])
    }

    /// Paginated, filterable list of tournaments
    public var tournaments: Tournament? {
      get {
        return (resultMap["tournaments"] as? ResultMap).flatMap { Tournament(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "tournaments")
      }
    }

    public struct Tournament: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["TournamentConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nodes", type: .list(.object(Node.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(nodes: [Node?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "TournamentConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var nodes: [Node?]? {
        get {
          return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
        }
      }

      public struct Node: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Tournament"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("startAt", type: .scalar(String.self)),
            GraphQLField("endAt", type: .scalar(String.self)),
            GraphQLField("venueAddress", type: .scalar(String.self)),
            GraphQLField("isOnline", type: .scalar(Bool.self)),
            GraphQLField("images", type: .list(.object(Image.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, name: String? = nil, startAt: String? = nil, endAt: String? = nil, venueAddress: String? = nil, isOnline: Bool? = nil, images: [Image?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "Tournament", "id": id, "name": name, "startAt": startAt, "endAt": endAt, "venueAddress": venueAddress, "isOnline": isOnline, "images": images.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// The tournament name
        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        /// When the tournament Starts
        public var startAt: String? {
          get {
            return resultMap["startAt"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "startAt")
          }
        }

        /// When the tournament ends
        public var endAt: String? {
          get {
            return resultMap["endAt"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "endAt")
          }
        }

        public var venueAddress: String? {
          get {
            return resultMap["venueAddress"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "venueAddress")
          }
        }

        /// True if tournament has at least one online event
        public var isOnline: Bool? {
          get {
            return resultMap["isOnline"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "isOnline")
          }
        }

        public var images: [Image?]? {
          get {
            return (resultMap["images"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Image?] in value.map { (value: ResultMap?) -> Image? in value.flatMap { (value: ResultMap) -> Image in Image(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }, forKey: "images")
          }
        }

        public struct Image: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Image"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("url", type: .scalar(String.self)),
              GraphQLField("ratio", type: .scalar(Double.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(url: String? = nil, ratio: Double? = nil) {
            self.init(unsafeResultMap: ["__typename": "Image", "url": url, "ratio": ratio])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var url: String? {
            get {
              return resultMap["url"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }

          public var ratio: Double? {
            get {
              return resultMap["ratio"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "ratio")
            }
          }
        }
      }
    }
  }
}

public final class SearchForTournamentsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query SearchForTournaments($search: String, $videogameIds: [ID], $featured: Boolean, $sortBy: String, $perPage: Int, $page: Int, $countryCode: String) {
      tournaments(query: {perPage: $perPage, page: $page, sortBy: $sortBy, filter: {name: $search, videogameIds: $videogameIds, isFeatured: $featured, countryCode: $countryCode}}) {
        __typename
        nodes {
          __typename
          id
          name
          startAt
          endAt
          venueAddress
          isOnline
          images {
            __typename
            url
            ratio
          }
        }
      }
    }
    """

  public let operationName: String = "SearchForTournaments"

  public var search: String?
  public var videogameIds: [GraphQLID?]?
  public var featured: Bool?
  public var sortBy: String?
  public var perPage: Int?
  public var page: Int?
  public var countryCode: String?

  public init(search: String? = nil, videogameIds: [GraphQLID?]? = nil, featured: Bool? = nil, sortBy: String? = nil, perPage: Int? = nil, page: Int? = nil, countryCode: String? = nil) {
    self.search = search
    self.videogameIds = videogameIds
    self.featured = featured
    self.sortBy = sortBy
    self.perPage = perPage
    self.page = page
    self.countryCode = countryCode
  }

  public var variables: GraphQLMap? {
    return ["search": search, "videogameIds": videogameIds, "featured": featured, "sortBy": sortBy, "perPage": perPage, "page": page, "countryCode": countryCode]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("tournaments", arguments: ["query": ["perPage": GraphQLVariable("perPage"), "page": GraphQLVariable("page"), "sortBy": GraphQLVariable("sortBy"), "filter": ["name": GraphQLVariable("search"), "videogameIds": GraphQLVariable("videogameIds"), "isFeatured": GraphQLVariable("featured"), "countryCode": GraphQLVariable("countryCode")]]], type: .object(Tournament.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(tournaments: Tournament? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "tournaments": tournaments.flatMap { (value: Tournament) -> ResultMap in value.resultMap }])
    }

    /// Paginated, filterable list of tournaments
    public var tournaments: Tournament? {
      get {
        return (resultMap["tournaments"] as? ResultMap).flatMap { Tournament(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "tournaments")
      }
    }

    public struct Tournament: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["TournamentConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nodes", type: .list(.object(Node.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(nodes: [Node?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "TournamentConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var nodes: [Node?]? {
        get {
          return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
        }
      }

      public struct Node: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Tournament"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("startAt", type: .scalar(String.self)),
            GraphQLField("endAt", type: .scalar(String.self)),
            GraphQLField("venueAddress", type: .scalar(String.self)),
            GraphQLField("isOnline", type: .scalar(Bool.self)),
            GraphQLField("images", type: .list(.object(Image.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, name: String? = nil, startAt: String? = nil, endAt: String? = nil, venueAddress: String? = nil, isOnline: Bool? = nil, images: [Image?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "Tournament", "id": id, "name": name, "startAt": startAt, "endAt": endAt, "venueAddress": venueAddress, "isOnline": isOnline, "images": images.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// The tournament name
        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        /// When the tournament Starts
        public var startAt: String? {
          get {
            return resultMap["startAt"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "startAt")
          }
        }

        /// When the tournament ends
        public var endAt: String? {
          get {
            return resultMap["endAt"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "endAt")
          }
        }

        public var venueAddress: String? {
          get {
            return resultMap["venueAddress"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "venueAddress")
          }
        }

        /// True if tournament has at least one online event
        public var isOnline: Bool? {
          get {
            return resultMap["isOnline"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "isOnline")
          }
        }

        public var images: [Image?]? {
          get {
            return (resultMap["images"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Image?] in value.map { (value: ResultMap?) -> Image? in value.flatMap { (value: ResultMap) -> Image in Image(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }, forKey: "images")
          }
        }

        public struct Image: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Image"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("url", type: .scalar(String.self)),
              GraphQLField("ratio", type: .scalar(Double.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(url: String? = nil, ratio: Double? = nil) {
            self.init(unsafeResultMap: ["__typename": "Image", "url": url, "ratio": ratio])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var url: String? {
            get {
              return resultMap["url"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }

          public var ratio: Double? {
            get {
              return resultMap["ratio"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "ratio")
            }
          }
        }
      }
    }
  }
}

public final class TournamentBySlugQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query TournamentBySlug($slug: String) {
      tournament(slug: $slug) {
        __typename
        id
        name
        startAt
        endAt
        venueAddress
        isOnline
        images {
          __typename
          url
          type
          ratio
        }
      }
    }
    """

  public let operationName: String = "TournamentBySlug"

  public var slug: String?

  public init(slug: String? = nil) {
    self.slug = slug
  }

  public var variables: GraphQLMap? {
    return ["slug": slug]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("tournament", arguments: ["slug": GraphQLVariable("slug")], type: .object(Tournament.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(tournament: Tournament? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "tournament": tournament.flatMap { (value: Tournament) -> ResultMap in value.resultMap }])
    }

    /// Returns a tournament given its id or slug
    public var tournament: Tournament? {
      get {
        return (resultMap["tournament"] as? ResultMap).flatMap { Tournament(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "tournament")
      }
    }

    public struct Tournament: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Tournament"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("startAt", type: .scalar(String.self)),
          GraphQLField("endAt", type: .scalar(String.self)),
          GraphQLField("venueAddress", type: .scalar(String.self)),
          GraphQLField("isOnline", type: .scalar(Bool.self)),
          GraphQLField("images", type: .list(.object(Image.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, name: String? = nil, startAt: String? = nil, endAt: String? = nil, venueAddress: String? = nil, isOnline: Bool? = nil, images: [Image?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Tournament", "id": id, "name": name, "startAt": startAt, "endAt": endAt, "venueAddress": venueAddress, "isOnline": isOnline, "images": images.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      /// The tournament name
      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      /// When the tournament Starts
      public var startAt: String? {
        get {
          return resultMap["startAt"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "startAt")
        }
      }

      /// When the tournament ends
      public var endAt: String? {
        get {
          return resultMap["endAt"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "endAt")
        }
      }

      public var venueAddress: String? {
        get {
          return resultMap["venueAddress"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "venueAddress")
        }
      }

      /// True if tournament has at least one online event
      public var isOnline: Bool? {
        get {
          return resultMap["isOnline"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isOnline")
        }
      }

      public var images: [Image?]? {
        get {
          return (resultMap["images"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Image?] in value.map { (value: ResultMap?) -> Image? in value.flatMap { (value: ResultMap) -> Image in Image(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }, forKey: "images")
        }
      }

      public struct Image: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Image"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("url", type: .scalar(String.self)),
            GraphQLField("type", type: .scalar(String.self)),
            GraphQLField("ratio", type: .scalar(Double.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(url: String? = nil, type: String? = nil, ratio: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "Image", "url": url, "type": type, "ratio": ratio])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var url: String? {
          get {
            return resultMap["url"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "url")
          }
        }

        public var type: String? {
          get {
            return resultMap["type"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "type")
          }
        }

        public var ratio: Double? {
          get {
            return resultMap["ratio"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "ratio")
          }
        }
      }
    }
  }
}

public final class TournamentDetailsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query TournamentDetails($id: ID) {
      tournament(id: $id) {
        __typename
        venueName
        lng
        lat
        events {
          __typename
          id
          name
          state
          standings(query: {perPage: 1}) {
            __typename
            nodes {
              __typename
              entrant {
                __typename
                name
                participants {
                  __typename
                  gamerTag
                }
              }
            }
          }
          startAt
          type
          videogame {
            __typename
            name
            images {
              __typename
              url
              ratio
            }
          }
        }
        streams {
          __typename
          streamName
          streamLogo
          streamSource
        }
        isRegistrationOpen
        registrationClosesAt
        primaryContact
        primaryContactType
        slug
        owner {
          __typename
          id
          player {
            __typename
            prefix
            gamerTag
          }
        }
        admins {
          __typename
          id
        }
      }
    }
    """

  public let operationName: String = "TournamentDetails"

  public var id: GraphQLID?

  public init(id: GraphQLID? = nil) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("tournament", arguments: ["id": GraphQLVariable("id")], type: .object(Tournament.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(tournament: Tournament? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "tournament": tournament.flatMap { (value: Tournament) -> ResultMap in value.resultMap }])
    }

    /// Returns a tournament given its id or slug
    public var tournament: Tournament? {
      get {
        return (resultMap["tournament"] as? ResultMap).flatMap { Tournament(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "tournament")
      }
    }

    public struct Tournament: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Tournament"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("venueName", type: .scalar(String.self)),
          GraphQLField("lng", type: .scalar(Double.self)),
          GraphQLField("lat", type: .scalar(Double.self)),
          GraphQLField("events", type: .list(.object(Event.selections))),
          GraphQLField("streams", type: .list(.object(Stream.selections))),
          GraphQLField("isRegistrationOpen", type: .scalar(Bool.self)),
          GraphQLField("registrationClosesAt", type: .scalar(String.self)),
          GraphQLField("primaryContact", type: .scalar(String.self)),
          GraphQLField("primaryContactType", type: .scalar(String.self)),
          GraphQLField("slug", type: .scalar(String.self)),
          GraphQLField("owner", type: .object(Owner.selections)),
          GraphQLField("admins", type: .list(.object(Admin.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(venueName: String? = nil, lng: Double? = nil, lat: Double? = nil, events: [Event?]? = nil, streams: [Stream?]? = nil, isRegistrationOpen: Bool? = nil, registrationClosesAt: String? = nil, primaryContact: String? = nil, primaryContactType: String? = nil, slug: String? = nil, owner: Owner? = nil, admins: [Admin?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Tournament", "venueName": venueName, "lng": lng, "lat": lat, "events": events.flatMap { (value: [Event?]) -> [ResultMap?] in value.map { (value: Event?) -> ResultMap? in value.flatMap { (value: Event) -> ResultMap in value.resultMap } } }, "streams": streams.flatMap { (value: [Stream?]) -> [ResultMap?] in value.map { (value: Stream?) -> ResultMap? in value.flatMap { (value: Stream) -> ResultMap in value.resultMap } } }, "isRegistrationOpen": isRegistrationOpen, "registrationClosesAt": registrationClosesAt, "primaryContact": primaryContact, "primaryContactType": primaryContactType, "slug": slug, "owner": owner.flatMap { (value: Owner) -> ResultMap in value.resultMap }, "admins": admins.flatMap { (value: [Admin?]) -> [ResultMap?] in value.map { (value: Admin?) -> ResultMap? in value.flatMap { (value: Admin) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var venueName: String? {
        get {
          return resultMap["venueName"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "venueName")
        }
      }

      public var lng: Double? {
        get {
          return resultMap["lng"] as? Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "lng")
        }
      }

      public var lat: Double? {
        get {
          return resultMap["lat"] as? Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "lat")
        }
      }

      public var events: [Event?]? {
        get {
          return (resultMap["events"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Event?] in value.map { (value: ResultMap?) -> Event? in value.flatMap { (value: ResultMap) -> Event in Event(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Event?]) -> [ResultMap?] in value.map { (value: Event?) -> ResultMap? in value.flatMap { (value: Event) -> ResultMap in value.resultMap } } }, forKey: "events")
        }
      }

      public var streams: [Stream?]? {
        get {
          return (resultMap["streams"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Stream?] in value.map { (value: ResultMap?) -> Stream? in value.flatMap { (value: ResultMap) -> Stream in Stream(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Stream?]) -> [ResultMap?] in value.map { (value: Stream?) -> ResultMap? in value.flatMap { (value: Stream) -> ResultMap in value.resultMap } } }, forKey: "streams")
        }
      }

      /// Is tournament registration open
      public var isRegistrationOpen: Bool? {
        get {
          return resultMap["isRegistrationOpen"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isRegistrationOpen")
        }
      }

      /// When does registration for the tournament end
      public var registrationClosesAt: String? {
        get {
          return resultMap["registrationClosesAt"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "registrationClosesAt")
        }
      }

      public var primaryContact: String? {
        get {
          return resultMap["primaryContact"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "primaryContact")
        }
      }

      public var primaryContactType: String? {
        get {
          return resultMap["primaryContactType"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "primaryContactType")
        }
      }

      /// The slug used to form the url
      public var slug: String? {
        get {
          return resultMap["slug"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "slug")
        }
      }

      /// The user who created the tournament
      public var owner: Owner? {
        get {
          return (resultMap["owner"] as? ResultMap).flatMap { Owner(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "owner")
        }
      }

      /// Admin-only view of admins for this tournament
      public var admins: [Admin?]? {
        get {
          return (resultMap["admins"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Admin?] in value.map { (value: ResultMap?) -> Admin? in value.flatMap { (value: ResultMap) -> Admin in Admin(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Admin?]) -> [ResultMap?] in value.map { (value: Admin?) -> ResultMap? in value.flatMap { (value: Admin) -> ResultMap in value.resultMap } } }, forKey: "admins")
        }
      }

      public struct Event: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Event"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("state", type: .scalar(ActivityState.self)),
            GraphQLField("standings", arguments: ["query": ["perPage": 1]], type: .object(Standing.selections)),
            GraphQLField("startAt", type: .scalar(String.self)),
            GraphQLField("type", type: .scalar(Int.self)),
            GraphQLField("videogame", type: .object(Videogame.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, name: String? = nil, state: ActivityState? = nil, standings: Standing? = nil, startAt: String? = nil, type: Int? = nil, videogame: Videogame? = nil) {
          self.init(unsafeResultMap: ["__typename": "Event", "id": id, "name": name, "state": state, "standings": standings.flatMap { (value: Standing) -> ResultMap in value.resultMap }, "startAt": startAt, "type": type, "videogame": videogame.flatMap { (value: Videogame) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// Title of event set by organizer
        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        /// The state of the Event.
        public var state: ActivityState? {
          get {
            return resultMap["state"] as? ActivityState
          }
          set {
            resultMap.updateValue(newValue, forKey: "state")
          }
        }

        /// Paginated list of standings
        public var standings: Standing? {
          get {
            return (resultMap["standings"] as? ResultMap).flatMap { Standing(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "standings")
          }
        }

        /// When does this event start?
        public var startAt: String? {
          get {
            return resultMap["startAt"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "startAt")
          }
        }

        /// The type of the event, whether an entrant will have one participant or multiple
        public var type: Int? {
          get {
            return resultMap["type"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "type")
          }
        }

        public var videogame: Videogame? {
          get {
            return (resultMap["videogame"] as? ResultMap).flatMap { Videogame(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "videogame")
          }
        }

        public struct Standing: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["StandingConnection"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("nodes", type: .list(.object(Node.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(nodes: [Node?]? = nil) {
            self.init(unsafeResultMap: ["__typename": "StandingConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nodes: [Node?]? {
            get {
              return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Standing"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("entrant", type: .object(Entrant.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(entrant: Entrant? = nil) {
              self.init(unsafeResultMap: ["__typename": "Standing", "entrant": entrant.flatMap { (value: Entrant) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// If the entity this standing is assigned to can be resolved into an entrant, this will provide the entrant.
            public var entrant: Entrant? {
              get {
                return (resultMap["entrant"] as? ResultMap).flatMap { Entrant(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "entrant")
              }
            }

            public struct Entrant: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Entrant"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("name", type: .scalar(String.self)),
                  GraphQLField("participants", type: .list(.object(Participant.selections))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(name: String? = nil, participants: [Participant?]? = nil) {
                self.init(unsafeResultMap: ["__typename": "Entrant", "name": name, "participants": participants.flatMap { (value: [Participant?]) -> [ResultMap?] in value.map { (value: Participant?) -> ResultMap? in value.flatMap { (value: Participant) -> ResultMap in value.resultMap } } }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The entrant name as it appears in bracket: gamerTag of the participant or team name
              public var name: String? {
                get {
                  return resultMap["name"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "name")
                }
              }

              public var participants: [Participant?]? {
                get {
                  return (resultMap["participants"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Participant?] in value.map { (value: ResultMap?) -> Participant? in value.flatMap { (value: ResultMap) -> Participant in Participant(unsafeResultMap: value) } } }
                }
                set {
                  resultMap.updateValue(newValue.flatMap { (value: [Participant?]) -> [ResultMap?] in value.map { (value: Participant?) -> ResultMap? in value.flatMap { (value: Participant) -> ResultMap in value.resultMap } } }, forKey: "participants")
                }
              }

              public struct Participant: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Participant"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("gamerTag", type: .scalar(String.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(gamerTag: String? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Participant", "gamerTag": gamerTag])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The tag that was used in registration e.g. Mang0
                public var gamerTag: String? {
                  get {
                    return resultMap["gamerTag"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "gamerTag")
                  }
                }
              }
            }
          }
        }

        public struct Videogame: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Videogame"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .scalar(String.self)),
              GraphQLField("images", type: .list(.object(Image.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String? = nil, images: [Image?]? = nil) {
            self.init(unsafeResultMap: ["__typename": "Videogame", "name": name, "images": images.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          public var images: [Image?]? {
            get {
              return (resultMap["images"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Image?] in value.map { (value: ResultMap?) -> Image? in value.flatMap { (value: ResultMap) -> Image in Image(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }, forKey: "images")
            }
          }

          public struct Image: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Image"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("url", type: .scalar(String.self)),
                GraphQLField("ratio", type: .scalar(Double.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(url: String? = nil, ratio: Double? = nil) {
              self.init(unsafeResultMap: ["__typename": "Image", "url": url, "ratio": ratio])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var url: String? {
              get {
                return resultMap["url"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "url")
              }
            }

            public var ratio: Double? {
              get {
                return resultMap["ratio"] as? Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "ratio")
              }
            }
          }
        }
      }

      public struct Stream: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Streams"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("streamName", type: .scalar(String.self)),
            GraphQLField("streamLogo", type: .scalar(String.self)),
            GraphQLField("streamSource", type: .scalar(StreamSource.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(streamName: String? = nil, streamLogo: String? = nil, streamSource: StreamSource? = nil) {
          self.init(unsafeResultMap: ["__typename": "Streams", "streamName": streamName, "streamLogo": streamLogo, "streamSource": streamSource])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var streamName: String? {
          get {
            return resultMap["streamName"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "streamName")
          }
        }

        public var streamLogo: String? {
          get {
            return resultMap["streamLogo"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "streamLogo")
          }
        }

        public var streamSource: StreamSource? {
          get {
            return resultMap["streamSource"] as? StreamSource
          }
          set {
            resultMap.updateValue(newValue, forKey: "streamSource")
          }
        }
      }

      public struct Owner: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("player", type: .object(Player.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, player: Player? = nil) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id, "player": player.flatMap { (value: Player) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// player for user
        public var player: Player? {
          get {
            return (resultMap["player"] as? ResultMap).flatMap { Player(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "player")
          }
        }

        public struct Player: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Player"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("prefix", type: .scalar(String.self)),
              GraphQLField("gamerTag", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(`prefix`: String? = nil, gamerTag: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Player", "prefix": `prefix`, "gamerTag": gamerTag])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var `prefix`: String? {
            get {
              return resultMap["prefix"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "prefix")
            }
          }

          public var gamerTag: String? {
            get {
              return resultMap["gamerTag"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "gamerTag")
            }
          }
        }
      }

      public struct Admin: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }
      }
    }
  }
}

public final class EventQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Event($id: ID) {
      event(id: $id) {
        __typename
        phases {
          __typename
          id
          name
          state
          groupCount
          numSeeds
          bracketType
        }
        standings(query: {perPage: 65}) {
          __typename
          nodes {
            __typename
            placement
            entrant {
              __typename
              name
              participants {
                __typename
                gamerTag
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "Event"

  public var id: GraphQLID?

  public init(id: GraphQLID? = nil) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("event", arguments: ["id": GraphQLVariable("id")], type: .object(Event.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(event: Event? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "event": event.flatMap { (value: Event) -> ResultMap in value.resultMap }])
    }

    /// Returns an event given its id or slug
    public var event: Event? {
      get {
        return (resultMap["event"] as? ResultMap).flatMap { Event(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "event")
      }
    }

    public struct Event: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Event"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("phases", type: .list(.object(Phase.selections))),
          GraphQLField("standings", arguments: ["query": ["perPage": 65]], type: .object(Standing.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(phases: [Phase?]? = nil, standings: Standing? = nil) {
        self.init(unsafeResultMap: ["__typename": "Event", "phases": phases.flatMap { (value: [Phase?]) -> [ResultMap?] in value.map { (value: Phase?) -> ResultMap? in value.flatMap { (value: Phase) -> ResultMap in value.resultMap } } }, "standings": standings.flatMap { (value: Standing) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The phases that belong to an event.
      public var phases: [Phase?]? {
        get {
          return (resultMap["phases"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Phase?] in value.map { (value: ResultMap?) -> Phase? in value.flatMap { (value: ResultMap) -> Phase in Phase(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Phase?]) -> [ResultMap?] in value.map { (value: Phase?) -> ResultMap? in value.flatMap { (value: Phase) -> ResultMap in value.resultMap } } }, forKey: "phases")
        }
      }

      /// Paginated list of standings
      public var standings: Standing? {
        get {
          return (resultMap["standings"] as? ResultMap).flatMap { Standing(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "standings")
        }
      }

      public struct Phase: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Phase"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("state", type: .scalar(ActivityState.self)),
            GraphQLField("groupCount", type: .scalar(Int.self)),
            GraphQLField("numSeeds", type: .scalar(Int.self)),
            GraphQLField("bracketType", type: .scalar(BracketType.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, name: String? = nil, state: ActivityState? = nil, groupCount: Int? = nil, numSeeds: Int? = nil, bracketType: BracketType? = nil) {
          self.init(unsafeResultMap: ["__typename": "Phase", "id": id, "name": name, "state": state, "groupCount": groupCount, "numSeeds": numSeeds, "bracketType": bracketType])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// Name of phase e.g. Round 1 Pools
        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        /// State of the phase
        public var state: ActivityState? {
          get {
            return resultMap["state"] as? ActivityState
          }
          set {
            resultMap.updateValue(newValue, forKey: "state")
          }
        }

        /// Number of phase groups in this phase
        public var groupCount: Int? {
          get {
            return resultMap["groupCount"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "groupCount")
          }
        }

        /// The number of seeds this phase contains.
        public var numSeeds: Int? {
          get {
            return resultMap["numSeeds"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "numSeeds")
          }
        }

        /// The bracket type of this phase.
        public var bracketType: BracketType? {
          get {
            return resultMap["bracketType"] as? BracketType
          }
          set {
            resultMap.updateValue(newValue, forKey: "bracketType")
          }
        }
      }

      public struct Standing: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["StandingConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "StandingConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Standing"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("placement", type: .scalar(Int.self)),
              GraphQLField("entrant", type: .object(Entrant.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(placement: Int? = nil, entrant: Entrant? = nil) {
            self.init(unsafeResultMap: ["__typename": "Standing", "placement": placement, "entrant": entrant.flatMap { (value: Entrant) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var placement: Int? {
            get {
              return resultMap["placement"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "placement")
            }
          }

          /// If the entity this standing is assigned to can be resolved into an entrant, this will provide the entrant.
          public var entrant: Entrant? {
            get {
              return (resultMap["entrant"] as? ResultMap).flatMap { Entrant(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "entrant")
            }
          }

          public struct Entrant: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Entrant"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("participants", type: .list(.object(Participant.selections))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(name: String? = nil, participants: [Participant?]? = nil) {
              self.init(unsafeResultMap: ["__typename": "Entrant", "name": name, "participants": participants.flatMap { (value: [Participant?]) -> [ResultMap?] in value.map { (value: Participant?) -> ResultMap? in value.flatMap { (value: Participant) -> ResultMap in value.resultMap } } }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The entrant name as it appears in bracket: gamerTag of the participant or team name
            public var name: String? {
              get {
                return resultMap["name"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }

            public var participants: [Participant?]? {
              get {
                return (resultMap["participants"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Participant?] in value.map { (value: ResultMap?) -> Participant? in value.flatMap { (value: ResultMap) -> Participant in Participant(unsafeResultMap: value) } } }
              }
              set {
                resultMap.updateValue(newValue.flatMap { (value: [Participant?]) -> [ResultMap?] in value.map { (value: Participant?) -> ResultMap? in value.flatMap { (value: Participant) -> ResultMap in value.resultMap } } }, forKey: "participants")
              }
            }

            public struct Participant: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Participant"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("gamerTag", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(gamerTag: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "Participant", "gamerTag": gamerTag])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The tag that was used in registration e.g. Mang0
              public var gamerTag: String? {
                get {
                  return resultMap["gamerTag"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "gamerTag")
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class EventStandingsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query EventStandings($id: ID, $page: Int) {
      event(id: $id) {
        __typename
        standings(query: {page: $page, perPage: 65}) {
          __typename
          nodes {
            __typename
            placement
            entrant {
              __typename
              name
              participants {
                __typename
                gamerTag
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "EventStandings"

  public var id: GraphQLID?
  public var page: Int?

  public init(id: GraphQLID? = nil, page: Int? = nil) {
    self.id = id
    self.page = page
  }

  public var variables: GraphQLMap? {
    return ["id": id, "page": page]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("event", arguments: ["id": GraphQLVariable("id")], type: .object(Event.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(event: Event? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "event": event.flatMap { (value: Event) -> ResultMap in value.resultMap }])
    }

    /// Returns an event given its id or slug
    public var event: Event? {
      get {
        return (resultMap["event"] as? ResultMap).flatMap { Event(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "event")
      }
    }

    public struct Event: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Event"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("standings", arguments: ["query": ["page": GraphQLVariable("page"), "perPage": 65]], type: .object(Standing.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(standings: Standing? = nil) {
        self.init(unsafeResultMap: ["__typename": "Event", "standings": standings.flatMap { (value: Standing) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Paginated list of standings
      public var standings: Standing? {
        get {
          return (resultMap["standings"] as? ResultMap).flatMap { Standing(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "standings")
        }
      }

      public struct Standing: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["StandingConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "StandingConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Standing"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("placement", type: .scalar(Int.self)),
              GraphQLField("entrant", type: .object(Entrant.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(placement: Int? = nil, entrant: Entrant? = nil) {
            self.init(unsafeResultMap: ["__typename": "Standing", "placement": placement, "entrant": entrant.flatMap { (value: Entrant) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var placement: Int? {
            get {
              return resultMap["placement"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "placement")
            }
          }

          /// If the entity this standing is assigned to can be resolved into an entrant, this will provide the entrant.
          public var entrant: Entrant? {
            get {
              return (resultMap["entrant"] as? ResultMap).flatMap { Entrant(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "entrant")
            }
          }

          public struct Entrant: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Entrant"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("participants", type: .list(.object(Participant.selections))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(name: String? = nil, participants: [Participant?]? = nil) {
              self.init(unsafeResultMap: ["__typename": "Entrant", "name": name, "participants": participants.flatMap { (value: [Participant?]) -> [ResultMap?] in value.map { (value: Participant?) -> ResultMap? in value.flatMap { (value: Participant) -> ResultMap in value.resultMap } } }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The entrant name as it appears in bracket: gamerTag of the participant or team name
            public var name: String? {
              get {
                return resultMap["name"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }

            public var participants: [Participant?]? {
              get {
                return (resultMap["participants"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Participant?] in value.map { (value: ResultMap?) -> Participant? in value.flatMap { (value: ResultMap) -> Participant in Participant(unsafeResultMap: value) } } }
              }
              set {
                resultMap.updateValue(newValue.flatMap { (value: [Participant?]) -> [ResultMap?] in value.map { (value: Participant?) -> ResultMap? in value.flatMap { (value: Participant) -> ResultMap in value.resultMap } } }, forKey: "participants")
              }
            }

            public struct Participant: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Participant"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("gamerTag", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(gamerTag: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "Participant", "gamerTag": gamerTag])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The tag that was used in registration e.g. Mang0
              public var gamerTag: String? {
                get {
                  return resultMap["gamerTag"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "gamerTag")
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class PhaseGroupsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query PhaseGroups($id: ID, $perPage: Int) {
      phase(id: $id) {
        __typename
        phaseGroups(query: {perPage: $perPage}) {
          __typename
          nodes {
            __typename
            id
            displayIdentifier
            state
          }
        }
      }
    }
    """

  public let operationName: String = "PhaseGroups"

  public var id: GraphQLID?
  public var perPage: Int?

  public init(id: GraphQLID? = nil, perPage: Int? = nil) {
    self.id = id
    self.perPage = perPage
  }

  public var variables: GraphQLMap? {
    return ["id": id, "perPage": perPage]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("phase", arguments: ["id": GraphQLVariable("id")], type: .object(Phase.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(phase: Phase? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "phase": phase.flatMap { (value: Phase) -> ResultMap in value.resultMap }])
    }

    /// Returns a phase given its id
    public var phase: Phase? {
      get {
        return (resultMap["phase"] as? ResultMap).flatMap { Phase(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "phase")
      }
    }

    public struct Phase: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Phase"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("phaseGroups", arguments: ["query": ["perPage": GraphQLVariable("perPage")]], type: .object(PhaseGroup.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(phaseGroups: PhaseGroup? = nil) {
        self.init(unsafeResultMap: ["__typename": "Phase", "phaseGroups": phaseGroups.flatMap { (value: PhaseGroup) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Phase groups under this phase, paginated
      public var phaseGroups: PhaseGroup? {
        get {
          return (resultMap["phaseGroups"] as? ResultMap).flatMap { PhaseGroup(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "phaseGroups")
        }
      }

      public struct PhaseGroup: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PhaseGroupConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "PhaseGroupConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PhaseGroup"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .scalar(GraphQLID.self)),
              GraphQLField("displayIdentifier", type: .scalar(String.self)),
              GraphQLField("state", type: .scalar(Int.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID? = nil, displayIdentifier: String? = nil, state: Int? = nil) {
            self.init(unsafeResultMap: ["__typename": "PhaseGroup", "id": id, "displayIdentifier": displayIdentifier, "state": state])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID? {
            get {
              return resultMap["id"] as? GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          /// Unique identifier for this group within the context of its phase
          public var displayIdentifier: String? {
            get {
              return resultMap["displayIdentifier"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "displayIdentifier")
            }
          }

          public var state: Int? {
            get {
              return resultMap["state"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "state")
            }
          }
        }
      }
    }
  }
}

public final class PhaseGroupQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query PhaseGroup($id: ID) {
      phaseGroup(id: $id) {
        __typename
        bracketType
        progressionsOut {
          __typename
          originPlacement
        }
        standings(query: {page: 1, perPage: 65}) {
          __typename
          nodes {
            __typename
            placement
            entrant {
              __typename
              id
              name
              participants {
                __typename
                gamerTag
              }
            }
          }
        }
        sets(page: 1, perPage: 90) {
          __typename
          nodes {
            __typename
            id
            state
            round
            identifier
            fullRoundText
            displayScore
            winnerId
            slots {
              __typename
              prereqId
              entrant {
                __typename
                id
                name
                participants {
                  __typename
                  gamerTag
                }
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "PhaseGroup"

  public var id: GraphQLID?

  public init(id: GraphQLID? = nil) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("phaseGroup", arguments: ["id": GraphQLVariable("id")], type: .object(PhaseGroup.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(phaseGroup: PhaseGroup? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "phaseGroup": phaseGroup.flatMap { (value: PhaseGroup) -> ResultMap in value.resultMap }])
    }

    /// Returns a phase group given its id
    public var phaseGroup: PhaseGroup? {
      get {
        return (resultMap["phaseGroup"] as? ResultMap).flatMap { PhaseGroup(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "phaseGroup")
      }
    }

    public struct PhaseGroup: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["PhaseGroup"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("bracketType", type: .scalar(BracketType.self)),
          GraphQLField("progressionsOut", type: .list(.object(ProgressionsOut.selections))),
          GraphQLField("standings", arguments: ["query": ["page": 1, "perPage": 65]], type: .object(Standing.selections)),
          GraphQLField("sets", arguments: ["page": 1, "perPage": 90], type: .object(Set.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(bracketType: BracketType? = nil, progressionsOut: [ProgressionsOut?]? = nil, standings: Standing? = nil, sets: Set? = nil) {
        self.init(unsafeResultMap: ["__typename": "PhaseGroup", "bracketType": bracketType, "progressionsOut": progressionsOut.flatMap { (value: [ProgressionsOut?]) -> [ResultMap?] in value.map { (value: ProgressionsOut?) -> ResultMap? in value.flatMap { (value: ProgressionsOut) -> ResultMap in value.resultMap } } }, "standings": standings.flatMap { (value: Standing) -> ResultMap in value.resultMap }, "sets": sets.flatMap { (value: Set) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The bracket type of this group's phase.
      public var bracketType: BracketType? {
        get {
          return resultMap["bracketType"] as? BracketType
        }
        set {
          resultMap.updateValue(newValue, forKey: "bracketType")
        }
      }

      /// The progressions out of this phase group
      public var progressionsOut: [ProgressionsOut?]? {
        get {
          return (resultMap["progressionsOut"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [ProgressionsOut?] in value.map { (value: ResultMap?) -> ProgressionsOut? in value.flatMap { (value: ResultMap) -> ProgressionsOut in ProgressionsOut(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [ProgressionsOut?]) -> [ResultMap?] in value.map { (value: ProgressionsOut?) -> ResultMap? in value.flatMap { (value: ProgressionsOut) -> ResultMap in value.resultMap } } }, forKey: "progressionsOut")
        }
      }

      /// Paginated list of standings
      public var standings: Standing? {
        get {
          return (resultMap["standings"] as? ResultMap).flatMap { Standing(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "standings")
        }
      }

      /// Paginated sets on this phaseGroup
      public var sets: Set? {
        get {
          return (resultMap["sets"] as? ResultMap).flatMap { Set(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "sets")
        }
      }

      public struct ProgressionsOut: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Progression"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("originPlacement", type: .scalar(Int.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(originPlacement: Int? = nil) {
          self.init(unsafeResultMap: ["__typename": "Progression", "originPlacement": originPlacement])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var originPlacement: Int? {
          get {
            return resultMap["originPlacement"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "originPlacement")
          }
        }
      }

      public struct Standing: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["StandingConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "StandingConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Standing"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("placement", type: .scalar(Int.self)),
              GraphQLField("entrant", type: .object(Entrant.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(placement: Int? = nil, entrant: Entrant? = nil) {
            self.init(unsafeResultMap: ["__typename": "Standing", "placement": placement, "entrant": entrant.flatMap { (value: Entrant) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var placement: Int? {
            get {
              return resultMap["placement"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "placement")
            }
          }

          /// If the entity this standing is assigned to can be resolved into an entrant, this will provide the entrant.
          public var entrant: Entrant? {
            get {
              return (resultMap["entrant"] as? ResultMap).flatMap { Entrant(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "entrant")
            }
          }

          public struct Entrant: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Entrant"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .scalar(GraphQLID.self)),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("participants", type: .list(.object(Participant.selections))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: GraphQLID? = nil, name: String? = nil, participants: [Participant?]? = nil) {
              self.init(unsafeResultMap: ["__typename": "Entrant", "id": id, "name": name, "participants": participants.flatMap { (value: [Participant?]) -> [ResultMap?] in value.map { (value: Participant?) -> ResultMap? in value.flatMap { (value: Participant) -> ResultMap in value.resultMap } } }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: GraphQLID? {
              get {
                return resultMap["id"] as? GraphQLID
              }
              set {
                resultMap.updateValue(newValue, forKey: "id")
              }
            }

            /// The entrant name as it appears in bracket: gamerTag of the participant or team name
            public var name: String? {
              get {
                return resultMap["name"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }

            public var participants: [Participant?]? {
              get {
                return (resultMap["participants"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Participant?] in value.map { (value: ResultMap?) -> Participant? in value.flatMap { (value: ResultMap) -> Participant in Participant(unsafeResultMap: value) } } }
              }
              set {
                resultMap.updateValue(newValue.flatMap { (value: [Participant?]) -> [ResultMap?] in value.map { (value: Participant?) -> ResultMap? in value.flatMap { (value: Participant) -> ResultMap in value.resultMap } } }, forKey: "participants")
              }
            }

            public struct Participant: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Participant"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("gamerTag", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(gamerTag: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "Participant", "gamerTag": gamerTag])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The tag that was used in registration e.g. Mang0
              public var gamerTag: String? {
                get {
                  return resultMap["gamerTag"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "gamerTag")
                }
              }
            }
          }
        }
      }

      public struct Set: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["SetConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "SetConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Set"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .scalar(GraphQLID.self)),
              GraphQLField("state", type: .scalar(Int.self)),
              GraphQLField("round", type: .scalar(Int.self)),
              GraphQLField("identifier", type: .scalar(String.self)),
              GraphQLField("fullRoundText", type: .scalar(String.self)),
              GraphQLField("displayScore", type: .scalar(String.self)),
              GraphQLField("winnerId", type: .scalar(Int.self)),
              GraphQLField("slots", type: .list(.object(Slot.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID? = nil, state: Int? = nil, round: Int? = nil, identifier: String? = nil, fullRoundText: String? = nil, displayScore: String? = nil, winnerId: Int? = nil, slots: [Slot?]? = nil) {
            self.init(unsafeResultMap: ["__typename": "Set", "id": id, "state": state, "round": round, "identifier": identifier, "fullRoundText": fullRoundText, "displayScore": displayScore, "winnerId": winnerId, "slots": slots.flatMap { (value: [Slot?]) -> [ResultMap?] in value.map { (value: Slot?) -> ResultMap? in value.flatMap { (value: Slot) -> ResultMap in value.resultMap } } }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID? {
            get {
              return resultMap["id"] as? GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var state: Int? {
            get {
              return resultMap["state"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "state")
            }
          }

          /// The round number of the set. Negative numbers are losers bracket
          public var round: Int? {
            get {
              return resultMap["round"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "round")
            }
          }

          /// The letters that describe a unique identifier within the pool. Eg. F, AT
          public var identifier: String? {
            get {
              return resultMap["identifier"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "identifier")
            }
          }

          /// Full round text of this set.
          public var fullRoundText: String? {
            get {
              return resultMap["fullRoundText"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "fullRoundText")
            }
          }

          public var displayScore: String? {
            get {
              return resultMap["displayScore"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "displayScore")
            }
          }

          public var winnerId: Int? {
            get {
              return resultMap["winnerId"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "winnerId")
            }
          }

          /// A possible spot in a set. Use this to get all entrants in a set. Use this for all bracket types (FFA, elimination, etc)
          public var slots: [Slot?]? {
            get {
              return (resultMap["slots"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Slot?] in value.map { (value: ResultMap?) -> Slot? in value.flatMap { (value: ResultMap) -> Slot in Slot(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [Slot?]) -> [ResultMap?] in value.map { (value: Slot?) -> ResultMap? in value.flatMap { (value: Slot) -> ResultMap in value.resultMap } } }, forKey: "slots")
            }
          }

          public struct Slot: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["SetSlot"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("prereqId", type: .scalar(String.self)),
                GraphQLField("entrant", type: .object(Entrant.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(prereqId: String? = nil, entrant: Entrant? = nil) {
              self.init(unsafeResultMap: ["__typename": "SetSlot", "prereqId": prereqId, "entrant": entrant.flatMap { (value: Entrant) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Pairs with prereqType, is the ID of the prereq.
            public var prereqId: String? {
              get {
                return resultMap["prereqId"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "prereqId")
              }
            }

            public var entrant: Entrant? {
              get {
                return (resultMap["entrant"] as? ResultMap).flatMap { Entrant(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "entrant")
              }
            }

            public struct Entrant: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Entrant"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .scalar(GraphQLID.self)),
                  GraphQLField("name", type: .scalar(String.self)),
                  GraphQLField("participants", type: .list(.object(Participant.selections))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: GraphQLID? = nil, name: String? = nil, participants: [Participant?]? = nil) {
                self.init(unsafeResultMap: ["__typename": "Entrant", "id": id, "name": name, "participants": participants.flatMap { (value: [Participant?]) -> [ResultMap?] in value.map { (value: Participant?) -> ResultMap? in value.flatMap { (value: Participant) -> ResultMap in value.resultMap } } }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var id: GraphQLID? {
                get {
                  return resultMap["id"] as? GraphQLID
                }
                set {
                  resultMap.updateValue(newValue, forKey: "id")
                }
              }

              /// The entrant name as it appears in bracket: gamerTag of the participant or team name
              public var name: String? {
                get {
                  return resultMap["name"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "name")
                }
              }

              public var participants: [Participant?]? {
                get {
                  return (resultMap["participants"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Participant?] in value.map { (value: ResultMap?) -> Participant? in value.flatMap { (value: ResultMap) -> Participant in Participant(unsafeResultMap: value) } } }
                }
                set {
                  resultMap.updateValue(newValue.flatMap { (value: [Participant?]) -> [ResultMap?] in value.map { (value: Participant?) -> ResultMap? in value.flatMap { (value: Participant) -> ResultMap in value.resultMap } } }, forKey: "participants")
                }
              }

              public struct Participant: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Participant"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("gamerTag", type: .scalar(String.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(gamerTag: String? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Participant", "gamerTag": gamerTag])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The tag that was used in registration e.g. Mang0
                public var gamerTag: String? {
                  get {
                    return resultMap["gamerTag"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "gamerTag")
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class PhaseGroupStandingsPageQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query PhaseGroupStandingsPage($id: ID, $page: Int) {
      phaseGroup(id: $id) {
        __typename
        standings(query: {page: $page, perPage: 65}) {
          __typename
          nodes {
            __typename
            placement
            entrant {
              __typename
              id
              name
              participants {
                __typename
                gamerTag
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "PhaseGroupStandingsPage"

  public var id: GraphQLID?
  public var page: Int?

  public init(id: GraphQLID? = nil, page: Int? = nil) {
    self.id = id
    self.page = page
  }

  public var variables: GraphQLMap? {
    return ["id": id, "page": page]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("phaseGroup", arguments: ["id": GraphQLVariable("id")], type: .object(PhaseGroup.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(phaseGroup: PhaseGroup? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "phaseGroup": phaseGroup.flatMap { (value: PhaseGroup) -> ResultMap in value.resultMap }])
    }

    /// Returns a phase group given its id
    public var phaseGroup: PhaseGroup? {
      get {
        return (resultMap["phaseGroup"] as? ResultMap).flatMap { PhaseGroup(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "phaseGroup")
      }
    }

    public struct PhaseGroup: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["PhaseGroup"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("standings", arguments: ["query": ["page": GraphQLVariable("page"), "perPage": 65]], type: .object(Standing.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(standings: Standing? = nil) {
        self.init(unsafeResultMap: ["__typename": "PhaseGroup", "standings": standings.flatMap { (value: Standing) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Paginated list of standings
      public var standings: Standing? {
        get {
          return (resultMap["standings"] as? ResultMap).flatMap { Standing(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "standings")
        }
      }

      public struct Standing: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["StandingConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "StandingConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Standing"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("placement", type: .scalar(Int.self)),
              GraphQLField("entrant", type: .object(Entrant.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(placement: Int? = nil, entrant: Entrant? = nil) {
            self.init(unsafeResultMap: ["__typename": "Standing", "placement": placement, "entrant": entrant.flatMap { (value: Entrant) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var placement: Int? {
            get {
              return resultMap["placement"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "placement")
            }
          }

          /// If the entity this standing is assigned to can be resolved into an entrant, this will provide the entrant.
          public var entrant: Entrant? {
            get {
              return (resultMap["entrant"] as? ResultMap).flatMap { Entrant(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "entrant")
            }
          }

          public struct Entrant: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Entrant"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .scalar(GraphQLID.self)),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("participants", type: .list(.object(Participant.selections))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: GraphQLID? = nil, name: String? = nil, participants: [Participant?]? = nil) {
              self.init(unsafeResultMap: ["__typename": "Entrant", "id": id, "name": name, "participants": participants.flatMap { (value: [Participant?]) -> [ResultMap?] in value.map { (value: Participant?) -> ResultMap? in value.flatMap { (value: Participant) -> ResultMap in value.resultMap } } }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: GraphQLID? {
              get {
                return resultMap["id"] as? GraphQLID
              }
              set {
                resultMap.updateValue(newValue, forKey: "id")
              }
            }

            /// The entrant name as it appears in bracket: gamerTag of the participant or team name
            public var name: String? {
              get {
                return resultMap["name"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }

            public var participants: [Participant?]? {
              get {
                return (resultMap["participants"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Participant?] in value.map { (value: ResultMap?) -> Participant? in value.flatMap { (value: ResultMap) -> Participant in Participant(unsafeResultMap: value) } } }
              }
              set {
                resultMap.updateValue(newValue.flatMap { (value: [Participant?]) -> [ResultMap?] in value.map { (value: Participant?) -> ResultMap? in value.flatMap { (value: Participant) -> ResultMap in value.resultMap } } }, forKey: "participants")
              }
            }

            public struct Participant: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Participant"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("gamerTag", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(gamerTag: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "Participant", "gamerTag": gamerTag])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The tag that was used in registration e.g. Mang0
              public var gamerTag: String? {
                get {
                  return resultMap["gamerTag"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "gamerTag")
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class PhaseGroupSetsPageQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query PhaseGroupSetsPage($id: ID, $page: Int) {
      phaseGroup(id: $id) {
        __typename
        sets(page: $page, perPage: 90) {
          __typename
          nodes {
            __typename
            id
            state
            round
            identifier
            fullRoundText
            displayScore
            winnerId
            slots {
              __typename
              prereqId
              entrant {
                __typename
                id
                name
                participants {
                  __typename
                  gamerTag
                }
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "PhaseGroupSetsPage"

  public var id: GraphQLID?
  public var page: Int?

  public init(id: GraphQLID? = nil, page: Int? = nil) {
    self.id = id
    self.page = page
  }

  public var variables: GraphQLMap? {
    return ["id": id, "page": page]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("phaseGroup", arguments: ["id": GraphQLVariable("id")], type: .object(PhaseGroup.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(phaseGroup: PhaseGroup? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "phaseGroup": phaseGroup.flatMap { (value: PhaseGroup) -> ResultMap in value.resultMap }])
    }

    /// Returns a phase group given its id
    public var phaseGroup: PhaseGroup? {
      get {
        return (resultMap["phaseGroup"] as? ResultMap).flatMap { PhaseGroup(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "phaseGroup")
      }
    }

    public struct PhaseGroup: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["PhaseGroup"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("sets", arguments: ["page": GraphQLVariable("page"), "perPage": 90], type: .object(Set.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(sets: Set? = nil) {
        self.init(unsafeResultMap: ["__typename": "PhaseGroup", "sets": sets.flatMap { (value: Set) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Paginated sets on this phaseGroup
      public var sets: Set? {
        get {
          return (resultMap["sets"] as? ResultMap).flatMap { Set(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "sets")
        }
      }

      public struct Set: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["SetConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "SetConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Set"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .scalar(GraphQLID.self)),
              GraphQLField("state", type: .scalar(Int.self)),
              GraphQLField("round", type: .scalar(Int.self)),
              GraphQLField("identifier", type: .scalar(String.self)),
              GraphQLField("fullRoundText", type: .scalar(String.self)),
              GraphQLField("displayScore", type: .scalar(String.self)),
              GraphQLField("winnerId", type: .scalar(Int.self)),
              GraphQLField("slots", type: .list(.object(Slot.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID? = nil, state: Int? = nil, round: Int? = nil, identifier: String? = nil, fullRoundText: String? = nil, displayScore: String? = nil, winnerId: Int? = nil, slots: [Slot?]? = nil) {
            self.init(unsafeResultMap: ["__typename": "Set", "id": id, "state": state, "round": round, "identifier": identifier, "fullRoundText": fullRoundText, "displayScore": displayScore, "winnerId": winnerId, "slots": slots.flatMap { (value: [Slot?]) -> [ResultMap?] in value.map { (value: Slot?) -> ResultMap? in value.flatMap { (value: Slot) -> ResultMap in value.resultMap } } }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID? {
            get {
              return resultMap["id"] as? GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var state: Int? {
            get {
              return resultMap["state"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "state")
            }
          }

          /// The round number of the set. Negative numbers are losers bracket
          public var round: Int? {
            get {
              return resultMap["round"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "round")
            }
          }

          /// The letters that describe a unique identifier within the pool. Eg. F, AT
          public var identifier: String? {
            get {
              return resultMap["identifier"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "identifier")
            }
          }

          /// Full round text of this set.
          public var fullRoundText: String? {
            get {
              return resultMap["fullRoundText"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "fullRoundText")
            }
          }

          public var displayScore: String? {
            get {
              return resultMap["displayScore"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "displayScore")
            }
          }

          public var winnerId: Int? {
            get {
              return resultMap["winnerId"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "winnerId")
            }
          }

          /// A possible spot in a set. Use this to get all entrants in a set. Use this for all bracket types (FFA, elimination, etc)
          public var slots: [Slot?]? {
            get {
              return (resultMap["slots"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Slot?] in value.map { (value: ResultMap?) -> Slot? in value.flatMap { (value: ResultMap) -> Slot in Slot(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [Slot?]) -> [ResultMap?] in value.map { (value: Slot?) -> ResultMap? in value.flatMap { (value: Slot) -> ResultMap in value.resultMap } } }, forKey: "slots")
            }
          }

          public struct Slot: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["SetSlot"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("prereqId", type: .scalar(String.self)),
                GraphQLField("entrant", type: .object(Entrant.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(prereqId: String? = nil, entrant: Entrant? = nil) {
              self.init(unsafeResultMap: ["__typename": "SetSlot", "prereqId": prereqId, "entrant": entrant.flatMap { (value: Entrant) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Pairs with prereqType, is the ID of the prereq.
            public var prereqId: String? {
              get {
                return resultMap["prereqId"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "prereqId")
              }
            }

            public var entrant: Entrant? {
              get {
                return (resultMap["entrant"] as? ResultMap).flatMap { Entrant(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "entrant")
              }
            }

            public struct Entrant: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Entrant"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .scalar(GraphQLID.self)),
                  GraphQLField("name", type: .scalar(String.self)),
                  GraphQLField("participants", type: .list(.object(Participant.selections))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: GraphQLID? = nil, name: String? = nil, participants: [Participant?]? = nil) {
                self.init(unsafeResultMap: ["__typename": "Entrant", "id": id, "name": name, "participants": participants.flatMap { (value: [Participant?]) -> [ResultMap?] in value.map { (value: Participant?) -> ResultMap? in value.flatMap { (value: Participant) -> ResultMap in value.resultMap } } }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var id: GraphQLID? {
                get {
                  return resultMap["id"] as? GraphQLID
                }
                set {
                  resultMap.updateValue(newValue, forKey: "id")
                }
              }

              /// The entrant name as it appears in bracket: gamerTag of the participant or team name
              public var name: String? {
                get {
                  return resultMap["name"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "name")
                }
              }

              public var participants: [Participant?]? {
                get {
                  return (resultMap["participants"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Participant?] in value.map { (value: ResultMap?) -> Participant? in value.flatMap { (value: ResultMap) -> Participant in Participant(unsafeResultMap: value) } } }
                }
                set {
                  resultMap.updateValue(newValue.flatMap { (value: [Participant?]) -> [ResultMap?] in value.map { (value: Participant?) -> ResultMap? in value.flatMap { (value: Participant) -> ResultMap in value.resultMap } } }, forKey: "participants")
                }
              }

              public struct Participant: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Participant"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("gamerTag", type: .scalar(String.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(gamerTag: String? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Participant", "gamerTag": gamerTag])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The tag that was used in registration e.g. Mang0
                public var gamerTag: String? {
                  get {
                    return resultMap["gamerTag"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "gamerTag")
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class PhaseGroupSetGamesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query PhaseGroupSetGames($id: ID!) {
      set(id: $id) {
        __typename
        games {
          __typename
          winnerId
          stage {
            __typename
            name
          }
        }
      }
    }
    """

  public let operationName: String = "PhaseGroupSetGames"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("set", arguments: ["id": GraphQLVariable("id")], type: .object(Set.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(`set`: Set? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "set": `set`.flatMap { (value: Set) -> ResultMap in value.resultMap }])
    }

    /// Returns a set given its id
    public var `set`: Set? {
      get {
        return (resultMap["set"] as? ResultMap).flatMap { Set(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "set")
      }
    }

    public struct Set: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Set"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("games", type: .list(.object(Game.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(games: [Game?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Set", "games": games.flatMap { (value: [Game?]) -> [ResultMap?] in value.map { (value: Game?) -> ResultMap? in value.flatMap { (value: Game) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var games: [Game?]? {
        get {
          return (resultMap["games"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Game?] in value.map { (value: ResultMap?) -> Game? in value.flatMap { (value: ResultMap) -> Game in Game(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Game?]) -> [ResultMap?] in value.map { (value: Game?) -> ResultMap? in value.flatMap { (value: Game) -> ResultMap in value.resultMap } } }, forKey: "games")
        }
      }

      public struct Game: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Game"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("winnerId", type: .scalar(Int.self)),
            GraphQLField("stage", type: .object(Stage.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(winnerId: Int? = nil, stage: Stage? = nil) {
          self.init(unsafeResultMap: ["__typename": "Game", "winnerId": winnerId, "stage": stage.flatMap { (value: Stage) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var winnerId: Int? {
          get {
            return resultMap["winnerId"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "winnerId")
          }
        }

        /// The stage that this game was played on (if applicable)
        public var stage: Stage? {
          get {
            return (resultMap["stage"] as? ResultMap).flatMap { Stage(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "stage")
          }
        }

        public struct Stage: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Stage"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Stage", "name": name])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Stage name
          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }
        }
      }
    }
  }
}

public final class CurrentUserQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query CurrentUser($perPage: Int) {
      currentUser {
        __typename
        bio
        player {
          __typename
          prefix
          gamerTag
        }
        images {
          __typename
          type
          url
        }
        tournaments(query: {page: 1, perPage: $perPage}) {
          __typename
          nodes {
            __typename
            id
            name
            startAt
            endAt
            venueAddress
            isOnline
            images {
              __typename
              url
              type
              ratio
            }
          }
        }
      }
    }
    """

  public let operationName: String = "CurrentUser"

  public var perPage: Int?

  public init(perPage: Int? = nil) {
    self.perPage = perPage
  }

  public var variables: GraphQLMap? {
    return ["perPage": perPage]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("currentUser", type: .object(CurrentUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(currentUser: CurrentUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "currentUser": currentUser.flatMap { (value: CurrentUser) -> ResultMap in value.resultMap }])
    }

    /// Returns the authenticated user
    public var currentUser: CurrentUser? {
      get {
        return (resultMap["currentUser"] as? ResultMap).flatMap { CurrentUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "currentUser")
      }
    }

    public struct CurrentUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("bio", type: .scalar(String.self)),
          GraphQLField("player", type: .object(Player.selections)),
          GraphQLField("images", type: .list(.object(Image.selections))),
          GraphQLField("tournaments", arguments: ["query": ["page": 1, "perPage": GraphQLVariable("perPage")]], type: .object(Tournament.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(bio: String? = nil, player: Player? = nil, images: [Image?]? = nil, tournaments: Tournament? = nil) {
        self.init(unsafeResultMap: ["__typename": "User", "bio": bio, "player": player.flatMap { (value: Player) -> ResultMap in value.resultMap }, "images": images.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }, "tournaments": tournaments.flatMap { (value: Tournament) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var bio: String? {
        get {
          return resultMap["bio"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "bio")
        }
      }

      /// player for user
      public var player: Player? {
        get {
          return (resultMap["player"] as? ResultMap).flatMap { Player(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "player")
        }
      }

      public var images: [Image?]? {
        get {
          return (resultMap["images"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Image?] in value.map { (value: ResultMap?) -> Image? in value.flatMap { (value: ResultMap) -> Image in Image(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }, forKey: "images")
        }
      }

      /// Tournaments this user is organizing or competing in
      public var tournaments: Tournament? {
        get {
          return (resultMap["tournaments"] as? ResultMap).flatMap { Tournament(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "tournaments")
        }
      }

      public struct Player: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Player"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("prefix", type: .scalar(String.self)),
            GraphQLField("gamerTag", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(`prefix`: String? = nil, gamerTag: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Player", "prefix": `prefix`, "gamerTag": gamerTag])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var `prefix`: String? {
          get {
            return resultMap["prefix"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "prefix")
          }
        }

        public var gamerTag: String? {
          get {
            return resultMap["gamerTag"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "gamerTag")
          }
        }
      }

      public struct Image: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Image"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("type", type: .scalar(String.self)),
            GraphQLField("url", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(type: String? = nil, url: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Image", "type": type, "url": url])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var type: String? {
          get {
            return resultMap["type"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "type")
          }
        }

        public var url: String? {
          get {
            return resultMap["url"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "url")
          }
        }
      }

      public struct Tournament: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["TournamentConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "TournamentConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Tournament"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .scalar(GraphQLID.self)),
              GraphQLField("name", type: .scalar(String.self)),
              GraphQLField("startAt", type: .scalar(String.self)),
              GraphQLField("endAt", type: .scalar(String.self)),
              GraphQLField("venueAddress", type: .scalar(String.self)),
              GraphQLField("isOnline", type: .scalar(Bool.self)),
              GraphQLField("images", type: .list(.object(Image.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID? = nil, name: String? = nil, startAt: String? = nil, endAt: String? = nil, venueAddress: String? = nil, isOnline: Bool? = nil, images: [Image?]? = nil) {
            self.init(unsafeResultMap: ["__typename": "Tournament", "id": id, "name": name, "startAt": startAt, "endAt": endAt, "venueAddress": venueAddress, "isOnline": isOnline, "images": images.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID? {
            get {
              return resultMap["id"] as? GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          /// The tournament name
          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          /// When the tournament Starts
          public var startAt: String? {
            get {
              return resultMap["startAt"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "startAt")
            }
          }

          /// When the tournament ends
          public var endAt: String? {
            get {
              return resultMap["endAt"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "endAt")
            }
          }

          public var venueAddress: String? {
            get {
              return resultMap["venueAddress"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "venueAddress")
            }
          }

          /// True if tournament has at least one online event
          public var isOnline: Bool? {
            get {
              return resultMap["isOnline"] as? Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "isOnline")
            }
          }

          public var images: [Image?]? {
            get {
              return (resultMap["images"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Image?] in value.map { (value: ResultMap?) -> Image? in value.flatMap { (value: ResultMap) -> Image in Image(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }, forKey: "images")
            }
          }

          public struct Image: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Image"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("url", type: .scalar(String.self)),
                GraphQLField("type", type: .scalar(String.self)),
                GraphQLField("ratio", type: .scalar(Double.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(url: String? = nil, type: String? = nil, ratio: Double? = nil) {
              self.init(unsafeResultMap: ["__typename": "Image", "url": url, "type": type, "ratio": ratio])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var url: String? {
              get {
                return resultMap["url"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "url")
              }
            }

            public var type: String? {
              get {
                return resultMap["type"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "type")
              }
            }

            public var ratio: Double? {
              get {
                return resultMap["ratio"] as? Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "ratio")
              }
            }
          }
        }
      }
    }
  }
}

public final class CurrentUserTournamentsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query CurrentUserTournaments($page: Int, $perPage: Int) {
      currentUser {
        __typename
        tournaments(query: {page: $page, perPage: $perPage}) {
          __typename
          nodes {
            __typename
            id
            name
            startAt
            endAt
            venueAddress
            isOnline
            images {
              __typename
              url
              type
              ratio
            }
          }
        }
      }
    }
    """

  public let operationName: String = "CurrentUserTournaments"

  public var page: Int?
  public var perPage: Int?

  public init(page: Int? = nil, perPage: Int? = nil) {
    self.page = page
    self.perPage = perPage
  }

  public var variables: GraphQLMap? {
    return ["page": page, "perPage": perPage]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("currentUser", type: .object(CurrentUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(currentUser: CurrentUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "currentUser": currentUser.flatMap { (value: CurrentUser) -> ResultMap in value.resultMap }])
    }

    /// Returns the authenticated user
    public var currentUser: CurrentUser? {
      get {
        return (resultMap["currentUser"] as? ResultMap).flatMap { CurrentUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "currentUser")
      }
    }

    public struct CurrentUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("tournaments", arguments: ["query": ["page": GraphQLVariable("page"), "perPage": GraphQLVariable("perPage")]], type: .object(Tournament.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(tournaments: Tournament? = nil) {
        self.init(unsafeResultMap: ["__typename": "User", "tournaments": tournaments.flatMap { (value: Tournament) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Tournaments this user is organizing or competing in
      public var tournaments: Tournament? {
        get {
          return (resultMap["tournaments"] as? ResultMap).flatMap { Tournament(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "tournaments")
        }
      }

      public struct Tournament: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["TournamentConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "TournamentConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Tournament"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .scalar(GraphQLID.self)),
              GraphQLField("name", type: .scalar(String.self)),
              GraphQLField("startAt", type: .scalar(String.self)),
              GraphQLField("endAt", type: .scalar(String.self)),
              GraphQLField("venueAddress", type: .scalar(String.self)),
              GraphQLField("isOnline", type: .scalar(Bool.self)),
              GraphQLField("images", type: .list(.object(Image.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID? = nil, name: String? = nil, startAt: String? = nil, endAt: String? = nil, venueAddress: String? = nil, isOnline: Bool? = nil, images: [Image?]? = nil) {
            self.init(unsafeResultMap: ["__typename": "Tournament", "id": id, "name": name, "startAt": startAt, "endAt": endAt, "venueAddress": venueAddress, "isOnline": isOnline, "images": images.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID? {
            get {
              return resultMap["id"] as? GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          /// The tournament name
          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          /// When the tournament Starts
          public var startAt: String? {
            get {
              return resultMap["startAt"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "startAt")
            }
          }

          /// When the tournament ends
          public var endAt: String? {
            get {
              return resultMap["endAt"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "endAt")
            }
          }

          public var venueAddress: String? {
            get {
              return resultMap["venueAddress"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "venueAddress")
            }
          }

          /// True if tournament has at least one online event
          public var isOnline: Bool? {
            get {
              return resultMap["isOnline"] as? Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "isOnline")
            }
          }

          public var images: [Image?]? {
            get {
              return (resultMap["images"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Image?] in value.map { (value: ResultMap?) -> Image? in value.flatMap { (value: ResultMap) -> Image in Image(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }, forKey: "images")
            }
          }

          public struct Image: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Image"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("url", type: .scalar(String.self)),
                GraphQLField("type", type: .scalar(String.self)),
                GraphQLField("ratio", type: .scalar(Double.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(url: String? = nil, type: String? = nil, ratio: Double? = nil) {
              self.init(unsafeResultMap: ["__typename": "Image", "url": url, "type": type, "ratio": ratio])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var url: String? {
              get {
                return resultMap["url"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "url")
              }
            }

            public var type: String? {
              get {
                return resultMap["type"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "type")
              }
            }

            public var ratio: Double? {
              get {
                return resultMap["ratio"] as? Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "ratio")
              }
            }
          }
        }
      }
    }
  }
}

public final class UserTournamentsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query UserTournaments($id: ID, $page: Int, $perPage: Int) {
      user(id: $id) {
        __typename
        name
        tournaments(query: {page: $page, perPage: $perPage, filter: {tournamentView: "organizing"}}) {
          __typename
          nodes {
            __typename
            id
            name
            startAt
            endAt
            venueAddress
            isOnline
            images {
              __typename
              url
              type
              ratio
            }
          }
        }
      }
    }
    """

  public let operationName: String = "UserTournaments"

  public var id: GraphQLID?
  public var page: Int?
  public var perPage: Int?

  public init(id: GraphQLID? = nil, page: Int? = nil, perPage: Int? = nil) {
    self.id = id
    self.page = page
    self.perPage = perPage
  }

  public var variables: GraphQLMap? {
    return ["id": id, "page": page, "perPage": perPage]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("user", arguments: ["id": GraphQLVariable("id")], type: .object(User.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(user: User? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }])
    }

    /// Returns a user given a user slug of the form user/abc123, or id
    public var user: User? {
      get {
        return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "user")
      }
    }

    public struct User: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("tournaments", arguments: ["query": ["page": GraphQLVariable("page"), "perPage": GraphQLVariable("perPage"), "filter": ["tournamentView": "organizing"]]], type: .object(Tournament.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(name: String? = nil, tournaments: Tournament? = nil) {
        self.init(unsafeResultMap: ["__typename": "User", "name": name, "tournaments": tournaments.flatMap { (value: Tournament) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Public facing user name that respects user publishing settings
      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      /// Tournaments this user is organizing or competing in
      public var tournaments: Tournament? {
        get {
          return (resultMap["tournaments"] as? ResultMap).flatMap { Tournament(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "tournaments")
        }
      }

      public struct Tournament: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["TournamentConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "TournamentConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Tournament"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .scalar(GraphQLID.self)),
              GraphQLField("name", type: .scalar(String.self)),
              GraphQLField("startAt", type: .scalar(String.self)),
              GraphQLField("endAt", type: .scalar(String.self)),
              GraphQLField("venueAddress", type: .scalar(String.self)),
              GraphQLField("isOnline", type: .scalar(Bool.self)),
              GraphQLField("images", type: .list(.object(Image.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID? = nil, name: String? = nil, startAt: String? = nil, endAt: String? = nil, venueAddress: String? = nil, isOnline: Bool? = nil, images: [Image?]? = nil) {
            self.init(unsafeResultMap: ["__typename": "Tournament", "id": id, "name": name, "startAt": startAt, "endAt": endAt, "venueAddress": venueAddress, "isOnline": isOnline, "images": images.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID? {
            get {
              return resultMap["id"] as? GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          /// The tournament name
          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          /// When the tournament Starts
          public var startAt: String? {
            get {
              return resultMap["startAt"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "startAt")
            }
          }

          /// When the tournament ends
          public var endAt: String? {
            get {
              return resultMap["endAt"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "endAt")
            }
          }

          public var venueAddress: String? {
            get {
              return resultMap["venueAddress"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "venueAddress")
            }
          }

          /// True if tournament has at least one online event
          public var isOnline: Bool? {
            get {
              return resultMap["isOnline"] as? Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "isOnline")
            }
          }

          public var images: [Image?]? {
            get {
              return (resultMap["images"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Image?] in value.map { (value: ResultMap?) -> Image? in value.flatMap { (value: ResultMap) -> Image in Image(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }, forKey: "images")
            }
          }

          public struct Image: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Image"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("url", type: .scalar(String.self)),
                GraphQLField("type", type: .scalar(String.self)),
                GraphQLField("ratio", type: .scalar(Double.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(url: String? = nil, type: String? = nil, ratio: Double? = nil) {
              self.init(unsafeResultMap: ["__typename": "Image", "url": url, "type": type, "ratio": ratio])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var url: String? {
              get {
                return resultMap["url"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "url")
              }
            }

            public var type: String? {
              get {
                return resultMap["type"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "type")
              }
            }

            public var ratio: Double? {
              get {
                return resultMap["ratio"] as? Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "ratio")
              }
            }
          }
        }
      }
    }
  }
}
