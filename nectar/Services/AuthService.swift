import Foundation
import Combine

enum AuthError: Error {
    case invalidCredentials
    case networkError
    case unknown
    
    var message: String {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError:
            return "Network error. Please try again"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

protocol AuthServiceProtocol {
    func signIn(email: String, password: String) -> AnyPublisher<User, AuthError>
    func signUp(name: String, email: String, password: String) -> AnyPublisher<User, AuthError>
    func signOut() -> AnyPublisher<Void, AuthError>
}

class AuthService: AuthServiceProtocol {
    private let baseURL = "https://yourapi.com/api" // Here actual API base URL will be placed
    
    func signIn(email: String, password: String) -> AnyPublisher<User, AuthError> {
        guard let url = URL(string: "\(baseURL)/login") else {
            return Fail(error: AuthError.networkError).eraseToAnyPublisher()
        }
        
        let body: [String: Any] = ["email": email, "password": password]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: User.self, decoder: JSONDecoder())
            .mapError { error in
                if let urlError = error as? URLError {
                    return .networkError
                } else {
                    return .invalidCredentials
                }
            }
            .eraseToAnyPublisher()
    }
    
    func signUp(name: String, email: String, password: String) -> AnyPublisher<User, AuthError> {
        guard let url = URL(string: "\(baseURL)/register") else {
            return Fail(error: AuthError.networkError).eraseToAnyPublisher()
        }
        
        let body: [String: Any] = ["name": name, "email": email, "password": password]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: User.self, decoder: JSONDecoder())
            .mapError { error in
                if let urlError = error as? URLError {
                    return .networkError
                } else {
                    return .unknown
                }
            }
            .eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Void, AuthError> {
        // Implement actual sign out logic if needed
        return Future<Void, AuthError> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
} 