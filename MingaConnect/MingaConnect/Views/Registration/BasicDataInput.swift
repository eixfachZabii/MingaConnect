import SwiftUI

struct BasicDataInput: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var currentView: SheetNavigator.SheetView
    
    var body: some View {
        VStack(spacing: 30) {
            // Logo at the top
            Image("Logo")
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFit()
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.blue, lineWidth: 10)
                )
                .shadow(radius: 10)
            
            Spacer()
            
            // Input fields
            VStack(spacing: 16) {
                TextField("E-Mail", text: $email, prompt: Text("Enter your email"))
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .font(.headline)
                
                SecureField("Password", text: $password, prompt: Text("Enter your password"))
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .font(.headline)
            }
            
            Spacer()
            
            // Register button
            Button(action: {
                currentView = .interestSelection
            }) {
                Text("Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .font(.headline)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            
            // M-Login button
            VStack(spacing: 8) {
                Text("Already have an account?")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Button(action: {
                    // Handle M-Login action
                }) {
                    Text("M-Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray4))
                        .foregroundColor(.blue)
                        .cornerRadius(12)
                        .font(.headline)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
            
            Spacer()
            
            // Optional Terms and Privacy link
            Text("By registering, you agree to our Terms & Privacy Policy.")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("BrandAccent"), Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") {
                    // Close the sheet
                }
                .foregroundColor(Color("BrandPrimary"))
            }
        }
    }
}

#Preview {
    BasicDataInput(currentView: .constant(.basicDataInput))
}
