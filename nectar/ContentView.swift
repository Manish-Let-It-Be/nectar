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
        }
        .onAppear {
            // Check for existing login session
            authViewModel.checkAuth()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
