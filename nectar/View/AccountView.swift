import SwiftUI
import PhotosUI

struct AccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var deliveryAddressViewModel: DeliveryAddressViewModel
    @StateObject var viewModel = AccountViewModel()
    @StateObject var cartManager = CartManager()
    @ObservedObject var productService: ProductService
    @State private var showImagePicker = false
    @State private var showLogoutAlert = false
    @State private var selectedSegment = 0
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    // Profile Header
                    VStack(spacing: 15) {
                        // Profile Image
                        ZStack(alignment: .bottomTrailing) {
                            if let profileImage = viewModel.profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Image("u1")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            }
                            
                            Button(action: { showImagePicker = true }) {
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.green)
                                    .clipShape(Circle())
                            }
                        }
                        
                        VStack(spacing: 4) {
                            Text(viewModel.name.isEmpty ? "Guest User" : viewModel.name)
                                .font(.custom("Gilroy-Bold", size: 20))
                            Text(viewModel.email.isEmpty ? "" : viewModel.email)
                                .font(.custom("Gilroy-Medium", size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    
                    // Menu Sections
                    VStack(spacing: 24) {
                        // Orders & Details Section
                        MenuSection(title: "Shopping") {
                            NavigationLink(destination: OrdersView(selectedSegment: $selectedSegment)) {
                                MenuRow(image: "a_order", title: "Orders")
                                    .foregroundStyle(Color(.black))
                            }
                            
                            NavigationLink(destination: PersonalDetailsView(accountViewModel: Binding(get: {
                                viewModel
                            }, set: { newValue in
                                viewModel.name = newValue.name
                                viewModel.email = newValue.email
                            }))) {
                                MenuRow(image: "a_my_detail", title: "My Details")
                                    .foregroundStyle(Color(.black))
                            }
                            
                            NavigationLink(destination: DeliveryAddressView()) {
                                MenuRow(image: "a_delivery_address", title: "Delivery Address")
                                    .foregroundStyle(Color(.black))
                            }
                            
                            NavigationLink(destination: PaymentMethodsView()) {
                                MenuRow(image: "paymenth_methods", title: "Payment Methods")
                                    .foregroundStyle(Color(.black))
                            }
                            
                            NavigationLink(destination: PromoCodesView()) {
                                MenuRow(image: "a_promocode", title: "Promo Codes")
                                    .foregroundStyle(Color(.black))
                            }
                        }
                        
                        // Notifications Section
                        MenuSection(title: "Notifications") {
                            NavigationLink(destination: NotificationsView()) {
                                MenuRow(image: "a_noitification", title: "Notifications")
                                    .foregroundStyle(Color(.black))
                            }
                        }
                        
                        // Help Section
                        MenuSection(title: "Help") {
                            NavigationLink(destination: HelpView()) {
                                MenuRow(image: "a_help", title: "Get Help")
                                    .foregroundStyle(Color(.blue))
                            }
                            
                            NavigationLink(destination: AboutView()) {
                                MenuRow(image: "a_about", title: "About Us")
                                    .foregroundStyle(Color(.blue))
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Logout Button
                    Button(action: { showLogoutAlert = true }) {
                        HStack {
                            Image("logout")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                            Text("Log Out")
                                .font(.custom("Gilroy-SemiBold", size: 16))
                        }
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.black))
                        .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $viewModel.profileImage)
            }
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Log Out"),
                    message: Text("Are you sure you want to log out?"),
                    primaryButton: .destructive(Text("Log Out")) {
                        authViewModel.signOut()
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                // Customize navigation bar appearance
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .white // Set the background color
                appearance.titleTextAttributes = [.foregroundColor: UIColor.black] // Set title color
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black] // Set large title color
                
                // Set the back button color
                appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.red] // Change this to your desired color
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                
                // Provide the shared DeliveryAddressViewModel
                DeliveryAddressViewModel.shared
            }

        }
    }
}

// Supporting Views
struct MenuSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.custom("Gilroy-Bold", size: 16))
                .foregroundColor(.gray)
            
            content
        }
    }
}

struct MenuRow: View {
    let image: String
    let title: String
    
    var body: some View {
        HStack {
            Image(image)
                .resizable()
                .frame(width: 20, height: 20)
            
            Text(title)
                .font(.custom("Gilroy-Medium", size: 16))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

// Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }
    }
}

// ViewModel
class AccountViewModel: ObservableObject {
    @Published var profileImage: UIImage?
    @Published var name: String = ""
    @Published var email: String = ""
    
    // Add more profile-related functionality here
}

#Preview {
    AccountView(productService: ProductService())
        .environmentObject(AuthViewModel())
        .environmentObject(CartManager())
        .environmentObject(CheckoutViewModel())
        .environmentObject(FavoritesManager())
        .environmentObject(HomeViewModel(productService: ProductService()))
        .environmentObject(ProductDetailViewModel(product: ProductModel(
            id: "",
            name: "",
            description: "",
            price: 0.0,
            image: "",
            unit: "",
            category: .fruits,
            isFavorite: false
        )))
} 
