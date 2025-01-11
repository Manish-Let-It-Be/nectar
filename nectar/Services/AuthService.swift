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
    func signIn(email: String, password: String) -> AnyPublisher<User, AuthError> {
        // TODO: Implement actual authentication logic
        // This is a mock implementation
        return Future<User, AuthError> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if email == "test@example.com" && password == "password" {
                    let user = User(
                        id: "1",
                        name: "Test User",
                        email: email,
                        phoneNumber: nil,
                        deliveryAddresses: []
                    )
                    promise(.success(user))
                } else {
                    promise(.failure(.invalidCredentials))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signUp(name: String, email: String, password: String) -> AnyPublisher<User, AuthError> {
        // TODO: Implement actual sign up logic
        return Future<User, AuthError> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let user = User(
                    id: UUID().uuidString,
                    name: name,
                    email: email,
                    phoneNumber: nil,
                    deliveryAddresses: []
                )
                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Void, AuthError> {
        // TODO: Implement actual sign out logic
        return Future<Void, AuthError> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
} 