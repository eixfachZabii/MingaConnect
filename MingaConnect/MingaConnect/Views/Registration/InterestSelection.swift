import SwiftUI

struct InterestSelection: View {
    @Binding var isPresented: Bool
    @State private var selectedInterests: Set<String> = []
    let interests = ["Football", "Gym", "Cooking", "Travel", "Music", "Movies", "Reading", "Yoga", "Technology", "Fashion", "DIY Projects", "Animal Care", "Martial Arts"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Your Interests")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundStyle(Color("AccentColor"))
                .padding(.top, 20)
            
            // Profile Image
            Image("Profil") // Replace with your image asset name
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFit()
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color("Feature"), lineWidth: 10)
                )
                .shadow(radius: 10)
            
            ScrollView {
                FlowLayout(items: interests, spacing: 10) { interest in
                    Text(interest)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedInterests.contains(interest) ? Color.yellow : Color("Feature"))
                        .foregroundColor(.black)
                        .cornerRadius(20)
                        .onTapGesture {
                            toggleInterest(interest)
                        }
                        .animation(.easeInOut, value: selectedInterests)
                }
                .padding()
            }
            
            Spacer()
            
            Button(action: {
                // Close the sheet
                isPresented = false
            }) {
                Text("Continue")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedInterests.isEmpty ? Color.gray : Color.yellow)
                    .cornerRadius(10)
                    .foregroundColor(selectedInterests.isEmpty ? .white : Color("Background"))
            }
            .disabled(selectedInterests.isEmpty)
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(Color("Background").ignoresSafeArea())
    }
    
    private func toggleInterest(_ interest: String) {
        if selectedInterests.contains(interest) {
            selectedInterests.remove(interest)
        } else {
            selectedInterests.insert(interest)
        }
    }
}

#Preview {
    InterestSelection(isPresented: .constant(true))
}
