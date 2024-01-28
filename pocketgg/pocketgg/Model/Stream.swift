import Foundation

/// An external service where the tournament is streamed, and can be viewed online
struct Stream: Identifiable, Hashable {
  let id = UUID()
  let name: String?
  let logoUrl: String?
  let source: String?
  let streamID: String?
}
