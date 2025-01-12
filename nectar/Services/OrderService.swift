import Foundation
import Combine

class OrderService: ObservableObject {
    @Published var orders: [Order] = []
    
    var ongoingOrders: [Order] {
        orders.filter { $0.status != .delivered && $0.status != .cancelled }
    }
    
    var orderHistory: [Order] {
        orders.filter { $0.status == .delivered || $0.status == .cancelled }
    }
    
    func addOrder(_ order: Order) {
        orders.append(order)
        objectWillChange.send()
    }
    
    func updateOrder(_ order: Order) {
        if let index = orders.firstIndex(where: { $0.id == order.id }) {
            orders[index] = order
            objectWillChange.send()
        }
    }
} 