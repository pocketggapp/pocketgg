import SwiftUI
import MapKit

struct TournamentLocationView: View {
  private let location: Location
  private let coordinate: CLLocationCoordinate2D
  
  init(location: Location, latitude: Double, longitude: Double) {
    self.location = location
    self.coordinate = .init(latitude: latitude, longitude: longitude)
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Map(
        initialPosition: .camera(.init(centerCoordinate: coordinate, distance: 5000)),
        bounds: .init(centerCoordinateBounds: .init(center: coordinate, span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)), maximumDistance: 20000)
      ) {
        Marker(location.venueName ?? "", coordinate: coordinate)
      }
      .frame(height: 300)
      
      Text(location.venueName ?? "")
        .font(.body)
        .padding(.leading)
      
      Text(location.address ?? "")
        .font(.caption)
        .padding(.leading)
      
      Button {
        openInMaps()
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
  }
  
  // MARK: Open in Maps
  
  private func openInMaps() {
    let mapItem: MKMapItem = .init(placemark: .init(coordinate: coordinate))
    mapItem.name = location.address
    mapItem.openInMaps()
  }
}

#Preview {
  TournamentLocationView(
    location: Location(
      address: "600 Town Center Dr, Dearborn, MI 48126, USA",
      venueName: "Edward Hotel & Conference Center",
      latitude: 42.3122619,
      longitude: -83.2178603
    ),
    latitude: 42.3122619,
    longitude: -83.2178603
  )
}
