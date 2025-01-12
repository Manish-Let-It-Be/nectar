import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var currentUser: UserModel? = nil
    
    struct UserModel {
        let name: String
        let email: String
    }
    
    func signIn(email: String, password: String) {
        // Basic validation
        guard !email.isEmpty && !password.isEmpty else {
            showError = true
            errorMessage = "Please enter both email and password"
            return
        }
        
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            // For demo purposes, accept any valid email format
            if email.contains("@") && password.count >= 6 {
                self.isAuthenticated = true
                self.currentUser = UserModel(name: "John Doe", email: email)
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
            } else {
                self.showError = true
                self.errorMessage = "Invalid email or password"
            }
            
            self.isLoading = false
        }
    }
    
    func signUp(name: String, email: String, password: String) {
        // Basic validation
        guard !name.isEmpty else {
            showError = true
            errorMessage = "Please enter your name"
            return
        }
        
        guard !email.isEmpty && email.contains("@") else {
            showError = true
            errorMessage = "Please enter a valid email"
            return
        }
        
        guard password.count >= 6 else {
            showError = true
            errorMessage = "Password must be at least 6 characters"
            return
        }
        
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            self.isAuthenticated = true
            self.currentUser = UserModel(name: name, email: email)
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            self.isLoading = false
        }
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
    // Check for existing login session
    func checkAuth() {
        isAuthenticated = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
} 



