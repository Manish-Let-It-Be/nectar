import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isFirstLaunch = true
    @Published var currentUser: User?
    @Published var error: String?
    @Published var isLoading = false
    
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        
        // Check if first launch
        isFirstLaunch = UserDefaults.standard.bool(forKey: "hasLaunchedBefore") == false
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
        
        // Check for existing auth token/session
        checkAuthStatus()
    }
    
    private func checkAuthStatus() {
        // TODO: Implement check for existing auth token/session
    }
    
    func signIn(email: String, password: String) {
        isLoading = true
        error = nil
        
        authService.signIn(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.message
                }
            } receiveValue: { [weak self] user in
                self?.currentUser = user
                self?.isAuthenticated = true
            }
            .store(in: &cancellables)
    }
    
    func signUp(name: String, email: String, password: String) {
        isLoading = true
        error = nil
        
        authService.signUp(name: name, email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.message
                }
            } receiveValue: { [weak self] user in
                self?.currentUser = user
                self?.isAuthenticated = true
            }
            .store(in: &cancellables)
    }
    
    func signOut() {
        isLoading = true
        error = nil
        
        authService.signOut()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.message
                }
            } receiveValue: { [weak self] _ in
                self?.currentUser = nil
                self?.isAuthenticated = false
            }
            .store(in: &cancellables)
    }
} 