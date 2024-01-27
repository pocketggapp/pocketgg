import SwiftUI
import CoreLocation

final class LocationPreferenceViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
  @AppStorage("locationEnabled") var locationEnabled: Bool = false
  @AppStorage("locationCoordinates") var locationCoordinates: String = ""
  @AppStorage("locationString") var locationString: String = ""
  @AppStorage("locationDistance") var locationDistance: String = ""
  @AppStorage("locationDistanceUnit") var locationDistanceUnit: String = "mi"
  
  @Published var gettingLocation = false
  @Published var usingLocation = false
  @Published var cityCountryString = ""
  @Published var distanceString = ""
  @Published var selectedDistanceUnit = ""
  
  @Published var showingAlert = false
  @Published var error: Error?
  
  private let manager = CLLocationManager()
  private var coordinatesString = ""
  let distanceUnits = ["mi", "km"]

  override init() {
    super.init()
    manager.delegate = self
    
    // Initialize published variables
    usingLocation = locationEnabled
    cityCountryString = locationString
    distanceString = locationDistance
    selectedDistanceUnit = locationDistanceUnit
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
      locationCoordinates = ""
      locationString = ""
      locationDistance = ""
      locationDistanceUnit = "mi"
    }
  }
  
  func getCurrentLocation() {
    switch manager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      gettingLocation = true
      manager.requestLocation()
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
}

// MARK: CLLocationManagerDelegate

extension LocationPreferenceViewModel {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard gettingLocation else { return }
    Task { @MainActor in
      cityCountryString = try await getLocationString(locations.first?.coordinate)
      gettingLocation = false
    }
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      manager.requestLocation()
    default: return
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    self.error = error
    showingAlert = true
  }
}
