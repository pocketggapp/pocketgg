import UniformTypeIdentifiers

@MainActor
final class StartggDeeplinkViewModel: ObservableObject {
  @Published var titleText: String
  @Published var messageText: String
  
  private let extensionItem: NSExtensionItem?
  var launchPocketggApp: ((URL) -> Void)?
  
  init(extensionItem: NSExtensionItem?, launchPocketggApp: ((URL) -> Void)?) {
    self.extensionItem = extensionItem
    self.launchPocketggApp = launchPocketggApp
    self.titleText = "pocketgg"
    self.messageText = "Opening link in pocketgg..."
  }
  
  func onViewAppear() async {
    guard let extensionItem,
          let itemProvider = extensionItem.attachments?.first,
          itemProvider.hasItemConformingToTypeIdentifier("public.url") else {
      titleText = "Error"
      messageText = "Unable to retrieve a public URL."
      return
    }
    
    var url: URL?
    do {
      let result = try await itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier)
      url = result as? URL
    } catch {
      titleText = "Error"
      messageText = "Unable to retrieve a URL."
      return
    }
    
    guard let url else {
      titleText = "Error"
      messageText = "No URL was able to be retrieved."
      return
    }
    
    if let slug = validateSmashGGURL(url) {
      if let pocketggURL = URL(string: "pocketgg://" + slug) {
        if let launchPocketggApp {
          launchPocketggApp(pocketggURL)
        }
      }
    }
  }
  
  private func validateSmashGGURL(_ url: URL) -> String? {
    if let range = url.absoluteString.range(of: "start.gg") {
      let trimmedURL = url.absoluteString[url.absoluteString.index(range.upperBound, offsetBy: 1)...]
      if let backslashIndex = trimmedURL.firstIndex(of: "/") {
        let urlType = trimmedURL[..<backslashIndex]
        switch urlType {
        case "tournament":
          let slug: Substring
          if let secondBackslashIndex = trimmedURL[trimmedURL.index(after: backslashIndex)...].firstIndex(of: "/") {
            slug = trimmedURL[..<secondBackslashIndex]
          } else {
            slug = trimmedURL
          }
          return String(slug)
        case "league":
          titleText = "Error"
          messageText = "Leagues are currently not supported in pocketgg."
        default:
          titleText = "Error"
          messageText = "This type of start.gg page (\(urlType)) is currently not supported in pocketgg."
        }
      } else {
        titleText = "Error"
        messageText = "Not a start.gg tournament page."
      }
    } else {
      titleText = "Error"
      messageText = "Not a valid start.gg page."
    }
    return nil
  }
}
