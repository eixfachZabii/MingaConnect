import SwiftUI
import MapKit

struct RadiusMapView: UIViewRepresentable {
    @Binding var radius: Double
    @StateObject private var locationManager = LocationManager()

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.delegate = context.coordinator

        if let userLocation = locationManager.userLocation {
            let region = MKCoordinateRegion(
                center: userLocation,
                latitudinalMeters: radius * 2000,
                longitudinalMeters: radius * 2000
            )
            mapView.setRegion(region, animated: false)
            let circle = MKCircle(center: userLocation, radius: radius * 1000)
            mapView.addOverlay(circle)
        }

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
        if let userLocation = locationManager.userLocation {
            let region = MKCoordinateRegion(
                center: userLocation,
                latitudinalMeters: radius * 2000,
                longitudinalMeters: radius * 2000
            )
            mapView.setRegion(region, animated: true)
            let circle = MKCircle(center: userLocation, radius: radius * 1000)
            mapView.addOverlay(circle)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let circleOverlay = overlay as? MKCircle {
                let circleRenderer = MKCircleRenderer(circle: circleOverlay)
                circleRenderer.strokeColor = .blue
                circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
                circleRenderer.lineWidth = 2
                return circleRenderer
            }
            return MKOverlayRenderer()
        }
    }
}
