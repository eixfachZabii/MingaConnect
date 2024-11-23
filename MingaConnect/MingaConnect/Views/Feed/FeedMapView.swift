//
//  FeedView.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 23.11.24.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    
}

struct FeedMapView: View {
    @Binding var events: [Event]
    @Binding var coordinates: [[Double]]
    @State private var position: MapCameraPosition = .automatic
    var test = false

    var body: some View {
        VStack {
            Map(position: $position) {
                ForEach(events.indices, id: \.self) { eventIndex in
                    let event = events[eventIndex]
                    ForEach(event.location.indices, id: \.self) { locationIndex in
                        let latitude = event.location[locationIndex][0]
                        let longitude = event.location[locationIndex][1]
                        
                            Annotation("Spot \(eventIndex)-\(locationIndex)", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(mapToColor(type: event.interests[0]))
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.secondary, lineWidth: 2)
                                    Image(systemName: mapToImage(type: event.interests[0]))
                                        .foregroundColor(.white)
                                        .padding(5)
                                }
                                .frame(width: 30, height: 30)
                            }
                        
                    }
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Background"))
    }
    private func mapToImage(type: String) -> String {
        if type == "Meet new people" {
            return "chair.lounge"
        } else if type == "Boulderin" {
            return "figure.climbing.circle.fill"
        } else {
            return "mappin.circle.fill"
        }
    }
    
    private func mapToColor(type: String) -> Color {
        if type == "Meet new people" {
            return .brown
        } else if type == "Boulderin" {
            return .green
        } else {
            return .red
        }
    }
}

/*#Preview {
 FeedMapView(events: .constant(Event.self))
 }*/
