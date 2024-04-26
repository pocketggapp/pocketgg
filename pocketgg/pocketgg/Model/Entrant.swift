struct Entrant: Hashable {
  let id: Int
  let name: String?
  let teamName: String?
}

extension Entrant {
  func formattedName() -> (prefix: String, name: String) {
    if let teamName, let name {
      return (teamName, name)
    } else if let name {
      return ("", name)
    } else if let teamName {
      return (teamName, "")
    } else {
      return ("", "")
    }
  }
}
