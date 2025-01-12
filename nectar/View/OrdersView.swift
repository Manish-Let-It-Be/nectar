import SwiftUI

struct OrdersView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            // Custom segmented control
            CustomSegmentedControl(
                selection: $selectedTab,
                options: ["Ongoing", "History"]
            )
            .padding()
            
            TabView(selection: $selectedTab) {
                OngoingOrdersView()
                    .tag(0)
                
                OrderHistoryView()
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
    var body: some View {
        ScrollView {
            if true { // Replace with actual data check
                EmptyOrdersView(message: "No ongoing orders")
            } else {
                // Show ongoing orders
            }
        }
    }
}

struct OrderHistoryView: View {
    var body: some View {
        ScrollView {
            if true { // Replace with actual data check
                EmptyOrdersView(message: "No order history")
            } else {
                // Show order history
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

#Preview {
    OrdersView()
        .environmentObject(AuthViewModel())
        .environmentObject(CartManager())
}
