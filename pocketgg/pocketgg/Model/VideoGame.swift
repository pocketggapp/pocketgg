// Decodable is only needed to allow saved video games on app versions < 2.0 to be decoded, then migrated to Core Data
struct VideoGame: Decodable, Hashable {
  let id: Int
  let name: String
}
