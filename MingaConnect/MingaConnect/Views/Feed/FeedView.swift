//
//  FeedView.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 23.11.24.
//

import SwiftUI

struct FeedView: View {
    @State private var showingBottomSheet = true

    var body: some View {
        VStack {
            FeedMapView()
                .sheet(isPresented: $showingBottomSheet) {
                    FeedEventView()
                            // 2.
                            .interactiveDismissDisabled()
                            // 3.
                            .presentationDetents([.height(50), .medium, .large])
                            // 4.
                            .presentationBackgroundInteraction(
                                .enabled(upThrough: .large)
                            )
                        }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Background"))
    }
}

#Preview {
    FeedView()
}
