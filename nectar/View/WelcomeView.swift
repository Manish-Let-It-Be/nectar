import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var showSignIn = false
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    
    var body: some View {
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
                hasSeenWelcome = true
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
        .fullScreenCover(isPresented: $showSignIn) {
            SignInView()
        }
    }
} 

#Preview {
    WelcomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(CartManager())
        .environmentObject(CheckoutViewModel())
        .environmentObject(FavoritesManager())
        .environmentObject(HomeViewModel(productService: ProductService()))
        .environmentObject(ProductDetailViewModel(product: ProductModel(
            id: "",
            name: "",
            description: "",
            price: 0.0,
            image: "",
            unit: "",
            category: .fruits,
            isFavorite: false
        )))
}
