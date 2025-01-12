import SwiftUI

extension DeliveryAddress {
    func toOrderDeliveryAddress() -> OrderDeliveryAddress {
        return OrderDeliveryAddress(
            id: self.id,
            name: self.name,
            street: self.street,
            city: self.city,
            state: self.state,
            zipCode: self.zipCode,
            country: "USA", // Adjust as necessary
            phoneNumber: self.phoneNumber,
            formattedAddress: self.formattedAddress
        )
    }
}

struct AddressListView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DeliveryAddressViewModel // Use shared instance
    @Binding var selectedAddress: OrderDeliveryAddress?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.addresses) { address in
                    AddressPreview(address: address)
                        .onTapGesture {
                            selectedAddress = address.toOrderDeliveryAddress()
                            presentationMode.wrappedValue.dismiss()
                        }
                }
            }
            .navigationTitle("Select Address")
            .navigationBarItems(trailing: Button("Add New") {
                // Add navigation to add new address view
            })
        }
    }
}

#Preview {
    AddressListView(
        viewModel: DeliveryAddressViewModel.shared,
        selectedAddress: .constant(OrderDeliveryAddress(
            id: "1",
            name: "John Doe",
            street: "123 Main St",
            city: "San Francisco",
            state: "CA",
            zipCode: "94105",
            country: "USA",
            phoneNumber: "1234567890",
            formattedAddress: "123 Main St, San Francisco, CA 94105"
        ))
    )
    .environmentObject(AuthViewModel())
} 