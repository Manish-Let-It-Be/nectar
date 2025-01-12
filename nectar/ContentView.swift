//
//  ContentView.swift
//  nectar
//
//  Created by Abhijeet Rai on 11/01/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some View {
        NavigationView {
            Group {
                if authViewModel.isAuthenticated {
                    MainTabView()
                } else if !hasSeenWelcome {
                    WelcomeView()
                        .onDisappear {
                            hasSeenWelcome = true
                        }
                } else {
                    SignInView()
                }
            }
            .navigationTitle("Nectar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isDarkMode.toggle()
                    }) {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(.green)
                    }
                    .accessibilityLabel("Toggle Dark Mode")
                }
            }
        }
        .onAppear {
            // Check for existing login session
            authViewModel.checkAuth()
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.green]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.green]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(CartManager())
        .environmentObject(CheckoutViewModel())
        .environmentObject(FavoritesManager())
        .environmentObject(DeliveryAddressViewModel.shared)
        .environmentObject(OrderService())
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
