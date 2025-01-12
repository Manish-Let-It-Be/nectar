import SwiftUI

struct OrdersView: View {
    @EnvironmentObject private var orderService: OrderService
    @Binding var selectedSegment: Int
    
    var body: some View {
        VStack {
            // Custom segmented control
            CustomSegmentedControl(
                selection: $selectedSegment,
                options: ["Ongoing", "History"]
            )
            .padding()
            
            TabView(selection: $selectedSegment) {
                OngoingOrdersView(orders: orderService.ongoingOrders)
                    .tag(0)
                
                OrderHistoryView(orders: orderService.orderHistory)
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationTitle("My Orders")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CustomSegmentedControl: View {
    @Binding var selection: Int
    let options: [String]
    
    var body: some View {
        HStack {
            ForEach(options.indices, id: \.self) { index in
                Button(action: { selection = index }) {
                    Text(options[index])
                        .font(.custom("Gilroy-SemiBold", size: 16))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(selection == index ? Color.green : Color.clear)
                        .foregroundColor(selection == index ? .white : .gray)
                        .cornerRadius(20)
                }
            }
        }
        .padding(4)
        .background(Color(.systemGray6))
        .cornerRadius(24)
    }
}

struct OngoingOrdersView: View {
    let orders: [Order]
    
    var body: some View {
        ScrollView {
            if orders.isEmpty {
                EmptyOrdersView(message: "No ongoing orders")
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(orders) { order in
                        OrderCard(order: order)
                    }
                }
                .padding()
            }
        }
    }
}

struct OrderHistoryView: View {
    let orders: [Order]
    
    var body: some View {
        ScrollView {
            if orders.isEmpty {
                EmptyOrdersView(message: "No order history")
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(orders) { order in
                        OrderCard(order: order)
                    }
                }
                .padding()
            }
        }
    }
}

struct EmptyOrdersView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bag")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text(message)
                .font(.custom("Gilroy-SemiBold", size: 18))
            
            Text("Items you order will appear here")
                .font(.custom("Gilroy-Medium", size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct OrderCard: View {
    let order: Order
    @State private var showOrderDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Order #\(order.id.prefix(8))")
                    .font(.custom("Gilroy-Bold", size: 16))
                
                Spacer()
                
                Text(order.status.rawValue)
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(order.status.color)
            }
            
            Divider()
            
            HStack {
                Text("\(order.items.count) items")
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("$\(order.totalAmount, specifier: "%.2f")")
                    .font(.custom("Gilroy-Bold", size: 16))
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onTapGesture {
            showOrderDetail = true
        }
        .sheet(isPresented: $showOrderDetail) {
            OrderDetailView(order: order)
        }
    }
}

#Preview {
    OrdersView(selectedSegment: .constant(0))
        .environmentObject(OrderService())
        .environmentObject(AuthViewModel())
        .environmentObject(CartManager())
}
