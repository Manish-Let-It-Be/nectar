import SwiftUI

struct CountryPicker: View {
    @Binding var selectedCountry: Country
    @Environment(\.presentationMode) var presentationMode
    
    let countries: [Country] = [
        Country(name: "United States", code: "US", phoneCode: "+1"),
        Country(name: "United Kingdom", code: "GB", phoneCode: "+44"),
        Country(name: "India", code: "IN", phoneCode: "+91"),
        Country(name: "Canada", code: "CA", phoneCode: "+1"),
        Country(name: "Australia", code: "AU", phoneCode: "+61"),
        Country(name: "Germany", code: "DE", phoneCode: "+49"),
        Country(name: "France", code: "FR", phoneCode: "+33"),
        Country(name: "Italy", code: "IT", phoneCode: "+39"),
        Country(name: "Spain", code: "ES", phoneCode: "+34"),
        Country(name: "Brazil", code: "BR", phoneCode: "+55"),
        Country(name: "Japan", code: "JP", phoneCode: "+81"),
        Country(name: "China", code: "CN", phoneCode: "+86"),
        Country(name: "South Korea", code: "KR", phoneCode: "+82"),
        Country(name: "Russia", code: "RU", phoneCode: "+7"),
        Country(name: "Mexico", code: "MX", phoneCode: "+52"),
        Country(name: "Argentina", code: "AR", phoneCode: "+54"),
        Country(name: "Chile", code: "CL", phoneCode: "+56"),
        Country(name: "Peru", code: "PE", phoneCode: "+51"),
        Country(name: "Colombia", code: "CO", phoneCode: "+57"),
        Country(name: "Venezuela", code: "VE", phoneCode: "+58"),
        Country(name: "Ecuador", code: "EC", phoneCode: "+593"),
        Country(name: "Bolivia", code: "BO", phoneCode: "+591"),
        Country(name: "Paraguay", code: "PY", phoneCode: "+595"),
        Country(name: "Uruguay", code: "UY", phoneCode: "+598"),
    ]
    
    var body: some View {
        NavigationView {
            List(countries) { country in
                Button(action: {
                    selectedCountry = country
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(country.flag)
                        Text(country.name)
                        Spacer()
                        Text(country.phoneCode)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Select Country")
            .navigationBarItems(
                trailing: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct Country: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let code: String
    let phoneCode: String
    
    var flag: String {
        let base: UInt32 = 127397
        var flag = ""
        for scalar in code.unicodeScalars {
            flag.append(String(UnicodeScalar(base + scalar.value)!))
        }
        return flag
    }
}

#Preview {
    CountryPicker(selectedCountry: .constant(Country(
        name: "United States",
        code: "US",
        phoneCode: "+1"
    )))
} 
