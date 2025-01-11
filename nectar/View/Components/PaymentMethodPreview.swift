import SwiftUI

struct PaymentMethodPreview: View {
    let paymentMethod: OrderPaymentMethod
    
    var body: some View {
        HStack {
            Image(paymentMethod.type.imageName)
                .resizable()
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(paymentMethod.type.rawValue)
                    .font(.custom("Gilroy-SemiBold", size: 16))
                Text("•••• \(paymentMethod.lastFourDigits)")
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.gray)
            }
        }
    }
} 