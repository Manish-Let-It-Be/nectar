import SwiftUI

struct CheckoutOrderItemRow: View {
    let item: CartItem
    
    var body: some View {
        HStack {
            Image(item.product.image)
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.custom("Gilroy-SemiBold", size: 16))
                Text("\(item.quantity)x • $\(item.product.price, specifier: "%.2f")")
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("$\(item.product.price * Double(item.quantity), specifier: "%.2f")")
                .font(.custom("Gilroy-Bold", size: 16))
                .foregroundColor(.green)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    CheckoutOrderItemRow(item: CartItem(
        product: ProductModel(
            id: "1",
            name: "Sample Product",
            description: "Sample description",
            price: 9.99,
            image: "apple",
            unit: "1kg",
            category: .fruits,
            isFavorite: false
        ),
        quantity: 2
    ))
} 