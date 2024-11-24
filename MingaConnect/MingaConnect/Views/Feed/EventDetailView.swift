//
//  EventDetailView.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 23.11.24.
//
import SwiftUI

struct EventDetailView: View {
    var event: Event
    @State private var isParticipating: Bool = false // Update based on user's participation status
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    @State private var participantCount: Int = 5 // Display the number of participants

    var body: some View {
        VStack(spacing: 0) {
            // Event image
            Image("EnglischerGarten") // Replace with your event's image or URL
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()

            // Event details
            VStack(alignment: .leading, spacing: 16) {
                // Title, Join Button, and Participant Count
                HStack {
                    Text(event.title)
                        .font(.title)
                        .fontWeight(.bold)

                    Spacer()

                    HStack {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.secondary)
                            Text("\(participantCount)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Button(action: {
                            toggleParticipation()
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

                // Date and Host
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

                // Tags/Interests
                HStack {
                    ForEach(event.interests, id: \.self) { interest in
                        Text(interest)
                            .padding(8)
                            .background(Capsule().fill(Color.blue.opacity(0.2)))
                    }
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top)
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
            // Check participation status
            isParticipating = checkIfUserIsParticipating(event: event)
            //participantCount = event.participantCount // Assume participantCount is part of Event
        }
    }

    private func toggleParticipation() {
        isSubmitting = true
        errorMessage = nil

        if isParticipating {
            // Leave event
            APIService.shared.leaveEvent(userID: "test", eventID: event.id) { result in
                DispatchQueue.main.async {
                    isSubmitting = false
                    switch result {
                    case .success:
                        isParticipating = false
                        participantCount -= 1 // Decrement participant count
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
        } else {
            // Join event
            APIService.shared.joinEvent(userID: "test", eventID: event.id) { result in
                DispatchQueue.main.async {
                    isSubmitting = false
                    switch result {
                    case .success:
                        isParticipating = true
                        participantCount += 1 // Increment participant count
                    case .failure(let error):
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
