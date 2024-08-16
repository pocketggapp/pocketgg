import SwiftUI
import CoreLocation

final class LocationPreferenceViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
  /// Whether or not the user has enabled location preference
  @AppStorage(Constants.locationEnabled) var locationEnabled: Bool = false
  /// A string representation of the user's location in latitude and longitude (eg. "37.7873589, -122.408227")
  @AppStorage(Constants.locationCoordinates) var locationCoordinates: String = ""
  /// A string representing the city and country of the user's location (eg. "San Francisco, United States")
  @AppStorage(Constants.locationString) var locationString: String = ""
  /// A string representing a distance radius that tournaments should be found within (eg. "50")
  /// If empty, 50 should be used as a default value
  @AppStorage(Constants.locationDistance) var locationDistance: String = ""
  /// A string representing the distance unit ("mi" or "km")
  @AppStorage(Constants.locationDistanceUnit) var locationDistanceUnit: String = "mi"
  
  @Published var gettingLocation = false
  @Published var usingLocation = false
  @Published var cityCountryString = ""
  @Published var distanceString = ""
  @Published var selectedDistanceUnit = "mi"
  
  @Published var showingAlert = false
  @Published var showingLocationPermissionAlert = false
  @Published var error: Error?
  
  private var sentHomeViewRefreshNotification: Bool
  
  private let manager = CLLocationManager()
  private var coordinatesString = ""
  let distanceUnits = ["mi", "km"]

  override init() {
    self.sentHomeViewRefreshNotification = false
    
    super.init()
    manager.delegate = self
    
    // Initialize published variables
    self.usingLocation = locationEnabled
    self.coordinatesString = locationCoordinates
    self.cityCountryString = locationString
    self.distanceString = locationDistance
    self.selectedDistanceUnit = locationDistanceUnit
  }
  
  func onViewDisappear() {
    if usingLocation {
      locationEnabled = true
      locationCoordinates = coordinatesString
      locationString = cityCountryString
      locationDistance = distanceString
      locationDistanceUnit = selectedDistanceUnit
    } else {
      locationEnabled = false
    }
  }
  
  func resetHomeViewRefreshNotification() {
    sentHomeViewRefreshNotification = false
  }
  
  func getCurrentLocation() {
    gettingLocation = true
    
    switch manager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      manager.requestLocation()
    case .denied, .restricted:
      showingLocationPermissionAlert = true
      gettingLocation = false
    default:
      manager.requestWhenInUseAuthorization()
    }
  }
  
  private func getLocationString(_ coordinate: CLLocationCoordinate2D?) async throws -> String {
    guard let coordinate else { return "" }
    let placemarks = try await CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
    coordinatesString = "\(coordinate.latitude), \(coordinate.longitude)"
    
    guard let placemark = placemarks.first else { return "" }
    let city = placemark.locality
    let country = placemark.country
    
    if city == nil, let country { return country }
    if country == nil, let city { return city }
    guard let city, let country else { return "" }
    
    return city + ", " + country
  }
  
  func sendHomeViewRefreshNotification() {
    guard !sentHomeViewRefreshNotification else { return }
    NotificationCenter.default.post(name: Notification.Name(Constants.refreshHomeView), object: nil)
    sentHomeViewRefreshNotification = true
  }
}

// MARK: CLLocationManagerDelegate

extension LocationPreferenceViewModel {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard gettingLocation else { return }
    Task { @MainActor in
      cityCountryString = try await getLocationString(locations.first?.coordinate)
      gettingLocation = false
      
      sendHomeViewRefreshNotification()
    }
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    // Prevent location from being fetched when LocationPreferenceView is initialized
    guard gettingLocation else { return }
    
    switch manager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      manager.requestLocation()
    default:
      gettingLocation = false
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    self.error = error
    showingAlert = true
    gettingLocation = false
  }
}
