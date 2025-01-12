//
//  nectarApp.swift
//  nectar
//
//  Created by Abhijeet Rai on 11/01/25.
//

import SwiftUI
import UIKit

@main
struct nectarApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var cartManager = CartManager()
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var orderService = OrderService()
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @StateObject private var deliveryAddressViewModel = DeliveryAddressViewModel()
    @StateObject private var checkoutViewModel = CheckoutViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(cartManager)
                .environmentObject(favoritesManager)
                .environmentObject(checkoutViewModel)
                .environmentObject(orderService)
                .environmentObject(deliveryAddressViewModel)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
    
    init() {
        // Configure Navigation Bar Appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.green]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.green]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

