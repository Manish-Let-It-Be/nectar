import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("welcom_bg")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    Image("color_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                    
                    VStack(spacing: 20) {
                        Text("Welcome to our store")
                            .font(.custom("Gilroy-Bold", size: 32))
                            .multilineTextAlignment(.center)
                        
                        Text("Get your groceries in as fast as one hour")
                            .font(.custom("Gilroy-Medium", size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: SignInView()) {
                        Text("Get Started")
                            .font(.custom("Gilroy-SemiBold", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 50)
            }
        }
        .navigationBarHidden(true)
    }
} 