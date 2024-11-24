//
//  FeedView.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 23.11.24.
//

import SwiftUI
import CoreLocation
import MapKit

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
    @State var user: User = User(id: "1", username: "testuser", profile_pic: "", interests: ["Hiking", "Meet new people", "Picnics", "Running"])

    var body: some View {
        VStack {
            // Map View at the top
            FeedMapView(events: $filteredEvents, coordinates: $coordinates, feedUpdated: $feedUpdated)
                .onAppear {
                    fetchEvents()
                    // Set default filters
                    selectedInterests = user.interests
                    radius = 10.0
                }
                .sheet(isPresented: $showingBottomSheet) {
                   // if loggedIn {
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
                    //}
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
       // .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.background(Color("Background"))
    }

    private func fetchEvents() {
       /* self.events = [
            Event(id: "event1", title: "Hiking Adventure", description: "Join us for a scenic hike in the Bavarian Alps.", event_date: "14.12.2024 - 09:00", location: [[48.1371, 11.5754]], host: "Anna Müller", interests: ["Hiking", "Picnics"]),
            Event(id: "event2", title: "Chess Tournament", description: "Show off your skills in our local chess tournament.", event_date: "16.12.2024 - 14:00", location: [[48.1351, 11.5820]], host: "Max Fischer", interests: ["Chess"]),
            Event(id: "event3", title: "Bouldering Session", description: "Enjoy an exciting indoor bouldering session for all levels.", event_date: "18.12.2024 - 18:00", location: [[48.1256, 11.5810]], host: "Lena Schmidt", interests: ["Bouldering", "Meet new people"]),
            Event(id: "event4", title: "Picnic in the Park", description: "Relax and socialize at our picnic in the Englischer Garten.", event_date: "20.12.2024 - 12:00", location: [[48.1600, 11.5900]], host: "Sarah Becker", interests: ["Picnics", "Meet new people"]),
            Event(id: "event5", title: "Museum Tour", description: "Discover art and history on a guided tour of Munich's museums.", event_date: "22.12.2024 - 10:00", location: [[48.1480, 11.5690]], host: "Thomas Braun", interests: ["Museums"]),
            Event(id: "event6", title: "Board Game Night", description: "Bring your favorite board game and join us for an evening of fun.", event_date: "23.12.2024 - 19:00", location: [[48.1310, 11.5530]], host: "Sophia Weber", interests: ["Board Games", "Meet new people"]),
            Event(id: "event7", title: "Running Club", description: "Meet us for a morning run around the Isar River.", event_date: "24.12.2024 - 08:00", location: [[48.1220, 11.5910]], host: "Michael Lang", interests: ["Running"]),
            Event(id: "event8", title: "Pub Crawl", description: "Explore Munich's nightlife with a guided pub crawl.", event_date: "25.12.2024 - 20:00", location: [[48.1386, 11.5742]], host: "Daniel Wolf", interests: ["Pub Crawls", "Meet new people"]),
            Event(id: "event9", title: "Boat Trip", description: "Join us for a relaxing boat trip on Lake Starnberg.", event_date: "26.12.2024 - 15:00", location: [[48.0022, 11.3533]], host: "Laura Klein", interests: ["Boat", "Picnics"]),
            Event(id: "event10", title: "Nature Hike", description: "Explore the scenic trails of the Bavarian Forest.", event_date: "28.12.2024 - 10:00", location: [[48.1100, 11.6200]], host: "Sebastian Wagner", interests: ["Hiking", "Running"])
        ]*/
        APIService.shared.getEvents { result in
            switch result {
            case .success(let fetchedEvents):
                DispatchQueue.main.async {
                    self.events = Array(fetchedEvents.values)
                    self.filteredEvents = self.events

                }
            case .failure(let error):
                print("Failed to fetch events: \(error.localizedDescription)")
            }
        }
    }

    private func applyFilters() {
        var filtered = events

        APIService.shared.getFilteredEvents(filterInterests: selectedInterests) { result in
            switch result {
            case .success(let fetchedEvents):
                DispatchQueue.main.async {
                    self.events = Array(fetchedEvents.values)
                    self.filteredEvents = self.events

                }
            case .failure(let error):
                print("Failed to fetch events: \(error.localizedDescription)")
            }
        }
        // Filter by selected interests
        /*if !selectedInterests.isEmpty {
            filtered = filtered.filter { event in
                !Set(event.interests).isDisjoint(with: selectedInterests)
            }
        }*/

        // Filter by date range
        /*if let startDate = dateRange.startDate, let endDate = dateRange.endDate {
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
                let eventLatitude = event.location[0]
                let eventLongitude = event.location[1]
                let eventLocation = CLLocation(latitude: eventLatitude, longitude: eventLongitude)
                let userLoc = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                let distance = userLoc.distance(from: eventLocation) / 1000.0 // in km
                return distance <= radius
            }
        }*/

        self.filteredEvents = filtered
        self.coordinates = extractLocations(from: self.filteredEvents)
    }

    func extractLocations(from events: [Event]) -> [[Double]] {
        return events.map { $0.location }
    }
}

struct DateRange: Equatable {
    var startDate: Date?
    var endDate: Date?
}

// Include this for preview if needed
/*
#Preview {
    FeedView(loggedIn: .constant(true))
}
*/
