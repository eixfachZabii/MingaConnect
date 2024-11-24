//
//  CreateEventView.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 23.11.24.
//
/*
import SwiftUI
import CoreLocation
import MapKit
import PhotosUI

struct CreateEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var feedUpdated: Bool
    @State private var title = ""
    @State private var description = ""
    @State private var host = ""
    @State private var address = ""
    @State private var coordinates: CLLocationCoordinate2D?
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    @State private var isMapPresented = false
    @State private var selectedDate = Date()
    
    // Interests Data
    @State private var interests = [
        "Bouldering", "Hiking", "Pub Crawls", "Chess", "Picnics",
        "Museums", "Boat", "Running", "Board Games", "Meet new people"
    ]
    @State private var selectedInterests: [String] = []
    @State private var isDropdownExpanded = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Event Details")) {
                        TextField("Title", text: $title)
                        TextField("Description", text: $description)
                        TextField("Host", text: $host)
                        
                        DatePicker("Event Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                    }
                    
                    Section(header: Text("Interests")) {
                        VStack(alignment: .leading, spacing: 8) {
                            // Dropdown Header
                            Button(action: {
                                withAnimation {
                                    isDropdownExpanded.toggle()
                                }
                            }) {
                                HStack {
                                    Text(selectedInterests.isEmpty ? "Select Interests" : selectedInterests.joined(separator: ", "))
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: isDropdownExpanded ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            }
                            
                            // Dropdown List
                            if isDropdownExpanded {
                                ScrollView {
                                    VStack(spacing: 0) {
                                        ForEach(interests, id: \.self) { interest in
                                            HStack {
                                                Text(interest)
                                                    .foregroundColor(.black)
                                                Spacer()
                                                if selectedInterests.contains(interest) {
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(.blue)
                                                }
                                            }
                                            .padding()
                                            .background(Color.white)
                                            .onTapGesture {
                                                toggleInterest(interest)
                                            }
                                            Divider() // Divider between items
                                        }
                                    }
                                }
                                .frame(maxHeight: 150) // Set dropdown height
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 4)
                            }
                            
                            // Display Selected Interests
                            if !selectedInterests.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Selected Interests:")
                                        .font(.subheadline)
                                        .padding(.top)
                                    
                                    ForEach(selectedInterests, id: \.self) { interest in
                                        HStack {
                                            Text(interest)
                                                .font(.body)
                                            Spacer()
                                            Button(action: {
                                                toggleInterest(interest)
                                            }) {
                                                Image(systemName: "xmark.circle")
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        .padding(.vertical, 4)
                                    }
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Event Location")) {
                        TextField("Search for an address", text: $address)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        MapViewRepresentable(region: .constant(MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: 48.1351, longitude: 11.5820), // Munich
                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                        )), selectedCoordinate: $coordinates)
                        .frame(height: 200)
                        .onTapGesture {
                            isMapPresented = true
                        }
                    }
                }
                
                Button(action: {
                    submitEvent()
                }) {
                    if isSubmitting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("Submit")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Create Event")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onDisappear {
            feedUpdated.toggle()
        }
    }
    
    // Toggle interest selection
    private func toggleInterest(_ interest: String) {
        if selectedInterests.contains(interest) {
            selectedInterests.removeAll { $0 == interest }
        } else {
            selectedInterests.append(interest)
        }
    }
    
    private func submitEvent() {
        guard !title.isEmpty, !description.isEmpty, !host.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        
        isSubmitting = true
        errorMessage = nil
        
        // Prepare event data
        let newEvent = Event(
            id: UUID().uuidString,
            title: title,
            description: description,
            event_date: formatDateToString(selectedDate),
            location: [[coordinates?.latitude ?? 0.0, coordinates?.longitude ?? 0.0]],
            host: host,
            interests: selectedInterests
        )
        
        APIService.shared.createEvent(event: newEvent) { result in
            DispatchQueue.main.async {
                isSubmitting = false
                switch result {
                case .success(let eventID):
                    print("Event created successfully with ID: \(eventID)")
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func formatDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
}
*/
