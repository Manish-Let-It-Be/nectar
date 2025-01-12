//
//  nectarApp.swift
//  nectar
//
//  Created by Abhijeet Rai on 11/01/25.
//

import SwiftUI

@main
struct nectarApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var cartManager = CartManager()
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var orderService = OrderService()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(cartManager)
                .environmentObject(favoritesManager)
                .environmentObject(orderService)
        }
    }
}

