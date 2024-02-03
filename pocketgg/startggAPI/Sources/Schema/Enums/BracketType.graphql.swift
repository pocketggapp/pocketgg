// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// The type of Bracket format that a Phase is configured with.
public enum BracketType: String, EnumType {
  case singleElimination = "SINGLE_ELIMINATION"
  case doubleElimination = "DOUBLE_ELIMINATION"
  case roundRobin = "ROUND_ROBIN"
  case swiss = "SWISS"
  case exhibition = "EXHIBITION"
  case customSchedule = "CUSTOM_SCHEDULE"
  case matchmaking = "MATCHMAKING"
  case eliminationRounds = "ELIMINATION_ROUNDS"
  case race = "RACE"
  case circuit = "CIRCUIT"
}
