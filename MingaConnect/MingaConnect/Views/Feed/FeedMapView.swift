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
    let coordinates: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 48.14006, longitude: 11.58733),
        CLLocationCoordinate2D(latitude: 48.13225, longitude: 11.56350),
        CLLocationCoordinate2D(latitude: 48.15072, longitude: 11.58080),
        CLLocationCoordinate2D(latitude: 48.17386, longitude: 11.57021),
        CLLocationCoordinate2D(latitude: 48.12016, longitude: 11.57733),
        CLLocationCoordinate2D(latitude: 48.12408, longitude: 11.53802),
        CLLocationCoordinate2D(latitude: 48.11289, longitude: 11.51766),
        CLLocationCoordinate2D(latitude: 48.13423, longitude: 11.53853),
        CLLocationCoordinate2D(latitude: 48.16026, longitude: 11.53297),
        CLLocationCoordinate2D(latitude: 48.17785, longitude: 11.50919),
        CLLocationCoordinate2D(latitude: 48.18562, longitude: 11.57003),
        CLLocationCoordinate2D(latitude: 48.17228, longitude: 11.59124),
        CLLocationCoordinate2D(latitude: 48.15557, longitude: 11.61987),
        CLLocationCoordinate2D(latitude: 48.12323, longitude: 11.61423),
        CLLocationCoordinate2D(latitude: 48.13262, longitude: 11.69051),
        CLLocationCoordinate2D(latitude: 48.10184, longitude: 11.64073),
        CLLocationCoordinate2D(latitude: 48.11326, longitude: 11.57708),
        CLLocationCoordinate2D(latitude: 48.10929, longitude: 11.57521),
        CLLocationCoordinate2D(latitude: 48.09836, longitude: 11.49860),
        CLLocationCoordinate2D(latitude: 48.11468, longitude: 11.47890),
        CLLocationCoordinate2D(latitude: 48.13985, longitude: 11.44696),
        CLLocationCoordinate2D(latitude: 48.18096, longitude: 11.40526),
        CLLocationCoordinate2D(latitude: 48.18359, longitude: 11.48688),
        CLLocationCoordinate2D(latitude: 48.21881, longitude: 11.55798),
        CLLocationCoordinate2D(latitude: 48.14016, longitude: 11.49617)
    ]
    
    @State private var position: MapCameraPosition = .automatic
    var body: some View {
        VStack {
            Map(position: $position) {
                ForEach(0..<coordinates.count) { index in
                    Annotation("Spot", coordinate: coordinates[index]) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.brown)
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.secondary, lineWidth: 5)
                            Image(systemName: "chair.lounge.fill")
                                .padding(5)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Background"))
    }
}

#Preview {
    FeedMapView()
}
