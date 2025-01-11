import SwiftUI

struct CartView: View {
    @State private var cartItems: [CartItem] = [
        CartItem(id: 1, name: "Organic Bananas", price: 4.99, quantity: 1, image: "banana"),
        CartItem(id: 2, name: "Red Apple", price: 3.99, quantity: 2, image: "apple")
    ]
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if cartItems.isEmpty {
                    EmptyCartView()
                } else {
                    List {
                        ForEach(cartItems) { item in
                            CartItemRow(item: item) { quantity in
                                updateQuantity(for: item, to: quantity)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    
                    Divider()
                    
                    // Checkout Button
                    VStack(spacing: 16) {
                        HStack {
                            Text("Total")
                                .font(.custom("Gilroy-SemiBold", size: 18))
                            Spacer()
                            Text("$\(totalPrice, specifier: "%.2f")")
                                .font(.custom("Gilroy-Bold", size: 20))
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal)
                        
                        Button(action: checkout) {
                            Text("Go to Checkout")
                                .font(.custom("Gilroy-SemiBold", size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle("My Cart")
        }
    }
    
    private func updateQuantity(for item: CartItem, to quantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].quantity = quantity
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        cartItems.remove(atOffsets: offsets)
    }
    
    private func checkout() {
        // Implement checkout logic
    }
}

struct CartItem: Identifiable {
    let id: Int
    let name: String
    let price: Double
    var quantity: Int
    let image: String
}

struct CartItemRow: View {
    let item: CartItem
    let onQuantityChange: (Int) -> Void
    
    var body: some View {
        HStack {
            Image(item.image)
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.custom("Gilroy-SemiBold", size: 16))
                Text("$\(item.price, specifier: "%.2f")")
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            Stepper(value: Binding(
                get: { item.quantity },
                set: { onQuantityChange($0) }
            ), in: 1...99) {
                Text("\(item.quantity)")
                    .font(.custom("Gilroy-Medium", size: 16))
            }
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