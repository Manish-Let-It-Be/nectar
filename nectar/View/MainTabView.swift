import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var locationService: LocationService = LocationService()
    @StateObject private var productService: ProductService = ProductService()
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(locationService: locationService, productService: productService)
                .tabItem {
                    VStack {
                        Image("store_tab")
                            .renderingMode(.template)
                        Text("Shop")
                            .font(.custom("Gilroy-Medium", size: 12))
                    }
                }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    VStack {
                        Image("explore_tab")
                            .renderingMode(.template)
                        Text("Explore")
                            .font(.custom("Gilroy-Medium", size: 12))
                    }
                }
                .tag(1)
            
            CartView()
                .tabItem {
                    VStack {
                        Image("cart_tab")
                            .renderingMode(.template)
                        Text("Cart")
                            .font(.custom("Gilroy-Medium", size: 12))
                    }
                }
                .tag(2)
            
            FavoritesView()
                .tabItem {
                    VStack {
                        Image("fav_tab")
                            .renderingMode(.template)
                        Text("Favorites")
                            .font(.custom("Gilroy-Medium", size: 12))
                    }
                }
                .tag(3)
            
            AccountView(productService: productService)
                .tabItem {
                    VStack {
                        Image("account_tab")
                            .renderingMode(.template)
                        Text("Account")
                            .font(.custom("Gilroy-Medium", size: 12))
                    }
                }
                .tag(4)
        }
        .accentColor(Color("AccentColor"))
        .onAppear {
            // Customize tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            
            // Use this appearance when scrolling behind the TabView
            UITabBar.appearance().standardAppearance = appearance
            // Use this appearance when scrolled all the way up
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview{
    MainTabView()
}
