import SwiftUI

struct OrdersHistoryView: View {
    @StateObject private var orderService = OrderService()
    @State private var selectedOrder: Order?
    
    var body: some View {
        NavigationView {
            Group {
                if orderService.orders.isEmpty {
                    EmptyOrderHistoryView()
                } else {
                    List {
                        ForEach(orderService.orders.sorted(by: { $0.createdAt > $1.createdAt })) { order in
                            OrderHistoryCard(order: order)
                                .onTapGesture {
                                    selectedOrder = order
                                }
                        }
                    }
                }
            }
            .navigationTitle("Order History")
            .sheet(item: $selectedOrder) { order in
                OrderDetailView(order: order)
            }
        }
    }
}

struct OrderHistoryCard: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Order #\(order.id.prefix(8))")
                    .font(.custom("Gilroy-Bold", size: 16))
                
                Spacer()
                
                StatusBadge(status: order.status)
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(order.items.count) items")
                        .font(.custom("Gilroy-Medium", size: 14))
                        .foregroundColor(.gray)
                    
                    Text("$\(order.totalAmount, specifier: "%.2f")")
                        .font(.custom("Gilroy-Bold", size: 16))
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(order.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.custom("Gilroy-Medium", size: 14))
                        .foregroundColor(.gray)
                    
                    Text("Delivery: \(order.deliveryTime.formatted(date: .abbreviated, time: .shortened))")
                        .font(.custom("Gilroy-Medium", size: 14))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct StatusBadge: View {
    let status: Order.OrderStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.custom("Gilroy-Medium", size: 12))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color)
            .cornerRadius(4)
    }
}

struct EmptyOrderHistoryView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Orders Yet")
                .font(.custom("Gilroy-Bold", size: 20))
            
            Text("Your order history will appear here")
                .font(.custom("Gilroy-Medium", size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
} 