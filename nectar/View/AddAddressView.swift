import SwiftUI
import MapKit
import CoreLocation

struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct AddAddressView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DeliveryAddressViewModel
    @StateObject private var addressViewModel = AddAddressViewModel()
    @State private var showLocationPicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Map Preview
                    if let coordinate = addressViewModel.selectedLocation {
                        MapView(coordinate: coordinate)
                            .frame(height: 200)
                            .cornerRadius(10)
                    }
                    
                    // Form Fields
                    VStack(spacing: 16) {
                        CustomTextField(
                            title: "Full Name",
                            text: $addressViewModel.name,
                            error: addressViewModel.nameError
                        )
                        
                        CustomTextField(
                            title: "Phone Number",
                            text: $addressViewModel.phone,
                            keyboardType: .phonePad,
                            error: addressViewModel.phoneError
                        )
                        
                        CustomTextField(
                            title: "Street Address",
                            text: $addressViewModel.street,
                            error: addressViewModel.streetError
                        )
                        
                        CustomTextField(
                            title: "Apartment/Suite (Optional)",
                            text: $addressViewModel.apartment
                        )
                        
                        HStack(spacing: 12) {
                            CustomTextField(
                                title: "City",
                                text: $addressViewModel.city,
                                error: addressViewModel.cityError
                            )
                            
                            CustomTextField(
                                title: "State",
                                text: $addressViewModel.state,
                                error: addressViewModel.stateError
                            )
                        }
                        
                        CustomTextField(
                            title: "ZIP Code",
                            text: $addressViewModel.zipCode,
                            keyboardType: .numberPad,
                            error: addressViewModel.zipError
                        )
                        
                        Toggle("Set as default address", isOn: $addressViewModel.isDefault)
                            .font(.custom("Gilroy-Medium", size: 16))
                    }
                    .padding(.horizontal)
                    
                    // Pick Location Button
                    Button(action: { showLocationPicker = true }) {
                        HStack {
                            Image(systemName: "location.fill")
                            Text("Pick Location on Map")
                                .font(.custom("Gilroy-SemiBold", size: 16))
                        }
                        .foregroundColor(.green)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // Save Button
                    Button(action: {
                        if addressViewModel.validateFields() {
                            let newAddress = DeliveryAddress(
                                id: UUID().uuidString,
                                name: addressViewModel.name,
                                phoneNumber: addressViewModel.phone,
                                street: addressViewModel.street,
                                apartment: addressViewModel.apartment,
                                city: addressViewModel.city,
                                state: addressViewModel.state,
                                zipCode: addressViewModel.zipCode,
                                isDefault: addressViewModel.isDefault,
                                coordinates: addressViewModel.selectedLocation ?? CLLocationCoordinate2D()
                            )
                            viewModel.addAddress(newAddress)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Save Address")
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
            .navigationTitle("Add New Address")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .sheet(isPresented: $showLocationPicker) {
                LocationPickerView(selectedLocation: $addressViewModel.selectedLocation)
            }
        }
    }
}

struct MapView: View {
    let coordinate: CLLocationCoordinate2D
    
    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )), annotationItems: [IdentifiableCoordinate(coordinate: coordinate)]) { location in
            MapMarker(coordinate: location.coordinate)
        }
    }
}

class AddAddressViewModel: ObservableObject {
    @Published var name = ""
    @Published var phone = ""
    @Published var street = ""
    @Published var apartment = ""
    @Published var city = ""
    @Published var state = ""
    @Published var zipCode = ""
    @Published var isDefault = false
    @Published var selectedLocation: CLLocationCoordinate2D?
    
    @Published var nameError: String?
    @Published var phoneError: String?
    @Published var streetError: String?
    @Published var cityError: String?
    @Published var stateError: String?
    @Published var zipError: String?
    
    func validateFields() -> Bool {
        var isValid = true
        
        // Reset errors
        nameError = nil
        phoneError = nil
        streetError = nil
        cityError = nil
        stateError = nil
        zipError = nil
        
        if name.isEmpty {
            nameError = "Name is required"
            isValid = false
        }
        
        if !phone.isValidPhone() {
            phoneError = "Please enter a valid phone number"
            isValid = false
        }
        
        if street.isEmpty {
            streetError = "Street address is required"
            isValid = false
        }
        
        if city.isEmpty {
            cityError = "City is required"
            isValid = false
        }
        
        if state.isEmpty {
            stateError = "State is required"
            isValid = false
        }
        
        if !zipCode.isValidZipCode() {
            zipError = "Please enter a valid ZIP code"
            isValid = false
        }
        
        return isValid
    }
}

extension String {
    func isValidZipCode() -> Bool {
        let zipRegex = "^[0-9]{5,6}(-[0-9]{4})?$"
        let zipTest = NSPredicate(format: "SELF MATCHES %@", zipRegex)
        return zipTest.evaluate(with: self)
    }
}

#Preview {
    AddAddressView(viewModel: DeliveryAddressViewModel())
        .environmentObject(AuthViewModel())
} 