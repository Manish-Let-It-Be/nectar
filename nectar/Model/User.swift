import Foundation

struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let phoneNumber: String?
    var deliveryAddresses: [DeliveryAddress]
    
    struct DeliveryAddress: Codable, Identifiable {
        let id: String
        let street: String
        let city: String
        let state: String
        let zipCode: String
        let isDefault: Bool
    }
} 