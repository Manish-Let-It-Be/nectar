import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var locationService: LocationService = LocationService()
    @StateObject private var productService: ProductService = ProductService()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(locationService: locationService, productService: productService)
                .tabItem {
                    TabBarItem(
                        imageName: "store_tab",
                        title: "Shop",
                        isSelected: selectedTab == 0
                    )
                }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    TabBarItem(
                        imageName: "explore_tab",
                        title: "Explore",
                        isSelected: selectedTab == 1
                    )
                }
                .tag(1)
            
            CartView(selectedTab: $selectedTab)
                .tabItem {
                    TabBarItem(
                        imageName: "cart_tab",
                        title: "Cart",
                        isSelected: selectedTab == 2
                    )
                }
                .tag(2)
            
            FavoritesView()
                .tabItem {
                    TabBarItem(
                        imageName: "fav_tab",
                        title: "Favorites",
                        isSelected: selectedTab == 3
                    )
                }
                .tag(3)
            
            AccountView(productService: productService)
                .tabItem {
                    TabBarItem(
                        imageName: "account_tab",
                        title: "Account",
                        isSelected: selectedTab == 4
                    )
                }
                .tag(4)
        }
        .accentColor(.green)  // Selected tab color
        .onAppear {
            configureTabBarAppearance()
        }
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        
        // Configure normal state with adaptive colors
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.label
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .font: UIFont(name: "Gilroy-Medium", size: 15) ?? .systemFont(ofSize: 10),
            .foregroundColor: UIColor.secondaryLabel
        ]
        
        // Configure selected state with adaptive colors
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemGreen
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .font: UIFont(name: "Gilroy-Medium", size: 15) ?? .systemFont(ofSize: 10),
            .foregroundColor: UIColor.systemGreen
        ]
        
        // Adjust spacing between icon and text
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
        
        // Apply the appearance
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        // Ensure icons use template rendering mode
        UITabBar.appearance().tintColor = UIColor.systemGreen
        UITabBar.appearance().unselectedItemTintColor = UIColor.secondaryLabel
    }
}

struct TabBarItem: View {
    let imageName: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(imageName)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
            
            Text(title)
                .font(.custom("Gilroy-Medium", size: 10))
                .lineLimit(1)
        }
        //.foregroundColor(isSelected ? .green : .gray) // Removed to let UITabBarAppearance handle colors
        .frame(maxHeight: 40)
    }
}

#Preview {
    MainTabView()
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
