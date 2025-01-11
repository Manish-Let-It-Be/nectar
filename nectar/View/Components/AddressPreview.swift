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