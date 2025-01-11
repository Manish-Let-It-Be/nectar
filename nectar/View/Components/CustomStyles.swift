import SwiftUI

struct NectarTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
    }
}

// Use this as the only alias
typealias CustomTextFieldStyle = NectarTextFieldStyle 