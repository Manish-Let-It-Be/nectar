import SwiftUI

struct AccountView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            List {
                // Profile Section
                Section {
                    HStack {
                        Image("u1")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(authViewModel.currentUser?.name ?? "Guest User")
                                .font(.custom("Gilroy-SemiBold", size: 18))
                            Text(authViewModel.currentUser?.email ?? "")
                                .font(.custom("Gilroy-Medium", size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Orders & Details Section
                Section {
                    AccountMenuItem(image: "a_order", title: "Orders")
                    AccountMenuItem(image: "a_my_detail", title: "My Details")
                    AccountMenuItem(image: "a_delivery_address", title: "Delivery Address")
                    AccountMenuItem(image: "paymenth_methods", title: "Payment Methods")
                    AccountMenuItem(image: "a_promocode", title: "Promo Codes")
                }
                
                // Notifications Section
                Section {
                    AccountMenuItem(image: "a_noitification", title: "Notifications")
                }
                
                // Help Section
                Section {
                    AccountMenuItem(image: "a_help", title: "Help")
                    AccountMenuItem(image: "a_about", title: "About")
                }
                
                // Logout Section
                Section {
                    Button(action: {
                        authViewModel.signOut()
                    }) {
                        HStack {
                            Image("logout")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Log Out")
                                .foregroundColor(.red)
                                .font(.custom("Gilroy-Medium", size: 16))
                        }
                    }
                }
            }
            .navigationTitle("Account")
        }
    }
}

struct AccountMenuItem: View {
    let image: String
    let title: String
    
    var body: some View {
        HStack {
            Image(image)
                .resizable()
                .frame(width: 20, height: 20)
            Text(title)
                .font(.custom("Gilroy-Medium", size: 16))
        }
    }
} 