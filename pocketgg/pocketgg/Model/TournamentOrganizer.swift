// Decodable is only needed to allow saved tournament organizers on app versions < 2.0 to be decoded, then migrated to Core Data
struct TournamentOrganizer: Hashable, Decodable {
  var id: Int
  var name: String?
  var prefix: String?
  var customName: String?
  var customPrefix: String?
}

extension TournamentOrganizer {
  func formattedName() -> (prefix: String, name: String) {
    if let customPrefix, let customName, !customPrefix.isEmpty, !customName.isEmpty {
      return (customPrefix, customName)
    } else if let customName, !customName.isEmpty {
      return ("", customName)
    } else if let customPrefix, !customPrefix.isEmpty {
      return (customPrefix, "")
    } else if let prefix, let name {
      return (prefix, name)
    } else if let name {
      return ("", name)
    } else if let prefix {
      return (prefix, "")
    } else {
      return ("", "")
    }
  }
}
