import SwiftUI

struct AddressPreview: View {
    let address: OrderDeliveryAddress
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(address.street)
                .font(.custom("Gilroy-SemiBold", size: 16))
            Text("\(address.city), \(address.state) \(address.zipCode)")
                .font(.custom("Gilroy-Medium", size: 14))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    AddressPreview(address: OrderDeliveryAddress(
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
} 