//
//  ContentView.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 23.11.24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var loggedIn = true
    
    var body: some View {
            VStack {
                if loggedIn {
                    Map()
                } else {
                    FeedView(loggedIn: $loggedIn)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //.background(Color("Background"))
            .sheet(isPresented: $loggedIn) {
                if loggedIn {
                    SheetNavigator(isPresented: $loggedIn)
                        .onDisappear {
                            self.loggedIn = false
                        }
                } else {
                    
                }
                
            }
        
       
    }
}

struct SheetNavigator: View {
    @Binding var isPresented: Bool
    @State private var currentView: SheetView = .basicDataInput
    
    enum SheetView {
        case basicDataInput
        case interestSelection
    }
    
    var body: some View {
        NavigationStack {
            switch currentView {
            case .basicDataInput:
                BasicDataInput(currentView: $currentView)
                   // .background(Color("Background").ignoresSafeArea())

            case .interestSelection:
                InterestSelection(isPresented: $isPresented)
                    //.background(Color("Background").ignoresSafeArea())

            }

        }

    }
}

#Preview {
    ContentView()
}
