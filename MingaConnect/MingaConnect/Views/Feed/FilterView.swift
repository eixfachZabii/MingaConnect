import SwiftUI
import MapKit

struct MapLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct FilterView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedInterests: [String]
    @Binding var dateRange: DateRange
    @Binding var radius: Double
    var userInterests: [String]

    @State private var mapRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.1351, longitude: 11.5820), // Munich
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var mapLocations: [MapLocation] = [
        MapLocation(coordinate: CLLocationCoordinate2D(latitude: 48.1351, longitude: 11.5820))
    ]

    // Interests with icons and colors
    private let interestsWithIcons: [(interest: String, icon: String, color: Color)] = [
        ("Bouldering", "figure.climbing", Color(red: 34 / 255, green: 139 / 255, blue: 34 / 255)),
        ("Hiking", "figure.hiking", Color(red: 60 / 255, green: 179 / 255, blue: 113 / 255)),
        ("Pub Crawls", "wineglass.fill", Color(red: 128 / 255, green: 0 / 255, blue: 128 / 255)),
        ("Chess", "checkerboard.rectangle", Color(red: 105 / 255, green: 105 / 255, blue: 105 / 255)),
        ("Picnics", "basket.fill", Color(red: 255 / 255, green: 223 / 255, blue: 0 / 255)),
        ("Museums", "building.columns.fill", Color(red: 70 / 255, green: 130 / 255, blue: 180 / 255)),
        ("Boat", "sailboat.fill", Color(red: 0 / 255, green: 191 / 255, blue: 255 / 255)),
        ("Running", "figure.run", Color(red: 255 / 255, green: 165 / 255, blue: 0 / 255)),
        ("Board Games", "gamecontroller.fill", Color(red: 64 / 255, green: 224 / 255, blue: 208 / 255)),
        ("Meet new people", "person.3.fill", Color(red: 139 / 255, green: 69 / 255, blue: 19 / 255))
    ]

    // Computed properties for Date bindings
    var startDateBinding: Binding<Date> {
        Binding<Date>(
            get: { self.dateRange.startDate ?? Date() },
            set: { self.dateRange.startDate = $0 }
        )
    }

    var endDateBinding: Binding<Date> {
        Binding<Date>(
            get: { self.dateRange.endDate ?? Date() },
            set: { self.dateRange.endDate = $0 }
        )
    }

    var body: some View {
        NavigationView {
            Form {
                // Interests Section
                Section(header: Text("Interests")) {
                    ForEach(interestsWithIcons, id: \.interest) { item in
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(item.color)
                                    .frame(width: 30, height: 30)
                                Image(systemName: item.icon)
                                    .foregroundColor(.white)
                                    .font(.body)
                            }

                            Text(item.interest)
                                .foregroundColor(.primary)
                                .font(.body)

                            Spacer()

                            if selectedInterests.contains(item.interest) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .onTapGesture {
                            toggleInterest(item.interest)
                        }
                        .padding(.vertical, 4)
                    }
                }

                // Date Range Section
                Section(header: Text("Date Range")) {
                    DatePicker("Start Date", selection: startDateBinding, displayedComponents: .date)
                    DatePicker("End Date", selection: endDateBinding, displayedComponents: .date)
                }

                // Radius Section with Map
                Section(header: Text("Radius (km)")) {
                    VStack {
                        Slider(value: $radius, in: 1...100, step: 1, onEditingChanged: { _ in
                            updateMapRegion()
                        })
                        Text("\(Int(radius)) km")
                        
                        Map(coordinateRegion: $mapRegion, annotationItems: mapLocations) { location in
                            MapAnnotation(coordinate: location.coordinate) {
                                Circle()
                                    .stroke(Color.blue, lineWidth: 2)
                                    .frame(width: CGFloat(radius * 10), height: CGFloat(radius * 10))
                            }
                        }
                        .frame(height: 200)
                        .cornerRadius(10)
                    }
                }
            }
            .navigationBarTitle("Filter Events")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func toggleInterest(_ interest: String) {
        if selectedInterests.contains(interest) {
            selectedInterests.removeAll { $0 == interest }
        } else {
            selectedInterests.append(interest)
        }
    }

    private func updateMapRegion() {
        mapRegion.span = MKCoordinateSpan(latitudeDelta: radius / 50, longitudeDelta: radius / 50)
    }
}
