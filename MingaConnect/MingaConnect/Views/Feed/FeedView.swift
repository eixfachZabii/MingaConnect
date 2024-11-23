//
//  FeedView.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 23.11.24.
//

import SwiftUI

struct FeedView: View {
    @Binding var loggedIn: Bool
    @State private var showingBottomSheet = true
    @State private var events: [Event] = []
    @State var coordinates: [[Double]] = []
    
    var body: some View {
        VStack {
            FeedMapView(events: $events, coordinates: $coordinates)
                .onAppear {
                    fetchEvents()
                }
                .sheet(isPresented: $showingBottomSheet) {
                    
                    if loggedIn {
                        FeedEventView()
                            .interactiveDismissDisabled()
                            .presentationDetents([.height(50), .medium, .large])
                            .presentationBackgroundInteraction(.enabled(upThrough: .large))
                    }
                }
            
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
                    print(self.events)
                    self.coordinates = extractLocations(from: self.events)
                }
            case .failure(let error):
                print("Failed to fetch events: \(error.localizedDescription)")
            }
        }
    }
    func extractLocations(from events: [Event]) -> [[Double]] {
        print("Start extraction")
        var allLocations: [[Double]] = []
        
        for event in events {
            allLocations.append(contentsOf: event.location)
        }
        
        return allLocations
    }
}



#Preview {
    FeedView(loggedIn: .constant(true))
}
