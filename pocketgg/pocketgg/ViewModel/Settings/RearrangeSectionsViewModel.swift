import SwiftUI

enum RearrangeSectionsViewState {
  case uninitialized
  case loaded
}

final class RearrangeSectionsViewModel: ObservableObject {
  @Published var enabledSections: [HomeViewSection]
  @Published var disabledSections: [HomeViewSection]
  
  private var state: RearrangeSectionsViewState
  private let coreDataService: CoreDataService
  private let userDefaults: UserDefaults
  private var enabledVideoGames: [VideoGameEntity]
  private var homeViewLayout: [Int]
  
  private var sentHomeViewRefreshNotification: Bool
  
  init(
    coreDataService: CoreDataService = .shared,
    userDefaults: UserDefaults = .standard
  ) {
    self.state = .uninitialized
    self.enabledSections = []
    self.disabledSections = []
    self.coreDataService = coreDataService
    self.userDefaults = userDefaults
    self.enabledVideoGames = []
    self.homeViewLayout = []
    self.sentHomeViewRefreshNotification = false
  }
  
  func resetHomeViewRefreshNotification() {
    sentHomeViewRefreshNotification = false
  }
  
  func initializeSections() {
    switch state {
    case .uninitialized: break
    default: return
    }
    
    getEnabledVideoGames()
    getHomeViewSectionLayout()
    
    enabledSections = homeViewLayout.map { id in
      switch id {
      case -1:
        return HomeViewSection(id: -1, name: "Pinned", imageName: "pin.fill", enabled: true)
      case -2:
        return HomeViewSection(id: -2, name: "Featured", imageName: "star.fill", enabled: true)
      case -3:
        return HomeViewSection(id: -3, name: "Upcoming", imageName: "hourglass", enabled: true)
      default:
        let name = enabledVideoGames.first(where: { $0.id == id })?.name ?? "" // TODO: Change to compact map, return nil after confirming there are no bugs
        return HomeViewSection(id: id, name: name, imageName: nil, enabled: true)
      }
    }
    
    if !homeViewLayout.contains(-1) {
      disabledSections.append(HomeViewSection(id: -1, name: "Pinned", imageName: "pin.fill", enabled: false))
    }
    if !homeViewLayout.contains(-2) {
      disabledSections.append(HomeViewSection(id: -2, name: "Featured", imageName: "star.fill", enabled: false))
    }
    if !homeViewLayout.contains(-3) {
      disabledSections.append(HomeViewSection(id: -3, name: "Upcoming", imageName: "hourglass", enabled: false))
    }
    
    state = .loaded
  }
  
  // MARK: Home Screen Layout
  
  private func getHomeViewSectionLayout() {
    homeViewLayout = userDefaults.array(forKey: Constants.homeViewSections) as? [Int] ?? []
  }
  
  private func getEnabledVideoGames() {
    do {
      enabledVideoGames = try VideoGamePreferenceService.getVideoGames()
    } catch {
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
  
  func updateHomeViewLayout() {
    UserDefaults.standard.set(enabledSections.map { $0.id }, forKey: Constants.homeViewSections)
    
    if !sentHomeViewRefreshNotification {
      NotificationCenter.default.post(name: Notification.Name(Constants.refreshHomeView), object: nil)
      sentHomeViewRefreshNotification = true
    }
  }
  
  // MARK: Rearrange Sections
  
  /// Rearrange section within the same list
  func rearrangeSection(currentlyDragging: HomeViewSection?, droppingSection: HomeViewSection, enabled: Bool) {
    guard let currentlyDragging else { return }
    
    if enabled {
      if let sourceindex = enabledSections.firstIndex(where: { $0.id == currentlyDragging.id }),
         let destinationIndex = enabledSections.firstIndex(where: { $0.id == droppingSection.id }) {
        var sourceItem = enabledSections.remove(at: sourceindex)
        sourceItem.enabled = true
        enabledSections.insert(sourceItem, at: destinationIndex)
      }
    } else {
      if let sourceindex = disabledSections.firstIndex(where: { $0.id == currentlyDragging.id }),
         let destinationIndex = disabledSections.firstIndex(where: { $0.id == droppingSection.id }) {
        var sourceItem = disabledSections.remove(at: sourceindex)
        sourceItem.enabled = false
        disabledSections.insert(sourceItem, at: destinationIndex)
      }
    }
    
    // TODO: Haptic feedback
  }
  
  /// Appending and removing a section from one list to another
  func appendSection(currentlyDragging: HomeViewSection?, enabled: Bool) {
    guard let currentlyDragging else { return }
    
    if enabled {
      guard !enabledSections.contains(where: { $0.id == currentlyDragging.id }) else { return }
      var updatedSection = currentlyDragging
      updatedSection.enabled = true
      enabledSections.append(updatedSection)
      disabledSections.removeAll(where: { $0.id == currentlyDragging.id })
    } else {
      guard !disabledSections.contains(where: { $0.id == currentlyDragging.id }) else { return }
      var updatedSection = currentlyDragging
      updatedSection.enabled = false
      disabledSections.append(updatedSection)
      enabledSections.removeAll(where: { $0.id == currentlyDragging.id })
    }
    
    if currentlyDragging.id > 0 {
      videoGameMoved(.init(id: currentlyDragging.id, name: currentlyDragging.name))
    }
  }
  
  func videoGameMoved(_ videoGame: VideoGame) {
    if let index = enabledVideoGames.firstIndex(where: { $0.id == videoGame.id }) {
      // Delete existing video game entity
      let videoGameEntity = enabledVideoGames.remove(at: index)
      coreDataService.context.delete(videoGameEntity)
    } else {
      // Add video game entity
      let videoGameEntity = VideoGameEntity(context: coreDataService.context)
      videoGameEntity.id = Int64(videoGame.id)
      videoGameEntity.name = videoGame.name
    }
    // Save the change in Core Data
    coreDataService.save()
    // Refresh the list of video game entities from Core Data
    getEnabledVideoGames()
  }
}
