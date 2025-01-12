import SwiftUI
import CoreLocation

struct SelectLocationView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject private var locationService = LocationService()
    @State private var showLocationDeniedAlert = false
    @State private var navigateToSignIn = false
    
    var body: some View {
        VStack(spacing: 30) {
            Image("select_location")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
            
            Text("Select Your Location")
                .font(.custom("Gilroy-Bold", size: 26))
            
            Text("This will help us serve you better")
                .font(.custom("Gilroy-Medium", size: 16))
                .foregroundColor(.gray)
            
            if locationService.authorizationStatus == .authorizedWhenInUse {
                Text(locationService.locationString)
                    .font(.custom("Gilroy-SemiBold", size: 18))
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            Button(action: {
                switch locationService.authorizationStatus {
                case .notDetermined:
                    locationService.requestLocationPermission()
                case .authorizedWhenInUse, .authorizedAlways:
                    navigateToSignIn = true
                default:
                    showLocationDeniedAlert = true
                }
            }) {
                Text(locationService.authorizationStatus == .notDetermined ? "Enable Location Services" : "Continue")
                    .font(.custom("Gilroy-SemiBold", size: 18))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            NavigationLink(destination: SignInView(), isActive: $navigateToSignIn) {
                EmptyView()
            }
        }
        .padding()
        .alert(isPresented: $showLocationDeniedAlert) {
            Alert(
                title: Text("Location Access Required"),
                message: Text("Please enable location access in Settings to use this feature."),
                primaryButton: .default(Text("Open Settings")) {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    SelectLocationView()
        .environmentObject(AuthViewModel())
}
