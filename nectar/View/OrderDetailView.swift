import SwiftUI

struct OrderDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let order: Order
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Order Status
                    OrderStatusSection(status: order.status)
                    
                    // Delivery Info
                    DeliveryInfoSection(
                        address: order.deliveryAddress,
                        deliveryTime: order.deliveryTime
                    )

                    
                    // Order Items
                    OrderItemsSection(items: order.items)
                    
                    // Payment Details
                    PaymentDetailsSection(
                        order: order,
                        paymentMethod: order.paymentMethod
                    )
                }
                .padding()
            }
            .navigationTitle("Order Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct OrderStatusSection: View {
    let status: Order.OrderStatus
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Status")
                .font(.custom("Gilroy-Bold", size: 18))
            
            HStack(spacing: 16) {
                Circle()
                    .fill(status.color)
                    .frame(width: 12, height: 12)
                
                Text(status.rawValue)
                    .font(.custom("Gilroy-SemiBold", size: 16))
                    .foregroundColor(status.color)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

struct DeliveryInfoSection: View {
    let address: OrderDeliveryAddress
    let deliveryTime: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Delivery Information")
                .font(.custom("Gilroy-Bold", size: 18))
            
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.green)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(address.name)
                            .font(.custom("Gilroy-SemiBold", size: 16))
                        Text(address.phoneNumber)
                            .font(.custom("Gilroy-Medium", size: 14))
                            .foregroundColor(.gray)
                        Text(address.formattedAddress)
                            .font(.custom("Gilroy-Medium", size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.green)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Delivery Time")
                            .font(.custom("Gilroy-SemiBold", size: 16))
                        Text(deliveryTime.formatted(date: .abbreviated, time: .shortened))
                            .font(.custom("Gilroy-Medium", size: 14))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

struct OrderItemsSection: View {
    let items: [OrderItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Items")
                .font(.custom("Gilroy-Bold", size: 18))
            
            VStack(spacing: 16) {
                ForEach(items) { item in
                    OrderItemRow(item: item)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

struct OrderItemRow: View {
    let item: OrderItem
    
    var body: some View {
        HStack(spacing: 12) {
            Image(item.product.image)
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.custom("Gilroy-SemiBold", size: 16))
                
                Text("\(item.quantity)x • $\(item.price, specifier: "%.2f")")
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("$\(item.total, specifier: "%.2f")")
                .font(.custom("Gilroy-Bold", size: 16))
                .foregroundColor(.green)
        }
    }
}

struct PaymentDetailsSection: View {
    let order: Order
    let paymentMethod: OrderPaymentMethod
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment Details")
                .font(.custom("Gilroy-Bold", size: 18))
            
            VStack(spacing: 16) {
                // Payment Method
                HStack {
                    Image(paymentMethod.type.imageName)
                        .resizable()
                        .frame(width: 32, height: 32)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(paymentMethod.type.rawValue)
                            .font(.custom("Gilroy-SemiBold", size: 16))
                        Text("•••• \(paymentMethod.lastFourDigits)")
                            .font(.custom("Gilroy-Medium", size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                
                Divider()
                
                // Price Summary
                VStack(spacing: 8) {
                    PriceSummaryRow(title: "Subtotal", amount: order.totalAmount)
                    PriceSummaryRow(title: "Delivery Fee", amount: 2.99)
                    if let promoDiscount = order.promoDiscount {
                        PriceSummaryRow(title: "Promo Discount", amount: -promoDiscount)
                    }
                    Divider()
                    PriceSummaryRow(
                        title: "Total",
                        amount: order.totalAmount + 2.99 - (order.promoDiscount ?? 0),
                        isTotal: true
                    )
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
} 