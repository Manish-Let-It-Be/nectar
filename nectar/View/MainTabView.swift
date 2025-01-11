import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image("store_tab")
                    Text("Shop")
                }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    Image("explore_tab")
                    Text("Explore")
                }
                .tag(1)
            
            CartView()
                .tabItem {
                    Image("cart_tab")
                    Text("Cart")
                }
                .tag(2)
            
            FavoritesView()
                .tabItem {
                    Image("fav_tab")
                    Text("Favorites")
                }
                .tag(3)
            
            AccountView()
                .tabItem {
                    Image("account_tab")
                    Text("Account")
                }
                .tag(4)
        }
        .accentColor(Color("AccentColor"))
    }
} 