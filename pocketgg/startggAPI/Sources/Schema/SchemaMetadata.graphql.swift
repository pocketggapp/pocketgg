// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public typealias ID = String

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == StartggAPI.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == StartggAPI.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == StartggAPI.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == StartggAPI.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> Object? {
    switch typename {
    case "Query": return StartggAPI.Objects.Query
    case "User": return StartggAPI.Objects.User
    case "Player": return StartggAPI.Objects.Player
    case "Image": return StartggAPI.Objects.Image
    case "TournamentConnection": return StartggAPI.Objects.TournamentConnection
    case "Tournament": return StartggAPI.Objects.Tournament
    case "Event": return StartggAPI.Objects.Event
    case "StandingConnection": return StartggAPI.Objects.StandingConnection
    case "Standing": return StartggAPI.Objects.Standing
    case "Entrant": return StartggAPI.Objects.Entrant
    case "Participant": return StartggAPI.Objects.Participant
    case "Videogame": return StartggAPI.Objects.Videogame
    case "Streams": return StartggAPI.Objects.Streams
    case "Phase": return StartggAPI.Objects.Phase
    case "VideogameConnection": return StartggAPI.Objects.VideogameConnection
    case "PhaseGroupConnection": return StartggAPI.Objects.PhaseGroupConnection
    case "PhaseGroup": return StartggAPI.Objects.PhaseGroup
    case "Progression": return StartggAPI.Objects.Progression
    case "SetConnection": return StartggAPI.Objects.SetConnection
    case "Set": return StartggAPI.Objects.Set
    case "SetSlot": return StartggAPI.Objects.SetSlot
    case "Game": return StartggAPI.Objects.Game
    case "Stage": return StartggAPI.Objects.Stage
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
