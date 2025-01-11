import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var showSignIn = false
    
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
                        .frame(width: 48, height: 56)
                    
                    VStack(spacing: 20) {
                        Text("Welcome\nto our store")
                            .font(.custom("Gilroy-Bold", size: 48))
                            .multilineTextAlignment(.center)
                        
                        Text("Get your groceries in as fast as one hour")
                            .font(.custom("Gilroy-Medium", size: 16))
                            .foregroundColor(.gray)
                    }
                    
                    Button(action: {
                        showSignIn = true
                    }) {
                        Text("Get Started")
                            .font(.custom("Gilroy-SemiBold", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 90)
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showSignIn) {
                SignInView()
            }
        }
    }
} 