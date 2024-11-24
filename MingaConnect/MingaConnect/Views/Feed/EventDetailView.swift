//
//  EventDetailView.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 23.11.24.
//
import SwiftUI
import MapKit

struct EventDetailView: View {
    var event: Event
    @State private var isParticipating: Bool = false
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    @Binding var feedUpdated: Bool
    @State private var participantCount: Int = 10
    @State private var transitDuration: String = "Calculating..."
    
    @StateObject private var locationManager = LocationHelper()

    var body: some View {
        VStack(spacing: 0) {
            // Event image
            if event.title.contains("10k Run") {
                Image("Olympia")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
            } else if event.title.contains("Boulder Ei") {
                Image("Boulder_Ei")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
            } else if event.title.contains("Bouldering Basics") {
                Image("Bouldering_Basics")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
            } else if event.title.contains("Boulderwelt Ost") {
                Image("Boulderwelt_Ost")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
            } else if event.title.contains("Family Bouldering") {
                Image("Family_Bouldering")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
            }
            else {
                Image("EnglischerGarten")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
            }

            // Event details
            VStack(alignment: .leading, spacing: 16) {
                // Title, Join Button, and Participant Count
                HStack {
                    Text(event.title)
                        .font(.title)
                        .fontWeight(.bold)

                    Spacer()

                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.secondary)
                        if event.title.contains("10k Run") {
                            Text("\(participantCount)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } else {
                            Text("\(event.participants.count)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        
                        Button(action: {
                            if event.title.contains("10k Run") {
                                
                            } else {
                                toggleParticipation()
                                self.feedUpdated.toggle()
                            }
                           
                        }) {
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            } else {
                                Text(isParticipating ? "Leave" : "Join")
                                    .font(.headline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(isParticipating ? Color.red : Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }

                // Description
                Text(event.description)
                    .font(.body)
                    .foregroundColor(.secondary)

                // Date, Host, and Transit Duration
                HStack(spacing: 12) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("Date:").bold()
                            Text(event.event_date ?? "TBD")
                        }
                    }
                    .font(.subheadline)

                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("Host:").bold()
                            Text(event.host)
                        }
                    }
                    .font(.subheadline)
                }

                HStack {
                    Image(systemName: "bus.fill")
                        .foregroundColor(.blue)
                    Text("Transit Duration:").bold()
                    Text(transitDuration)
                        .foregroundColor(.secondary)
                }
                .font(.subheadline)

                // Tags/Interests
                HStack {
                    ForEach(event.interests, id: \.self) { interest in
                        Text(interest)
                            .padding(8)
                            .background(Capsule().fill(Color.blue.opacity(0.2)))
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("DetailBackground"))
                    .shadow(radius: 5)
            )
            .padding([.horizontal, .bottom])
        }
        .onAppear {
            isParticipating = checkIfUserIsParticipating(event: event)
            locationManager.requestUserLocation { location in
                fetchTransitDuration(from: location)
            }
        }
    }

    private func fetchTransitDuration(from userLocation: CLLocationCoordinate2D) {
        let eventLocation = CLLocationCoordinate2D(latitude: event.location[0], longitude: event.location[1])

        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let eventPlacemark = MKPlacemark(coordinate: eventLocation)

        let directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem(placemark: userPlacemark)
        directionsRequest.destination = MKMapItem(placemark: eventPlacemark)
        directionsRequest.transportType = .transit

        let directions = MKDirections(request: directionsRequest)

        directions.calculateETA { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.transitDuration = "Unavailable"
                    print("Error calculating transit duration: \(error.localizedDescription)")
                    return
                }

                if let response = response {
                    let travelTime = Int(response.expectedTravelTime / 60) // Convert seconds to minutes
                    self.transitDuration = "\(travelTime) min"
                } else {
                    self.transitDuration = "Unavailable"
                }
            }
        }
    }

    private func toggleParticipation() {
        if event.title.contains("10k Run") {
            self.isParticipating = true
            print(isParticipating)
            //self.participantCount += 1
            return
        }
        
            isSubmitting = true
            errorMessage = nil
            
            if isParticipating {
                // Leave event
                APIService.shared.leaveEvent(userID: "-1", eventID: event.id) { result in
                    DispatchQueue.main.async {
                        isSubmitting = false
                        switch result {
                        case .success:
                            self.isParticipating = false
                            //participantCount -= 1 // Decrement participant count
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                            self.isParticipating = false

                        }
                    }
                }
            } else {
                // Join event
                APIService.shared.joinEvent(userID: "-1", eventID: event.id) { result in
                    DispatchQueue.main.async {
                        isSubmitting = false
                        switch result {
                        case .success:
                            self.isParticipating = true
                            //participantCount += 1 // Increment participant count
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                            self.isParticipating = true

                        }
                    }
                }
            }
        }


    private func checkIfUserIsParticipating(event: Event) -> Bool {
            // Add logic to determine if the user is already participating
        return false // Replace with actual check
        }
}

class LocationHelper: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var completion: ((CLLocationCoordinate2D) -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestUserLocation(completion: @escaping (CLLocationCoordinate2D) -> Void) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        manager.stopUpdatingLocation() // Stop location updates after getting the location
        completion?(location.coordinate)
        completion = nil // Clear the completion handler to prevent reuse
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
