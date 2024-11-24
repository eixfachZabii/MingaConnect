import SwiftUI
import MapKit

struct EventRowView: View {
    var event: Event
    @State private var address: String = "Loading..."
    //@State private var participantCount: Int = 5 // Replace with actual participant count
    @State private var isExpanded: Bool = false // Toggle to expand/collapse description
    @State private var isParticipating: Bool = false // Update based on user's participation status
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    @Binding var feedUpdated: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Event Image
            Image("EnglischerGarten") // Replace with actual event image
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .clipped()

            // Event Details
            VStack(alignment: .leading, spacing: 6) {
                // Event Title and Date
                HStack {
                    Text(event.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Spacer()

                    Text(event.event_date ?? "TBD")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                // Event Address
                Text(address)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)

                // Participant Count
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.secondary)
                    Text("\(event.participants.count) participants")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                // Event Description with "More" button
                if isExpanded {
                    HStack {
                        Text(event.description)
                            .font(.caption)
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }) {
                            Text("Less")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                } else {
                    Text(event.description)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }) {
                        Text("More")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }

                // Join/Leave Button
                HStack {
                    /*if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }*/

                    Spacer()

                    Button(action: {
                        toggleParticipation()
                        self.feedUpdated.toggle()

                    }) {
                        if isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text(isParticipating ? "Leave" : "Join")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                                .background(isParticipating ? Color.red : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .onAppear {
            // Fetch the address
            getAddressFromCoordinates(latitude: event.location[0], longitude: event.location[1])
            isParticipating = checkIfUserIsParticipating(event: event)
        }
    }
    
    private func getAddressFromCoordinates(latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                let street = placemark.thoroughfare ?? ""
                let city = placemark.locality ?? ""
                DispatchQueue.main.async {
                    self.address = "\(street), \(city)"
                }
            } else {
                DispatchQueue.main.async {
                    self.address = "Unknown location"
                }
            }
        }
    }

    private func toggleParticipation() {
        isSubmitting = true
        errorMessage = nil
       
        if isParticipating {
            // Leave event
            APIService.shared.leaveEvent(userID: "-1", eventID: event.id) { result in
                DispatchQueue.main.async {
                    isSubmitting = false
                    switch result {
                    case .success:
                        isParticipating = false

                        //participantCount -= 1 // Decrement participant count
                    case .failure(let error):
                        isParticipating = false

                        errorMessage = error.localizedDescription
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
                        isParticipating = true
                        //participantCount += 1 // Increment participant count
                    case .failure(let error):
                        isParticipating = true
                        errorMessage = error.localizedDescription
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
