import SwiftUI

struct CheckoutView: View {
    @Binding var selectedTab: Int
    @ObservedObject var cartManager: CartManager
    @EnvironmentObject private var orderService: OrderService
    @Environment(\.presentationMode) var presentationMode
    @State private var showAddressList = false
    @State private var showPaymentMethodList = false
    @State private var selectedAddress: OrderDeliveryAddress?
    @State private var selectedPaymentMethod: OrderPaymentMethod?
    @State private var isProcessing = false
    @State private var showOrderSuccess = false
    @State private var checkoutStep = CheckoutStep.address
    @State private var navigateToOrders = false
    
    enum CheckoutStep {
        case address, payment, confirmation
        
        var title: String {
            switch self {
            case .address:
                return "Select Address"
            case .payment:
                return "Select Payment Method"
            case .confirmation:
                return "Order Confirmation"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                switch checkoutStep {
                case .address:
                    AddressSelectionView(
                        selectedAddress: $selectedAddress,
                        onNext: { checkoutStep = .payment }
                    )
                case .payment:
                    PaymentMethodView(
                        selectedPaymentMethod: $selectedPaymentMethod,
                        onNext: { checkoutStep = .confirmation }
                    )
                case .confirmation:
                    OrderConfirmationView(
                        cartManager: cartManager,
                        selectedAddress: selectedAddress!,
                        selectedPaymentMethod: selectedPaymentMethod!,
                        onPlaceOrder: placeOrder
                    )
                }
            }
            .navigationTitle(checkoutStep.title)
            .navigationBarItems(leading: Button("Back") {
                if checkoutStep == .payment {
                    checkoutStep = .address
                } else if checkoutStep == .confirmation {
                    checkoutStep = .payment
                }
            })
        }
        .sheet(isPresented: $showOrderSuccess) {
            OrderSuccessView(selectedTab: $selectedTab)
        }
    }
    
    private func placeOrder() {
        isProcessing = true
        
        // Create new order
        let newOrder = Order(
            id: UUID().uuidString,
            userId: "", // Add user ID from AuthViewModel
            items: cartManager.items.map { item in
                OrderItem(
                    id: UUID().uuidString,
                    product: item.product,
                    quantity: item.quantity,
                    price: item.product.price
                )
            },
            totalAmount: cartManager.total,
            deliveryAddress: selectedAddress ?? OrderDeliveryAddress.default,
            paymentMethod: selectedPaymentMethod ?? OrderPaymentMethod.default,
            status: .pending,
            deliveryTime: Date().addingTimeInterval(3600), // 1 hour delivery time
            createdAt: Date(),
            promoDiscount: nil
        )
        
        // Add order to OrderService
        orderService.addOrder(newOrder)
        
        // Simulate order processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isProcessing = false
            cartManager.clearCart()
            showOrderSuccess = true
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

struct OrderSuccessView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 24) {
            Image("order_accpeted")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .transition(.scale)
            
            Text("Order Placed!")
                .font(.custom("Gilroy-Bold", size: 28))
            
            Text("Your order has been placed successfully.\nYou can track the delivery in the Orders section.")
                .font(.custom("Gilroy-Medium", size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Button(action: {
                selectedTab = 4  // Switch to Profile tab
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Track Order")
                    .font(.custom("Gilroy-Bold", size: 18))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.top, 24)
        }
        .padding()
        .animation(.spring(), value: true)
    }
}

struct AddressSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedAddress: OrderDeliveryAddress?
    let onNext: () -> Void
    @State private var showAddAddress = false
    @StateObject private var viewModel = DeliveryAddressViewModel()
    
    var body: some View {
        VStack {
            if viewModel.addresses.isEmpty {
                EmptyAddressView()
            } else {
                List(viewModel.addresses) { address in
                    AddressCard(
                        address: address,
                        onDelete: { viewModel.deleteAddress(address) },
                        onSetDefault: { viewModel.setDefaultAddress(address) }
                    )
                    .onTapGesture {
                        selectedAddress = OrderDeliveryAddress(
                            id: address.id,
                            name: address.name,
                            street: address.street,
                            city: address.city,
                            state: address.state,
                            zipCode: address.zipCode,
                            country: "USA",
                            phoneNumber: address.phoneNumber,
                            formattedAddress: "\(address.street), \(address.city), \(address.state) \(address.zipCode)"
                        )
                        onNext()
                    }
                    .navigationBarItems(
                        leading: Button("Back") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
            }
            
            Button("Add New Address") {
                showAddAddress = true
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding()
        }
        .sheet(isPresented: $showAddAddress) {
            AddAddressView(viewModel: viewModel)
        }
    }
}



enum PaymentType: String, CaseIterable {
    case card = "Credit/Debit Card"
    case upi = "UPI"
    case cod = "Cash on Delivery"
    
    var icon: String {
        switch self {
        case .card: return "creditcard"
        case .upi: return "indianrupeesign"
        case .cod: return "banknote"
        }
    }
}

struct PaymentMethodView: View {
    @Binding var selectedPaymentMethod: OrderPaymentMethod?
    let onNext: () -> Void
    @State private var showAddPaymentMethod = false
    @State private var selectedType: PaymentType = .card
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(PaymentType.allCases, id: \.self) { type in
                Button(action: {
                    if type == .card {
                        showAddPaymentMethod = true
                    } else {
                        selectedPaymentMethod = OrderPaymentMethod(
                            id: UUID().uuidString,
                            type: type == .upi ? .upi : (type == .cod ? .cod : .creditCard),
                            lastFourDigits: ""
                        )
                        onNext()
                    }
                }) {
                    HStack {
                        Image(systemName: type.icon)
                        Text(type.rawValue)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .sheet(isPresented: $showAddPaymentMethod) {
            AddPaymentMethodView(viewModel: PaymentMethodsViewModel())
        }
    }
}

extension PaymentMethodType {
    var toOrderPaymentType: OrderPaymentMethod.PaymentType {
        switch self {
        case .visa, .mastercard, .amex:
            return .creditCard
        }
    }
}

struct OrderConfirmationView: View {
    let cartManager: CartManager
    let selectedAddress: OrderDeliveryAddress
    let selectedPaymentMethod: OrderPaymentMethod
    let onPlaceOrder: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Order Summary
                VStack(alignment: .leading, spacing: 16) {
                    Text("Order Summary")
                        .font(.custom("Gilroy-Bold", size: 20))
                    
                    ForEach(cartManager.items) { item in
                        HStack {
                            Text(item.product.name)
                            Spacer()
                            Text("\(item.quantity)x")
                            Text("$\(item.total, specifier: "%.2f")")
                        }
                        .font(.custom("Gilroy-Medium", size: 16))
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Total")
                            .font(.custom("Gilroy-Bold", size: 18))
                        Spacer()
                        Text("$\(cartManager.total, specifier: "%.2f")")
                            .font(.custom("Gilroy-Bold", size: 18))
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Button("Place Order") {
                    onPlaceOrder()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding()
        }
    }
}

#Preview {
    CheckoutView(selectedTab: .constant(0), cartManager: CartManager())
        .environmentObject(OrderService())
        .environmentObject(AuthViewModel())
        .environmentObject(CheckoutViewModel())
} 
