import Foundation

/// An external service where the tournament is streamed, and can be viewed online
struct Stream: Hashable {
  let name: String?
  let logoUrl: String?
  let source: String?
  let streamID: String?
}
