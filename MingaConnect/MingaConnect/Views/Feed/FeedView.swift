
//  FeedView.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 23.11.24.
//

import SwiftUI
import CoreLocation

struct FeedView: View {
    @Binding var loggedIn: Bool
    @State private var showingBottomSheet = true
    @State private var events: [Event] = []
    @State private var filteredEvents: [Event] = []
    @State var coordinates: [[Double]] = []
    @State var feedUpdated: Bool = false
    @State var selectedInterests: [String] = []
    @State var dateRange = DateRange(startDate: nil, endDate: nil)
    @State var radius: Double = 10.0
    @StateObject private var locationManager = LocationManager()
    @State var user: User = User(id: "1", username: "testuser", profile_pic: "", interests: ["Hiking", "Meet new people", "Picnics"])

    var body: some View {
        VStack {
            FeedMapView(events: $filteredEvents, coordinates: $coordinates)
                .onAppear {
                    fetchEvents()
                    // Set default filters
                    selectedInterests = user.interests
                    radius = 10.0
                }
                .sheet(isPresented: $showingBottomSheet) {
                    if loggedIn {
                        FeedEventView(
                            feedUpdated: $feedUpdated,
                            selectedInterests: $selectedInterests,
                            dateRange: $dateRange,
                            radius: $radius,
                            userInterests: user.interests
                        )
                        .interactiveDismissDisabled()
                        .presentationDetents([.height(50), .medium, .large])
                        .presentationBackgroundInteraction(.enabled(upThrough: .large))
                    }
                }
        }
        .onChange(of: feedUpdated) { _ in
            fetchEvents()
        }
        .onChange(of: selectedInterests) { _ in
            applyFilters()
        }
        .onChange(of: dateRange) { _ in
            applyFilters()
        }
        .onChange(of: radius) { _ in
            applyFilters()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Background"))
    }

    private func fetchEvents() {
        APIService.shared.getEvents { result in
            switch result {
            case .success(let fetchedEvents):
                DispatchQueue.main.async {
                    self.events = Array(fetchedEvents.values)
                    self.applyFilters()
                }
            case .failure(let error):
                print("Failed to fetch events: \(error.localizedDescription)")
            }
        }
    }

    private func applyFilters() {
        var filtered = events

        // Filter by selected interests
        if !selectedInterests.isEmpty {
            filtered = filtered.filter { event in
                !Set(event.interests).isDisjoint(with: selectedInterests)
            }
        }

        // Filter by date range
        if let startDate = dateRange.startDate, let endDate = dateRange.endDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            filtered = filtered.filter { event in
                if let eventDate = formatter.date(from: event.event_date ?? "TBD") {
                    return eventDate >= startDate && eventDate <= endDate
                } else {
                    return false
                }
            }
        }

        // Filter by radius
        if let userLocation = locationManager.userLocation {
            filtered = filtered.filter { event in
                if let eventLatitude = event.location.first?[0],
                   let eventLongitude = event.location.first?[1] {
                    let eventLocation = CLLocation(latitude: eventLatitude, longitude: eventLongitude)
                    let userLoc = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                    let distance = userLoc.distance(from: eventLocation) / 1000.0 // in km
                    return distance <= radius
                } else {
                    return false
                }
            }
        }

        self.filteredEvents = filtered
        self.coordinates = extractLocations(from: self.filteredEvents)
    }

    func extractLocations(from events: [Event]) -> [[Double]] {
        var allLocations: [[Double]] = []
        for event in events {
            allLocations.append(contentsOf: event.location)
        }
        return allLocations
    }
}

struct DateRange: Equatable {
    var startDate: Date?
    var endDate: Date?
}

#Preview {
    FeedView(loggedIn: .constant(true))
}
