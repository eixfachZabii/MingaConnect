//
//  BasicDataInput.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 23.11.24.
//

import SwiftUI

struct BasicDataInput: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var currentView: SheetNavigator.SheetView
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            TextField("E-Mail", text: $email, prompt: Text("Enter your email").foregroundStyle(Color.white))
                .keyboardType(.emailAddress)
                .padding()
                .background(Color("Feature"))
                .foregroundStyle(Color.white)
                .cornerRadius(8)
                .font(.headline)
            
            SecureField("Password", text: $password, prompt: Text("Enter your password").foregroundStyle(Color.white))
                .foregroundStyle(Color.white)
                .padding()
                .background(Color("Feature"))
                .cornerRadius(8)
                .font(.headline)
            
            Spacer()
            
            Button(action: {
                // Navigate to InterestSelection view
                currentView = .interestSelection
            }) {
                Text("Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("Feature"))
                    .cornerRadius(8)
                    .font(.headline)
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") {
                    // Close the sheet
                }
                .foregroundStyle(Color.white)
            }
        }
    }
}

#Preview {
    BasicDataInput(currentView: .constant(.basicDataInput))
}
