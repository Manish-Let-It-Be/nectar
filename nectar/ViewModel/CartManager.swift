import Foundation
import Combine

class CartManager: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var subtotal: Double = 0
    @Published var deliveryFee: Double = 2.99
    @Published var total: Double = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Observe changes to items and update totals
        $items
            .sink { [weak self] items in
                self?.updateTotals(items: items)
            }
            .store(in: &cancellables)
    }
    
    func addToCart(_ product: ProductModel, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += quantity
        } else {
            items.append(CartItem(product: product, quantity: quantity))
        }
    }
    
    func removeFromCart(_ product: ProductModel) {
        items.removeAll { $0.product.id == product.id }
    }
    
    func updateQuantity(for product: ProductModel, to quantity: Int) {
        guard quantity > 0 else {
            removeFromCart(product)
            return
        }
        
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity = quantity
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
    
    private func updateTotals(items: [CartItem]) {
        subtotal = items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
        total = subtotal + deliveryFee
    }
}

struct CartItem: Identifiable {
    let id = UUID()
    let product: ProductModel
    var quantity: Int
    
    var total: Double {
        product.price * Double(quantity)
    }
}

struct Product: Identifiable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let image: String
    let unit: String
    let category: Category
    var isFavorite: Bool
    
    enum Category: String, CaseIterable {
        case fruits = "Fresh Fruits"
        case vegetables = "Vegetables"
        case meat = "Meat & Fish"
        case dairy = "Dairy & Eggs"
        case beverages = "Beverages"
        case snacks = "Bakery & Snacks"
    }
} 