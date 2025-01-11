//
//  ContentView.swift
//  nectar
//
//  Created by Abhijeet Rai on 11/01/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        NavigationView {
            if authViewModel.isAuthenticated {
                MainTabView()
                    .environmentObject(authViewModel)
            } else {
                SignInView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
