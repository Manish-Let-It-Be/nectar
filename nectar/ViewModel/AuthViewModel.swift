import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var error: String?
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var currentUser: UserModel? = nil

    struct UserModel {
        let name: String
        let email: String
    }
    
    func signUp(username: String, email: String, phone: String, password: String) {
        isLoading = true
        // Implement actual sign up logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            self.isAuthenticated = true
        }
    }
    
    func signIn(email: String, password: String) {
        isLoading = true
        // Implement actual sign in logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            self.isAuthenticated = true
        }
    }
    
    func signOut() {
        isAuthenticated = false
    }
} 