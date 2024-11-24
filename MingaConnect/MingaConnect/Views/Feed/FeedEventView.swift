import SwiftUI
import CoreLocation
import MapKit
import PhotosUI

import SwiftUI
import CoreLocation
import MapKit
import PhotosUI

struct FeedEventView: View {
    @State private var isPresentingCreateEventSheet = false
    @State private var isPresentingFilterSheet = false
    @Binding var feedUpdated: Bool
    @Binding var selectedInterests: [String]
    @Binding var dateRange: DateRange
    @Binding var radius: Double
    var userInterests: [String]
    
    @State private var events: [Event] = []
    @State private var filteredEvents: [Event] = []
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Explore")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding()
                    
                    Spacer(minLength: 50)
                    HStack(spacing: 10) {
                        // Filter Button
                        Button(action: {
                            isPresentingFilterSheet = true
                        }) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .foregroundStyle(.blue)
                                .font(.title)
                        }
                        .sheet(isPresented: $isPresentingFilterSheet) {
                            FilterView(
                                selectedInterests: $selectedInterests,
                                dateRange: $dateRange,
                                radius: $radius,
                                userInterests: userInterests
                            )
                        }
                        
                        // Create Event Button
                        Button(action: {
                            isPresentingCreateEventSheet = true
                        }) {
                            Image(systemName: "plus.app")
                                .foregroundStyle(.blue)
                                .font(.title)
                        }
                        .sheet(isPresented: $isPresentingCreateEventSheet) {
                            CreateEventView(feedUpdated: $feedUpdated)
                        }
                    }
                    .padding()
                }.padding(.top, 20)
                
                // Divider()
                
                List(filteredEvents) { event in
                    EventRowView(event: event, feedUpdated: $feedUpdated)
                        .listRowInsets(EdgeInsets())
                }
                .listStyle(.plain) // Use plain style for modern aesthetics
                .onAppear {
                    fetchEvents()
                    // Set default filters
                    selectedInterests = userInterests
                    radius = 10.0
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
            }
            //.navigationBarHidden(true)
        }
    }
    
    private func fetchEvents() {
        /*self.events = [
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
         ]
         self.filteredEvents = events*/
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
         }
         */
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
         if event.location.count == 2 {
         let eventLocation = CLLocation(latitude: event.location[0], longitude: event.location[1])
         let userLoc = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
         let distance = userLoc.distance(from: eventLocation) / 1000.0 // in km
         return distance <= radius
         } else {
         return false
         }
         }
         }*/
        
        self.filteredEvents = filtered
    }
}
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
            location: [coordinates?.latitude ?? 0.0, coordinates?.longitude ?? 0.0],
            host: host,
            participants: [],
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

import SwiftUI
import MapKit
import CoreLocation

struct MapViewRepresentable: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    
    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapViewRepresentable
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
            let location = gestureRecognizer.location(in: gestureRecognizer.view)
            if let mapView = gestureRecognizer.view as? MKMapView {
                let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
                parent.selectedCoordinate = coordinate
                parent.region.center = coordinate
                // Update annotations
                mapView.removeAnnotations(mapView.annotations)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let gestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = context.coordinator
        mapView.addGestureRecognizer(gestureRecognizer)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.region = region
        // Remove existing annotations
        uiView.removeAnnotations(uiView.annotations)
        // Add annotation if coordinate is selected
        if let coordinate = selectedCoordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            uiView.addAnnotation(annotation)
        }
    }
}

struct MapPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedCoordinates: CLLocationCoordinate2D?
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.1351, longitude: 11.5820), // Munich
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var pickedLocation: CLLocationCoordinate2D?
    @State private var searchQuery: String = ""
    @State private var isSearching = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search for an address", text: $searchQuery, onCommit: {
                        searchForAddress()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    
                    if isSearching {
                        ProgressView()
                            .padding(.trailing)
                    } else {
                        Button(action: {
                            searchForAddress()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .padding(.trailing)
                        }
                    }
                }
                .padding(.top)
                
                MapViewRepresentable(region: $region, selectedCoordinate: $pickedLocation)
                    .edgesIgnoringSafeArea(.all)
                
                Button(action: {
                    if let pickedLocation = pickedLocation {
                        selectedCoordinates = pickedLocation
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Confirm Location")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .navigationTitle("Pick a Location")
        }
    }
    
    private func searchForAddress() {
        guard !searchQuery.isEmpty else {
            errorMessage = "Please enter an address to search."
            return
        }
        
        isSearching = true
        errorMessage = nil
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchQuery) { placemarks, error in
            DispatchQueue.main.async {
                isSearching = false
                if let error = error {
                    errorMessage = "Search failed: \(error.localizedDescription)"
                    return
                }
                
                guard let placemark = placemarks?.first, let location = placemark.location else {
                    errorMessage = "No location found for the given address."
                    return
                }
                
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                pickedLocation = location.coordinate
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // We want images only
        configuration.selectionLimit = 1 // Allow only one selection
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // Do nothing
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            guard !results.isEmpty else {
                return
            }
            
            let itemProvider = results[0].itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.selectedImage = image
                        }
                    }
                }
            }
        }
    }
}

// Example Event struct and APIService for completeness

/*#Preview {
 FeedEventView(feedUpdated: .constant(true))
 }*/
