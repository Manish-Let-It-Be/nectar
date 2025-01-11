import Foundation
import Combine

class OrderService: ObservableObject {
    @Published var orders: [Order] = []
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let ordersKey = "userOrders"
    
    init() {
        loadOrders()
    }
    
    func placeOrder(
        items: [CartItem],
        deliveryAddress: OrderDeliveryAddress,
        paymentMethod: OrderPaymentMethod,
        deliveryTime: Date,
        promoDiscount: Double? = nil
    ) -> AnyPublisher<Order, Error> {
        isLoading = true
        
        let orderItems = items.map { cartItem in
            OrderItem(
                id: UUID().uuidString,
                product: cartItem.product as! ProductModel,
                quantity: cartItem.quantity,
                price: cartItem.product.price
            )
        }
        
        let totalAmount = items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
        
        let order = Order(
            id: UUID().uuidString,
            userId: "current_user_id",
            items: orderItems,
            totalAmount: totalAmount,
            deliveryAddress: deliveryAddress,
            paymentMethod: paymentMethod,
            status: .pending,
            deliveryTime: deliveryTime,
            createdAt: Date(),
            promoDiscount: promoDiscount
        )
        
        // Simulate API call
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.orders.append(order)
                self.saveOrders()
                self.isLoading = false
                promise(.success(order))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func loadOrders() {
        if let data = userDefaults.data(forKey: ordersKey),
           let decodedOrders = try? JSONDecoder().decode([Order].self, from: data) {
            orders = decodedOrders
        }
    }
    
    private func saveOrders() {
        if let encoded = try? JSONEncoder().encode(orders) {
            userDefaults.set(encoded, forKey: ordersKey)
        }
    }
} 