import SwiftUI
import MapKit

enum TournamentLocationViewState {
  case uninitialized
  case loading
  case loaded(UIImage?)
  case error(is503: Bool)
}

struct TournamentLocationView: View {
  @StateObject private var viewModel: TournamentLocationViewModel
  @State private var image: UIImage? = nil
  
  private let location: Location
  
  init(tournamentID: Int, location: Location) {
    self._viewModel = StateObject(wrappedValue: {
      TournamentLocationViewModel(
        tournamentID: tournamentID,
        location: location
      )
    }())
    self.location = location
  }
  
  var body: some View {
    switch viewModel.state {
    case .uninitialized, .loading:
      LocationPlaceholderView()
    case .loaded(let image):
      if let image {
        VStack(alignment: .leading) {
          Image(uiImage: image)
            .frame(height: 300)
          
          Text(location.venueName ?? "")
            .font(.body)
            .padding(.leading)
          
          Text(location.address ?? "")
            .font(.caption)
            .padding(.leading)
          
          Button {
            viewModel.openInMaps(location.address)
          } label: {
            HStack {
              Image(systemName: "location.fill")
              
              Text("Get Directions")
                .font(.body)
              
              Spacer()
            }
          }
          .padding([.top, .leading])
        }
      } else {
        EmptyStateView(
          systemImageName: "wifi",
          title: "Online",
          subtitle: "This tournament is being held online."
        )
      }
    case .error:
      EmptyStateView(
        systemImageName: "wifi",
        title: "Online",
        subtitle: "This tournament is being held online."
      )
    }
  }
}

#Preview {
  TournamentLocationView(
    tournamentID: 1906,
    location: Location(
      address: "600 Town Center Dr, Dearborn, MI 48126, USA",
      venueName: "Edward Hotel & Conference Center",
      latitude: 42.3122619,
      longitude: -83.2178603
    )
  )
}

final class TournamentLocationViewModel: ObservableObject {
  private let tournamentID: Int
  private let latitude: Double?
  private let longitude: Double?
  private var isPortrait: Bool {
    UIScreen.main.bounds.width < UIScreen.main.bounds.height
  }
  
  @Published var state: TournamentLocationViewState
  
  init(
    tournamentID: Int,
    location: Location
  ) {
    self.state = .uninitialized
    self.tournamentID = tournamentID
    self.latitude = location.latitude
    self.longitude = location.longitude
    
    Task {
      await getTournamentLocationSnapshot()
    }
  }
  
  // MARK: Get Tournament Location Snapshot
  
  @MainActor
  func getTournamentLocationSnapshot() async {
    state = .loading
    let imageKey = "mapPreview-\(tournamentID)-\(isPortrait ? "portrait" : "landscape")"
    if let image = ImageService.getCachedImage(with: imageKey) {
      state = .loaded(image)
      return
    }
    
    guard let latitude = latitude, let longitude = longitude else {
      state = .loaded(nil)
      return
    }
    
    let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    let options = MKMapSnapshotter.Options()
    options.region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
    options.size = CGSize(width: UIScreen.main.bounds.width, height: 300)
    
    do {
      let snapshotter = MKMapSnapshotter(options: options)
      let snapshot = try await snapshotter.start(with: DispatchQueue.global(qos: .userInitiated))
      let image = addPinToImage(size: options.size, snapshot: snapshot, coordinates: coordinates)
      ImageService.saveImageToCache(image: image, with: imageKey)
      state = .loaded(image)
    } catch {
      state = .error(is503: error.is503Error)
    }
  }
  
  private func addPinToImage(size: CGSize, snapshot: MKMapSnapshotter.Snapshot?, coordinates: CLLocationCoordinate2D) -> UIImage {
    return UIGraphicsImageRenderer(size: size).image { _ in
      snapshot?.image.draw(at: .zero)
      let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
      let pinImage = pinView.image
      
      if let point = snapshot?.point(for: coordinates) {
        let finalPoint = CGPoint(
          x: point.x + pinView.centerOffset.x - pinView.bounds.width / 2,
          y: point.y + pinView.centerOffset.y - pinView.bounds.height / 2
        )
        pinImage?.draw(at: finalPoint)
      }
    }
  }
  
  // MARK: Open in Maps
  
  func openInMaps(_ address: String?) {
    guard let latitude, let longitude else { return }
    
    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    let placemark = MKPlacemark(coordinate: coordinate)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = address
    mapItem.openInMaps()
  }
}
