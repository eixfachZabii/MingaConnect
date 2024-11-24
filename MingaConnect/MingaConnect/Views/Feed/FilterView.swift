//
//  FilterView.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 24.11.24.
//

import SwiftUI
import MapKit

struct FilterView: View {
    @Binding var selectedInterests: [String]
    @Binding var dateRange: DateRange
    @Binding var radius: Double
    var userInterests: [String]
    @Environment(\.presentationMode) var presentationMode

    @State private var tempSelectedInterests: [String] = []
    @State private var tempDateRange = DateRange(startDate: nil, endDate: nil)
    @State private var tempRadius: Double = 10.0

    @State private var defaultSelectedInterests: [String] = []
    @State private var defaultDateRange = DateRange(startDate: nil, endDate: nil)
    @State private var defaultRadius: Double = 10.0

    // Interests Data
    @State private var interests = [
        "Bouldering", "Hiking", "Pub Crawls", "Chess", "Picnics",
        "Museums", "Boat", "Running", "Board Games", "Meet new people"
    ]

    var sortedInterests: [String] {
        // Sort user's interests to the top
        let userInterestsSet = Set(userInterests)
        let sorted = interests.sorted {
            if userInterestsSet.contains($0) && !userInterestsSet.contains($1) {
                return true
            } else if !userInterestsSet.contains($0) && userInterestsSet.contains($1) {
                return false
            } else {
                return $0 < $1
            }
        }
        return sorted
    }

    var body: some View {
        NavigationView {
            Form {
                // Date Range Section
                Section(header: Text("Date Range")) {
                    DatePicker("Start Date", selection: Binding(
                        get: { tempDateRange.startDate ?? Date() },
                        set: { tempDateRange.startDate = $0 }
                    ), displayedComponents: [.date, .hourAndMinute])

                    DatePicker("End Date", selection: Binding(
                        get: { tempDateRange.endDate ?? Date().addingTimeInterval(86400) },
                        set: { tempDateRange.endDate = $0 }
                    ), displayedComponents: [.date, .hourAndMinute])
                }

                // Interests Section
                Section(header: Text("Interests")) {
                    ForEach(sortedInterests, id: \.self) { interest in
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5).fill(mapToColor(type: interest))
                                Image(systemName: mapToImage(type: interest))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 30, height: 30)
                            Text(interest)
                            Spacer()
                            if tempSelectedInterests.contains(interest) {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            toggleInterest(interest)
                        }
                    }
                }

                // Radius Section
                Section(header: Text("Radius (\(Int(tempRadius)) km)")) {
                    Slider(value: $tempRadius, in: 1...50, step: 1)
                    RadiusMapView(radius: $tempRadius)
                        .frame(height: 200)
                }
            }
            .navigationTitle("Filter Events")
            .navigationBarItems(
                leading: isFilterChanged() ? Button(action: {
                    tempSelectedInterests = defaultSelectedInterests
                    tempDateRange = defaultDateRange
                    tempRadius = defaultRadius
                }) {
                    Label("Clear", systemImage: "arrow.uturn.left")
                } : nil,
                trailing: Button(action: {
                    // Apply filters
                    selectedInterests = tempSelectedInterests
                    dateRange = tempDateRange
                    radius = tempRadius
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Label("Apply", systemImage: "checkmark")
                }
            )
            .onAppear {
                tempSelectedInterests = selectedInterests
                tempDateRange = dateRange
                tempRadius = radius
                // Capture default values
                defaultSelectedInterests = selectedInterests
                defaultDateRange = dateRange
                defaultRadius = radius
            }
        }
    }

    private func isFilterChanged() -> Bool {
        return tempSelectedInterests != defaultSelectedInterests ||
               tempDateRange != defaultDateRange ||
               tempRadius != defaultRadius
    }

    private func toggleInterest(_ interest: String) {
        if tempSelectedInterests.contains(interest) {
            tempSelectedInterests.removeAll { $0 == interest }
        } else {
            tempSelectedInterests.append(interest)
        }
    }

    private func mapToImage(type: String) -> String {
        switch type {
        case "Meet new people":
            return "person.3.fill"
        case "Bouldering":
            return "figure.climbing"
        case "Hiking":
            return "figure.hiking"
        case "Pub Crawls":
            return "wineglass.fill"
        case "Chess":
            return "checkerboard.rectangle"
        case "Picnics":
            return "basket.fill"
        case "Museums":
            return "building.columns.fill"
        case "Boat":
            return "sailboat.fill"
        case "Running":
            return "figure.run"
        case "Board Games":
            return "gamecontroller.fill"
        default:
            return "mappin.circle.fill"
        }
    }

    private func mapToColor(type: String) -> Color {
        switch type {
        case "Meet new people":
            return Color(red: 139/255, green: 69/255, blue: 19/255) // Saddle Brown
        case "Bouldering":
            return Color(red: 34/255, green: 139/255, blue: 34/255) // Forest Green
        case "Hiking":
            return Color(red: 60/255, green: 179/255, blue: 113/255) // Medium Sea Green
        case "Pub Crawls":
            return Color(red: 128/255, green: 0/255, blue: 128/255) // Purple
        case "Chess":
            return Color(red: 105/255, green: 105/255, blue: 105/255) // Dim Gray
        case "Picnics":
            return Color(red: 255/255, green: 223/255, blue: 0/255) // Golden Yellow
        case "Museums":
            return Color(red: 70/255, green: 130/255, blue: 180/255) // Steel Blue
        case "Boat":
            return Color(red: 0/255, green: 191/255, blue: 255/255) // Deep Sky Blue
        case "Running":
            return Color(red: 255/255, green: 165/255, blue: 0/255) // Orange
        case "Board Games":
            return Color(red: 64/255, green: 224/255, blue: 208/255) // Turquoise
        default:
            return Color(red: 255/255, green: 0/255, blue: 0/255) // Red (default)
        }
    }
}
