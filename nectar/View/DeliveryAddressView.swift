import SwiftUI
import MapKit

struct DeliveryAddressView: View {
    @StateObject private var viewModel = DeliveryAddressViewModel()
    @State private var showAddAddress = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Address List
                if viewModel.addresses.isEmpty {
                    EmptyAddressView()
                } else {
                    ForEach(viewModel.addresses) { address in
                        AddressCard(address: address) {
                            viewModel.deleteAddress(address)
                        } onSetDefault: {
                            viewModel.setDefaultAddress(address)
                        }
                    }
                }
                
                // Add Address Button
                Button(action: { showAddAddress = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Address")
                            .font(.custom("Gilroy-SemiBold", size: 16))
                    }
                    .foregroundColor(.green)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Delivery Addresses")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddAddress) {
            AddAddressView(viewModel: viewModel)
        }
    }
}

struct AddressCard: View {
    let address: DeliveryAddress
    let onDelete: () -> Void
    let onSetDefault: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(address.name)
                        .font(.custom("Gilroy-SemiBold", size: 16))
                    Text(address.phoneNumber)
                        .font(.custom("Gilroy-Medium", size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if address.isDefault {
                    Text("Default")
                        .font(.custom("Gilroy-Medium", size: 12))
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            
            Divider()
            
            Text(address.formattedAddress)
                .font(.custom("Gilroy-Medium", size: 14))
                .foregroundColor(.gray)
            
            HStack {
                Button(action: onSetDefault) {
                    Text(address.isDefault ? "Default Address" : "Set as Default")
                        .font(.custom("Gilroy-Medium", size: 14))
                        .foregroundColor(address.isDefault ? .gray : .green)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct EmptyAddressView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "location.circle")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Addresses")
                .font(.custom("Gilroy-SemiBold", size: 18))
            
            Text("Add your delivery addresses")
                .font(.custom("Gilroy-Medium", size: 14))
                .foregroundColor(.gray)
        }
        .padding()
    }
}

// Models
struct DeliveryAddress: Identifiable {
    let id: String
    let name: String
    let phoneNumber: String
    let street: String
    let apartment: String
    let city: String
    let state: String
    let zipCode: String
    let isDefault: Bool
    let coordinates: CLLocationCoordinate2D
    
    var formattedAddress: String {
        var components = [String]()
        if !apartment.isEmpty {
            components.append("\(street), \(apartment)")
        } else {
            components.append(street)
        }
        components.append("\(city), \(state) \(zipCode)")
        return components.joined(separator: "\n")
    }
}

// ViewModel
class DeliveryAddressViewModel: ObservableObject {
    @Published var addresses: [DeliveryAddress] = []
    
    func addAddress(_ address: DeliveryAddress) {
        if address.isDefault {
            // Remove default status from other addresses
            addresses = addresses.map { addr in
                var mutableAddr = addr
                if mutableAddr.isDefault {
                    // Create new address with isDefault set to false
                    return DeliveryAddress(
                        id: mutableAddr.id,
                        name: mutableAddr.name,
                        phoneNumber: mutableAddr.phoneNumber,
                        street: mutableAddr.street,
                        apartment: mutableAddr.apartment,
                        city: mutableAddr.city,
                        state: mutableAddr.state,
                        zipCode: mutableAddr.zipCode,
                        isDefault: false,
                        coordinates: mutableAddr.coordinates
                    )
                }
                return mutableAddr
            }
        }
        addresses.append(address)
    }
    
    func deleteAddress(_ address: DeliveryAddress) {
        addresses.removeAll { $0.id == address.id }
    }
    
    func setDefaultAddress(_ address: DeliveryAddress) {
        addresses = addresses.map { addr in
            var mutableAddr = addr
            if mutableAddr.id == address.id {
                return DeliveryAddress(
                    id: mutableAddr.id,
                    name: mutableAddr.name,
                    phoneNumber: mutableAddr.phoneNumber,
                    street: mutableAddr.street,
                    apartment: mutableAddr.apartment,
                    city: mutableAddr.city,
                    state: mutableAddr.state,
                    zipCode: mutableAddr.zipCode,
                    isDefault: true,
                    coordinates: mutableAddr.coordinates
                )
            } else if mutableAddr.isDefault {
                return DeliveryAddress(
                    id: mutableAddr.id,
                    name: mutableAddr.name,
                    phoneNumber: mutableAddr.phoneNumber,
                    street: mutableAddr.street,
                    apartment: mutableAddr.apartment,
                    city: mutableAddr.city,
                    state: mutableAddr.state,
                    zipCode: mutableAddr.zipCode,
                    isDefault: false,
                    coordinates: mutableAddr.coordinates
                )
            }
            return mutableAddr
        }
    }
}

#Preview {
    DeliveryAddressView()
        .environmentObject(AuthViewModel())
} 