// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Represents the state of an activity
public enum ActivityState: String, EnumType {
  /// Activity is created
  case created = "CREATED"
  /// Activity is active or in progress
  case active = "ACTIVE"
  /// Activity is done
  case completed = "COMPLETED"
  /// Activity is ready to be started
  case ready = "READY"
  /// Activity is invalid
  case invalid = "INVALID"
  /// Activity, like a set, has been called to start
  case called = "CALLED"
  /// Activity is queued to run
  case queued = "QUEUED"
}
