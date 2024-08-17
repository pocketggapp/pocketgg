import SwiftUI
import EventKit

enum TournamentViewState {
  case uninitialized
  case loading
  case loaded(TournamentDetails?)
  case error(is503: Bool)
}

final class TournamentViewModel: ObservableObject {
  @Published var state: TournamentViewState
  
  @Published var isPinned: Bool
  @Published var showingCalendarErrorAlert = false
  @Published var showingAddToCalendarView = false
  @Published var eventStore: EKEventStore?
  @Published var event: EKEvent?
  @Published var tournamentURL: URL?
  
  private let tournament: Tournament
  private let service: StartggServiceType
  
  private var sentHomeViewRefreshNotification: Bool
  private var startDate: Date?
  private var endDate: Date?
  private var locationString: String?
  
  init(
    tournament: Tournament,
    service: StartggServiceType = StartggService.shared
  ) {
    self.state = .uninitialized
    self.isPinned = PinnedTournamentService.tournamentIsPinned(tournamentID: tournament.id)
    self.tournament = tournament
    self.service = service
    self.sentHomeViewRefreshNotification = false
  }
  
  // MARK: Fetch Tournament
  
  @MainActor
  func fetchTournament(refreshed: Bool = false) async {
    if !refreshed {
      switch state {
      case .uninitialized: break
      default: return
      }
    }
    
    state = .loading
    do {
      let tournamentDetails = try await service.getTournamentDetails(id: tournament.id)
      setCalendarEventDetails(tournamentDetails)
      setTournamentURL(tournamentDetails?.slug)
      state = .loaded(tournamentDetails)
    } catch {
      state = .error(is503: error.is503Error)
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
  
  // MARK: Pin / Unpin
  
  func toggleTournamentPinStatus() {
    PinnedTournamentService.toggleTournamentPinStatus(tournamentID: tournament.id)
    isPinned.toggle()
    if !sentHomeViewRefreshNotification {
      NotificationCenter.default.post(name: Notification.Name(Constants.refreshHomeView), object: nil)
      sentHomeViewRefreshNotification = true
    }
  }
  
  func resetHomeViewRefreshNotification() {
    sentHomeViewRefreshNotification = false
  }
  
  // MARK: Add to Calendar
  
  @MainActor
  func addTournamentToCalendar() async {
    guard let startDate, let endDate else { return }
    
    if eventStore == nil {
      self.eventStore = EKEventStore()
    }
    
    switch EKEventStore.authorizationStatus(for: .event) {
    case .fullAccess, .writeOnly:
      break
    case .notDetermined:
      do {
        var accessGranted: Bool?
        if #available(iOS 17.0, *) {
          accessGranted = try await self.eventStore?.requestWriteOnlyAccessToEvents()
        } else {
          accessGranted = try await self.eventStore?.requestAccess(to: .event)
        }
        guard accessGranted ?? false else {
          showingCalendarErrorAlert = true
          return
        }
      } catch {
        showingCalendarErrorAlert = true
        return
      }
    default:
      showingCalendarErrorAlert = true
      return
    }
    
    if let eventStore {
      let event = EKEvent(eventStore: eventStore)
      event.title = tournament.name
      event.location = locationString
      event.startDate = startDate
      event.endDate = endDate
      event.isAllDay = true
      event.calendar = eventStore.defaultCalendarForNewEvents
      self.event = event
    }
    
    showingAddToCalendarView = true
  }
  
  private func setCalendarEventDetails(_ tournamentDetails: TournamentDetails?) {
    startDate = tournamentDetails?.startDate
    endDate = tournamentDetails?.endDate
    
    guard let address = tournamentDetails?.location?.address, !address.isEmpty else {
      locationString = "Online"
      return
    }
    locationString = address
  }
  
  // MARK: Share
  
  private func setTournamentURL(_ slug: String?) {
    guard let slug, let url = URL(string: "https://www.start.gg/\(slug)/details") else { return }
    tournamentURL = url
  }
}
