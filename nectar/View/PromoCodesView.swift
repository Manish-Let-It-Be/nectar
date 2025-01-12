import SwiftUI

struct PromoCodesView: View {
    var body: some View {
        Text("Promo Codes")
    }
}

#Preview {
    PromoCodesView()
        .environmentObject(AuthViewModel())
} 