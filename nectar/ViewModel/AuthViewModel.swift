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
        guard !email.isEmpty && !password.isEmpty else {
            showError = true
            errorMessage = "Please enter both email and password"
            return
        }
        
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            // For demo, accept any non-empty email/password
            self.isLoading = false
            self.isAuthenticated = true
            self.currentUser = UserModel(name: "John Doe", email: email)
            
            // In real app, you would validate credentials with your backend
            // If login fails:
            // self.showError = true
            // self.errorMessage = "Invalid credentials"
        }
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
    }
} 