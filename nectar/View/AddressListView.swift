import SwiftUI

struct AddressListView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedAddress: OrderDeliveryAddress?
    
    var body: some View {
        NavigationView {
            List {
                // Add sample addresses or fetch from a service
                ForEach(getSampleAddresses(), id: \.id) { address in
                    AddressPreview(address: address)
                        .onTapGesture {
                            selectedAddress = address
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
    
    private func getSampleAddresses() -> [OrderDeliveryAddress] {
        [
            OrderDeliveryAddress(
                id: "1",
                name: "John Doe",
                street: "123 Main St",
                city: "San Francisco",
                state: "CA",
                zipCode: "94105",
                country: "USA",
                phoneNumber: "1234567890",
                formattedAddress: "123 Main St, San Francisco, CA 94105, USA"
            )
        ]
    }
} 