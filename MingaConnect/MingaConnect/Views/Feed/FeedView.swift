//
//  FeedView.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 23.11.24.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let spot = CLLocationCoordinate2D(latitude: 48.14006, longitude: 11.58733)
    static let spot2 = CLLocationCoordinate2D(latitude: 48.13225, longitude: 11.5635)
}

struct FeedView: View {
    var body: some View {
        VStack {
            Map {
                Marker("Spot", coordinate: .spot)
                Marker("Spot", coordinate: .spot2)
            }
        }
    }
}

#Preview {
    FeedView()
}
