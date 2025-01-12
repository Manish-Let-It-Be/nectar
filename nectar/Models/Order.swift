import SwiftUI

struct Order: Identifiable, Codable {
    let id: String
    let userId: String
    let items: [OrderItem]
    let totalAmount: Double
    let deliveryAddress: OrderDeliveryAddress
    let paymentMethod: OrderPaymentMethod
    let status: OrderStatus
    let deliveryTime: Date
    let createdAt: Date
    let promoDiscount: Double?
    
    enum OrderStatus: String, Codable {
        case pending = "Pending"
        case confirmed = "Confirmed"
        case preparing = "Preparing"
        case outForDelivery = "Out for Delivery"
        case delivered = "Delivered"
        case cancelled = "Cancelled"
        
        var color: Color {
            switch self {
            case .pending: return .orange
            case .confirmed: return .blue
            case .preparing: return .yellow
            case .outForDelivery: return .purple
            case .delivered: return .green
            case .cancelled: return .red
            }
        }
    }
}

struct OrderItem: Identifiable, Codable {
    let id: String
    let product: ProductModel
    let quantity: Int
    let price: Double
    
    var total: Double {
        price * Double(quantity)
    }
}

struct OrderDeliveryAddress: Codable {
    static let `default` = OrderDeliveryAddress(
        id: "default",
        name: "Default Address",
        street: "123 Main St",
        city: "Anytown",
        state: "CA",
        zipCode: "12345",
        country: "USA",
        phoneNumber: "123-456-7890",
        formattedAddress: "123 Main St, Anytown, CA 12345, USA"
    )
    
    let id: String
    let name: String
    let street: String
    let city: String
    let state: String
    let zipCode: String
    let country: String
    let phoneNumber: String
    let formattedAddress: String
}

struct OrderPaymentMethod: Codable {
    static let `default` = OrderPaymentMethod(
        id: "default",
        type: .creditCard,
        lastFourDigits: "1234"
    )
    
    let id: String
    let type: PaymentType
    let lastFourDigits: String
    
    enum PaymentType: String, Codable {
        case creditCard = "Credit Card"
        case debitCard = "Debit Card"
        case applePay = "Apple Pay"
        case upi = "UPI"
        case cod = "Cash on Delivery"

        var imageName: String {
            switch self {
            case .creditCard: return "master"
            case .debitCard: return "master"
            case .applePay: return "apple_logo"
            case .upi: return "upi"
            case .cod: return "cod"
            }
        }
    }
} 