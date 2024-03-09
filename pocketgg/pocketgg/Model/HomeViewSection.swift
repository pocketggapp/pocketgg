import SwiftUI
import UniformTypeIdentifiers

struct HomeViewSection: Codable, Transferable {
  let id: Int
  let name: String
  let imageName: String?
  var enabled: Bool
  
  static var transferRepresentation: some TransferRepresentation {
    CodableRepresentation(contentType: .homeViewSection)
  }
}

extension UTType {
  static let homeViewSection = UTType(exportedAs: "com.gabrielsiu.pocketgg")
}
