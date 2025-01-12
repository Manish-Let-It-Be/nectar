import SwiftUI

struct AddPaymentMethodView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PaymentMethodsViewModel
    @StateObject private var cardViewModel = CardViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Card Preview
                    CreditCardView(
                        number: cardViewModel.number,
                        name: cardViewModel.name,
                        expiry: cardViewModel.expiry,
                        type: cardViewModel.cardType
                    )
                    .padding(.horizontal)
                    
                    // Form Fields
                    VStack(spacing: 16) {
                        CustomTextField(
                            title: "Card Number",
                            text: $cardViewModel.number,
                            keyboardType: .numberPad,
                            error: cardViewModel.numberError
                        )
                        .onChange(of: cardViewModel.number) { _ in
                            cardViewModel.formatCardNumber()
                        }
                        
                        CustomTextField(
                            title: "Cardholder Name",
                            text: $cardViewModel.name,
                            error: cardViewModel.nameError
                        )
                        
                        HStack(spacing: 12) {
                            CustomTextField(
                                title: "Expiry Date",
                                text: $cardViewModel.expiry,
                                keyboardType: .numberPad,
                                error: cardViewModel.expiryError
                            )
                            .onChange(of: cardViewModel.expiry) { _ in
                                cardViewModel.formatExpiry()
                            }
                            
                            CustomTextField(
                                title: "CVV",
                                text: $cardViewModel.cvv,
                                keyboardType: .numberPad,
                                error: cardViewModel.cvvError
                            )
                        }
                        
                        Toggle("Set as default payment method", isOn: $cardViewModel.isDefault)
                            .font(.custom("Gilroy-Medium", size: 16))
                    }
                    .padding(.horizontal)
                    
                    // Add Card Button
                    Button(action: {
                        if cardViewModel.validateFields() {
                            let newCard = PaymentMethod(
                                id: UUID().uuidString,
                                type: cardViewModel.cardType,
                                lastFourDigits: String(cardViewModel.number.suffix(4)),
                                isDefault: cardViewModel.isDefault
                            )
                            viewModel.addPaymentMethod(newCard)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Add Card")
                            .font(.custom("Gilroy-SemiBold", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Add Payment Method")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct CreditCardView: View {
    let number: String
    let name: String
    let expiry: String
    let type: PaymentMethodType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(type.imageName)
                    .resizable()
                    .frame(width: 50, height: 30)
                Spacer()
            }
            
            Text(number.isEmpty ? "•••• •••• •••• ••••" : number)
                .font(.custom("Gilroy-Bold", size: 22))
            
            HStack {
                VStack(alignment: .leading) {
                    Text("CARD HOLDER")
                        .font(.custom("Gilroy-Medium", size: 10))
                        .foregroundColor(.gray)
                    Text(name.isEmpty ? "YOUR NAME" : name)
                        .font(.custom("Gilroy-SemiBold", size: 14))
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("EXPIRES")
                        .font(.custom("Gilroy-Medium", size: 10))
                        .foregroundColor(.gray)
                    Text(expiry.isEmpty ? "MM/YY" : expiry)
                        .font(.custom("Gilroy-SemiBold", size: 14))
                }
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .foregroundColor(.white)
        .cornerRadius(15)
    }
}

class CardViewModel: ObservableObject {
    @Published var number = ""
    @Published var name = ""
    @Published var expiry = ""
    @Published var cvv = ""
    @Published var isDefault = false
    
    @Published var numberError: String?
    @Published var nameError: String?
    @Published var expiryError: String?
    @Published var cvvError: String?
    
    var cardType: PaymentMethodType {
        if number.hasPrefix("4") {
            return .visa
        } else if number.hasPrefix("5") {
            return .mastercard
        } else if number.hasPrefix("3") {
            return .amex
        }
        return .visa
    }
    
    func formatCardNumber() {
        let cleaned = number.filter { $0.isNumber }
        if cleaned.count > 16 {
            number = String(cleaned.prefix(16))
        }
        
        var formatted = ""
        for (index, char) in cleaned.enumerated() {
            if index > 0 && index % 4 == 0 {
                formatted += " "
            }
            formatted.append(char)
        }
        number = formatted
    }
    
    func formatExpiry() {
        let cleaned = expiry.filter { $0.isNumber }
        if cleaned.count > 4 {
            expiry = String(cleaned.prefix(4))
        }
        
        if cleaned.count >= 2 {
            let month = String(cleaned.prefix(2))
            var formatted = month
            if cleaned.count > 2 {
                formatted += "/"
                formatted += String(cleaned.suffix(cleaned.count - 2))
            }
            expiry = formatted
        } else {
            expiry = cleaned
        }
    }
    
    func validateFields() -> Bool {
        var isValid = true
        
        // Reset errors
        numberError = nil
        nameError = nil
        expiryError = nil
        cvvError = nil
        
        // Validate card number
        let cleanedNumber = number.filter { $0.isNumber }
        if cleanedNumber.count != 16 {
            numberError = "Please enter a valid card number"
            isValid = false
        }
        
        // Validate name
        if name.isEmpty {
            nameError = "Cardholder name is required"
            isValid = false
        }
        
        // Validate expiry
        let cleanedExpiry = expiry.filter { $0.isNumber }
        if cleanedExpiry.count < 4 {
            expiryError = "Invalid expiry date"
            isValid = false
        } else {
            let month = Int(cleanedExpiry.prefix(2)) ?? 0
            var year = Int(cleanedExpiry.suffix(cleanedExpiry.count - 2)) ?? 0
            
            // Convert 4-digit year to 2-digit year if necessary
            if year > 100 {
                year = year % 100
            }
            
            let currentYear = Calendar.current.component(.year, from: Date()) % 100
            let currentMonth = Calendar.current.component(.month, from: Date())
            
            if month < 1 || month > 12 {
                expiryError = "Invalid month"
                isValid = false
            } else if year < currentYear || (year == currentYear && month < currentMonth) {
                expiryError = "Card has expired"
                isValid = false
            }
        }
        
        // Validate CVV
        if cvv.count != 3 {
            cvvError = "Invalid CVV"
            isValid = false
        }
        
        return isValid
    }
}

#Preview {
    AddPaymentMethodView(viewModel: PaymentMethodsViewModel())
        .environmentObject(AuthViewModel())
} 