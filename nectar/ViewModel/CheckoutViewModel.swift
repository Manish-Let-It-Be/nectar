import Foundation
import Combine

class CheckoutViewModel: ObservableObject {
    @Published var selectedAddress: OrderDeliveryAddress?
    @Published var selectedPaymentMethod: OrderPaymentMethod?
    @Published var promoCode = ""
    @Published var promoDiscount: Double = 0
    @Published var isProcessing = false
    // @Published var deliveryTimes: [DeliveryTime] = []
    // @Published var selectedDeliveryTime: DeliveryTime?
    @Published var alertItem: AlertItem?
    
    var canPlaceOrder: Bool {
        selectedAddress != nil && selectedPaymentMethod != nil
    }
    
    init() {
        loadDeliveryTimes()
    }
    
    func loadDeliveryTimes() {
        let calendar = Calendar.current
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        // deliveryTimes = (0...6).compactMap { offset in
        //     guard let date = calendar.date(byAdding: .hour, value: offset + 1, to: now) else { return nil }
        //     return DeliveryTime(
        //         day: dateFormatter.string(from: date),
        //         time: timeFormatter.string(from: date),
        //         date: date
        //     )
        // }
    }
    
    func applyPromoCode() {
        // Implement promo code logic
        if promoCode.lowercased() == "first" {
            promoDiscount = 10.0
        }
    }
    
    func placeOrder(items: [CartItem], total: Double) {
        guard canPlaceOrder else { return }
        isProcessing = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isProcessing = false
            self.alertItem = AlertItem(
                title: "Order Placed!",
                message: "Your order has been successfully placed.",
                isSuccess: true
            )
        }
    }
}

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let isSuccess: Bool
} 