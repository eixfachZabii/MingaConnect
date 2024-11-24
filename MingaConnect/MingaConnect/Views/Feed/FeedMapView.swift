import SwiftUI
import MapKit

struct FeedMapView: View {
    @Binding var events: [Event]
    @Binding var coordinates: [[Double]]
    @Binding var feedUpdated: Bool
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedEvent: Event?
    @State private var isDetailSheetPresented = false
    @StateObject private var locationManager = LocationManager()
    private var defaultZoomRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.1351, longitude: 11.5820),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    init(events: Binding<[Event]>, coordinates: Binding<[[Double]]>, feedUpdated: Binding<Bool>) {
        self._events = events
        self._coordinates = coordinates
        self._feedUpdated = feedUpdated
    }

    var body: some View {
        VStack {
            Map(position: $position) {
                if let userLocation = locationManager.userLocation {
                    // User Location Marker
                    Annotation("You", coordinate: userLocation) {
                        ZStack {
                            Circle().fill(Color.blue.opacity(0.3)).frame(width: 50, height: 50).blur(radius: 3)
                            Circle().fill(Color.blue).frame(width: 20, height: 20)
                            Circle().stroke(Color.white, lineWidth: 3).frame(width: 20, height: 20)
                        }
                    }
                }
                ForEach(events.indices, id: \.self) { eventIndex in
                    let event = events[eventIndex]
                    //ForEach(event.location.indices, id: \.self) { locationIndex in
                        let latitude = event.location/*[locationIndex]*/[0]
                        let longitude = event.location/*[locationIndex]*/[1]

                        Annotation("\(event.title)", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5).fill(mapToColor(type: event.interests[0]))
                                RoundedRectangle(cornerRadius: 5).stroke(.secondary, lineWidth: 2)
                                Image(systemName: mapToImage(type: event.interests[0])).foregroundColor(.white).padding(5)
                            }
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                selectedEvent = event
                                zoomToLocation(latitude: latitude, longitude: longitude)
                                isDetailSheetPresented = true
                            }
                        }
                    //}
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
        }
        //.frame(maxWidth: .infinity, maxHeight: .infinity)
        //.background(Color("Background"))
        .sheet(item: $selectedEvent, onDismiss: {
            zoomOut()
        }) { event in
            EventDetailView(event: event, feedUpdated: $feedUpdated)
                .presentationDetents([.medium, .large])
        }
    }

    private func mapToImage(type: String) -> String {
        switch type {
        case "Meet new people":
            return "chair.lounge.fill"
        case "Bouldering":
            return "figure.climbing"
        case "Hiking":
            return "figure.hiking"
        case "Pub Crawls":
            return "wineglass.fill"
        case "Chess":
            return "checkerboard.rectangle"
        case "Picnics":
            return "basket.fill"
        case "Museums":
            return "building.columns.fill"
        case "Boat":
            return "sailboat.fill"
        case "Running":
            return "figure.run"
        case "Board Games":
            return "gamecontroller.fill"
        default:
            return "mappin.circle.fill"
        }
    }

    private func mapToColor(type: String) -> Color {
        switch type {
        case "Meet new people":
            return Color(red: 139/255, green: 69/255, blue: 19/255) // Saddle Brown
        case "Bouldering":
            return Color(red: 34/255, green: 139/255, blue: 34/255) // Forest Green
        case "Hiking":
            return Color(red: 60/255, green: 179/255, blue: 113/255) // Medium Sea Green
        case "Pub Crawls":
            return Color(red: 128/255, green: 0/255, blue: 128/255) // Purple
        case "Chess":
            return Color(red: 105/255, green: 105/255, blue: 105/255) // Dim Gray
        case "Picnics":
            return Color(red: 255/255, green: 223/255, blue: 0/255) // Golden Yellow
        case "Museums":
            return Color(red: 70/255, green: 130/255, blue: 180/255) // Steel Blue
        case "Boat":
            return Color(red: 0/255, green: 191/255, blue: 255/255) // Deep Sky Blue
        case "Running":
            return Color(red: 255/255, green: 165/255, blue: 0/255) // Orange
        case "Board Games":
            return Color(red: 64/255, green: 224/255, blue: 208/255) // Turquoise
        default:
            return Color(red: 255/255, green: 0/255, blue: 0/255) // Red (default)
        }
    }

    private func zoomToLocation(latitude: Double, longitude: Double) {
        // Adjust zoom to ensure the pin is visible above the sheet
        let offsetLatitude = latitude - 0.005 // Offset to adjust for the detail sheet
        position = .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: offsetLatitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    private func zoomOut() {
        position = .region(defaultZoomRegion)
    }
}

// MARK: - Location Manager

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
