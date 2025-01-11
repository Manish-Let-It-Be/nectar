import SwiftUI

struct PaymentMethodListView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedPaymentMethod: OrderPaymentMethod?
    
    var body: some View {
        NavigationView {
            List {
                // Add sample payment methods or fetch from a service
                ForEach(getSamplePaymentMethods(), id: \.id) { method in
                    PaymentMethodPreview(paymentMethod: method)
                        .onTapGesture {
                            selectedPaymentMethod = method
                            presentationMode.wrappedValue.dismiss()
                        }
                }
            }
            .navigationTitle("Select Payment Method")
            .navigationBarItems(trailing: Button("Add New") {
                // Add navigation to add new payment method view
            })
        }
    }
    
    private func getSamplePaymentMethods() -> [OrderPaymentMethod] {
        [
            OrderPaymentMethod(
                id: "1",
                type: .creditCard,
                lastFourDigits: "4242"
            )
        ]
    }
} 