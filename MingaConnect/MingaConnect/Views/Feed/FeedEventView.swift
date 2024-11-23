//
//  FeedEventView.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 23.11.24.
//

import SwiftUI

struct FeedEventView: View {
    var body: some View {
        ScrollView {
            
            VStack {
                HStack {
                    Text("Feed")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color("AccentColor"))
                        .padding()
                    Spacer(minLength: 100)
                    Button(action: {
                        // Close the sheet
                    }) {
                        Text("Create Event")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.yellow)
                            .cornerRadius(10)
                            .foregroundColor( Color("Background"))
                    }
                    .padding()
                }
                Divider()
                
                    Text("Event 1")
                        .foregroundStyle(.white)
                    Text("Event 2")
                        .foregroundStyle(.white)
                    
                
            }
           
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Background"))
    }
}

#Preview {
    FeedEventView()
}
