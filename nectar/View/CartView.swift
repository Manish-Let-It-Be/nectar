import SwiftUI

struct CartView: View {
    @StateObject private var cartManager = CartManager()
    @State private var showCheckout = false
    @State private var showEmptyAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if cartManager.items.isEmpty {
                    EmptyCartView()
                } else {
                    VStack(spacing: 20) {
                        // Cart Items
                        ForEach(cartManager.items) { item in
                            CartItemRow(item: item) { quantity in
                                cartManager.updateQuantity(for: item.product, to: quantity)
                            } onDelete: {
                                withAnimation {
                                    cartManager.removeFromCart(item.product)
                                }
                            }
                        }
                        
                        // Order Summary
                        VStack(spacing: 16) {
                            Text("Order Summary")
                                .font(.custom("Gilroy-Bold", size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 12) {
                                PriceSummaryRow(title: "Subtotal", amount: cartManager.subtotal)
                                PriceSummaryRow(title: "Delivery Fee", amount: cartManager.deliveryFee)
                                Divider()
                                PriceSummaryRow(title: "Total", amount: cartManager.total, isTotal: true)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        .padding()
                        
                        // Checkout Button
                        Button(action: {
                            if !cartManager.items.isEmpty {
                                showCheckout = true
                            } else {
                                showEmptyAlert = true
                            }
                        }) {
                            HStack {
                                Text("Proceed to Checkout")
                                    .font(.custom("Gilroy-SemiBold", size: 18))
                                Spacer()
                                Text("$\(cartManager.total, specifier: "%.2f")")
                                    .font(.custom("Gilroy-Bold", size: 18))
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("My Cart")
            .navigationBarItems(trailing: Button(action: {
                cartManager.clearCart()
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            })
            .sheet(isPresented: $showCheckout) {
                CheckoutView(cartManager: cartManager)
            }
            .alert(isPresented: $showEmptyAlert) {
                Alert(
                    title: Text("Empty Cart"),
                    message: Text("Please add items to your cart before proceeding to checkout."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct CartItemRow: View {
    let item: CartItem
    let onQuantityChange: (Int) -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Image(item.product.image)
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.custom("Gilroy-SemiBold", size: 16))
                
                Text(item.product.unit)
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.gray)
                
                Text("$\(item.product.price, specifier: "%.2f")")
                    .font(.custom("Gilroy-Bold", size: 16))
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                
                HStack {
                    Button(action: {
                        if item.quantity > 1 {
                            onQuantityChange(item.quantity - 1)
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.green)
                    }
                    
                    Text("\(item.quantity)")
                        .font(.custom("Gilroy-Medium", size: 16))
                        .frame(width: 30)
                    
                    Button(action: {
                        onQuantityChange(item.quantity + 1)
                    }) {
                        Image("add_to_cart")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct PriceSummaryRow: View {
    let title: String
    let amount: Double
    var isTotal: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom(isTotal ? "Gilroy-Bold" : "Gilroy-Medium", size: isTotal ? 18 : 16))
            Spacer()
            Text("$\(amount, specifier: "%.2f")")
                .font(.custom(isTotal ? "Gilroy-Bold" : "Gilroy-Medium", size: isTotal ? 18 : 16))
        }
    }
}

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("Your cart is empty")
                .font(.custom("Gilroy-SemiBold", size: 20))
            Text("Add items to start shopping")
                .font(.custom("Gilroy-Medium", size: 16))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    CartView()
        .environmentObject(AuthViewModel())
        .environmentObject(CartManager())
        .environmentObject(CheckoutViewModel())
} 