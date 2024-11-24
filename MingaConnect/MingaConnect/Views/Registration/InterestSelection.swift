import SwiftUI

struct InterestSelection: View {
    @Binding var isPresented: Bool
    @State private var selectedInterests: Set<String> = []
    let interests = ["Bouldering", "Hiking", "Meet new people","Pub Crawls", "Chess", "Picnics", "Museums", "Boat", "Running", "Board Games"]
    
    var body: some View {
        VStack(spacing: 20) {
            
            
            // Profile Image
            Image("Logo") // Replace with your image asset name
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFit()
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.blue, lineWidth: 10)
                )
                .shadow(radius: 10)
                .padding(.top, 30)

            Text("Select Your Interests")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundStyle(.blue)
            ScrollView {
                FlowLayout(items: interests, spacing: 10) { interest in
                    Text(interest)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedInterests.contains(interest) ? Color.blue : Color.secondary)
                        .foregroundColor(selectedInterests.contains(interest) ? Color.white : Color.black)
                        .cornerRadius(20)
                        .onTapGesture {
                            toggleInterest(interest)
                        }
                        .animation(.easeInOut, value: selectedInterests)
                }
                //.padding()
            }
            
           // Spacer()
            
            Button(action: {
                // Close the sheet
                isPresented = false
            }) {
                Text("Continue")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedInterests.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(selectedInterests.isEmpty ? .black : Color.white)
            }
            .disabled(selectedInterests.isEmpty)
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
       // .background(Color("Background").ignoresSafeArea())
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
