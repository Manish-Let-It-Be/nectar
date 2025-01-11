import SwiftUI

struct PaymentMethodsView: View {
    @StateObject private var viewModel = PaymentMethodsViewModel()
    @State private var showAddCard = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Payment Methods List
                if viewModel.paymentMethods.isEmpty {
                    EmptyPaymentMethodsView()
                } else {
                    ForEach(viewModel.paymentMethods) { method in
                        PaymentMethodCard(method: method) {
                            viewModel.deletePaymentMethod(method)
                        }
                    }
                }
                
                // Add Payment Method Button
                Button(action: { showAddCard = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Payment Method")
                            .font(.custom("Gilroy-SemiBold", size: 16))
                    }
                    .foregroundColor(.green)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Payment Methods")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddCard) {
            AddPaymentMethodView(viewModel: viewModel)
        }
    }
}

struct PaymentMethodCard: View {
    let method: PaymentMethod
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Image(method.type.imageName)
                .resizable()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(method.type.rawValue)
                    .font(.custom("Gilroy-SemiBold", size: 16))
                Text("•••• \(method.lastFourDigits)")
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if method.isDefault {
                Text("Default")
                    .font(.custom("Gilroy-Medium", size: 12))
                    .foregroundColor(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct EmptyPaymentMethodsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "creditcard")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Payment Methods")
                .font(.custom("Gilroy-SemiBold", size: 18))
            
            Text("Add a payment method to start shopping")
                .font(.custom("Gilroy-Medium", size: 14))
                .foregroundColor(.gray)
        }
        .padding()
    }
}

// Models
struct PaymentMethod: Identifiable {
    let id: String
    let type: PaymentMethodType
    let lastFourDigits: String
    let isDefault: Bool
}

enum PaymentMethodType: String {
    case visa = "Visa"
    case mastercard = "Mastercard"
    case amex = "American Express"
    
    var imageName: String {
        switch self {
        case .visa: return "visa"
        case .mastercard: return "master"
        case .amex: return "amex"
        }
    }
}

// ViewModel
class PaymentMethodsViewModel: ObservableObject {
    @Published var paymentMethods: [PaymentMethod] = []
    
    func addPaymentMethod(_ method: PaymentMethod) {
        paymentMethods.append(method)
    }
    
    func deletePaymentMethod(_ method: PaymentMethod) {
        paymentMethods.removeAll { $0.id == method.id }
    }
} 