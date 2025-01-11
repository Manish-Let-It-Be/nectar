import SwiftUI

struct CheckoutView: View {
    @ObservedObject var cartManager: CartManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showAddressList = false
    @State private var showPaymentMethodList = false
    @State private var selectedAddress: OrderDeliveryAddress?
    @State private var selectedPaymentMethod: OrderPaymentMethod?
    @State private var isProcessing = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Order Items
                    ForEach(cartManager.items) { item in
                        CheckoutOrderItemRow(item: item)
                    }
                    
                    // Order Summary
                    VStack(spacing: 12) {
                        PriceSummaryRow(title: "Subtotal", amount: cartManager.subtotal)
                        PriceSummaryRow(title: "Delivery Fee", amount: cartManager.deliveryFee)
                        Divider()
                        PriceSummaryRow(title: "Total", amount: cartManager.total, isTotal: true)
                    }
                    
                    // Place Order Button
                    Button(action: placeOrder) {
                        if isProcessing {
                            ProgressView()
                        } else {
                            Text("Place Order • $\(cartManager.total, specifier: "%.2f")")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(isProcessing)
                }
                .padding()
            }
            .navigationTitle("Checkout")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func placeOrder() {
        isProcessing = true
        // Simulate order placement
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            cartManager.clearCart()
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Gilroy-Bold", size: 18))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
} 