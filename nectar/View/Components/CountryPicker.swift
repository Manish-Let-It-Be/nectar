import SwiftUI

struct CountryPicker: View {
    @Binding var selectedCountry: Country
    @Environment(\.presentationMode) var presentationMode
    
    let countries: [Country] = [
        Country(name: "United States", code: "US", phoneCode: "+1"),
        Country(name: "United Kingdom", code: "GB", phoneCode: "+44"),
        Country(name: "India", code: "IN", phoneCode: "+91"),
        // Add more countries as needed
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