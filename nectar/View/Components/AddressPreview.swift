import SwiftUI
import CoreLocation

struct AddressPreview: View {
    let address: DeliveryAddress
    
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
    AddressPreview(address: DeliveryAddress(
        id: "1",
        name: "John Doe",
        phoneNumber: "1234567890",
        street: "123 Main St",
        apartment: "Apt 1",
        city: "San Francisco",
        state: "CA",
        zipCode: "94105",
        isDefault: false,
        coordinates: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    ))
} 