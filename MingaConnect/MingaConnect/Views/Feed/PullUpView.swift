//
//  PullUpView.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 23.11.24.
//

import SwiftUI

struct PullUpView: View {
    @State private var offsetY: CGFloat = 400 // Initial position
    @State private var isExpanded: Bool = false
    
    var body: some View {
        ZStack {
            // Map area (placeholder)
            FeedMapView()
            
            // Draggable Bottom Sheet
            GeometryReader { geometry in
                VStack {
                    // Drag handle
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 40, height: 5)
                        .padding(.top, 8)
                    
                    // Search and Explore Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("SUCHEN UND ERKUNDEN")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Picker(selection: .constant(0), label: Text("")) {
                            Text("Verbindungen").tag(0)
                            Text("Abfahrten").tag(1)
                            Text("Meldungen").tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        
                        VStack {
                            TextField("Aktueller Standort", text: .constant(""))
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                            
                            TextField("Ziel (Haltestelle, Adresse)", text: .constant(""))
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                            
                            Button(action: {}) {
                                Text("Und los")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
                    .background(Color(UIColor.systemGroupedBackground))
                    .cornerRadius(16)
                    
                    Spacer()
                }
                .frame(height: geometry.size.height)
                .background(Color.white)
                .cornerRadius(16)
                .offset(y: offsetY)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let newOffset = offsetY + value.translation.height
                            if newOffset > 100 && newOffset < geometry.size.height - 100 {
                                offsetY = newOffset
                            }
                        }
                        .onEnded { value in
                            withAnimation {
                                if value.translation.height > 50 {
                                    // Snap to bottom
                                    offsetY = geometry.size.height - 150
                                    isExpanded = false
                                } else if value.translation.height < -50 {
                                    // Snap to top
                                    offsetY = 100
                                    isExpanded = true
                                } else {
                                    // Snap to current state
                                    offsetY = isExpanded ? 100 : geometry.size.height - 150
                                }
                            }
                        }
                )
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct PullUpView_Previews: PreviewProvider {
    static var previews: some View {
        PullUpView()
    }
}
