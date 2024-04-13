// Decodable is only needed to allow saved tournament organizers on app versions < 2.0 to be decoded, then migrated to Core Data
struct TournamentOrganizer: Decodable {
  var id: Int
  var name: String?
  var prefix: String?
  var customName: String?
  var customPrefix: String?
}
