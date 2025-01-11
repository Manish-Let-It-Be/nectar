//
//  ContentView.swift
//  nectar
//
//  Created by Abhijeet Rai on 11/01/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var cartManager = CartManager()
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var productService = ProductService()
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    
    var body: some View {
        if !hasSeenWelcome {
            WelcomeView()
                .onDisappear {
                    hasSeenWelcome = true
                }
        } else if authViewModel.isAuthenticated {
            MainTabView()
                .environmentObject(authViewModel)
                .environmentObject(cartManager)
                .environmentObject(favoritesManager)
                .environmentObject(productService)
        } else {
            SignInView()
                .environmentObject(authViewModel)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
