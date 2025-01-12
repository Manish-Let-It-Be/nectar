import SwiftUI

struct FavoritesView: View {
//    @StateObject private var favoritesManager = FavoritesManager()
    @EnvironmentObject private var favoritesManager: FavoritesManager
    @EnvironmentObject private var cartManager: CartManager
    @State private var showingProductDetail: ProductModel?
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                if favoritesManager.favoriteProducts.isEmpty {
                    EmptyFavoritesView()
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(favoritesManager.favoriteProducts) { product in
                            FavoriteProductCard(
                                product: product,
                                isFavorite: true,
                                onFavoriteToggle: {
                                    withAnimation {
                                        favoritesManager.toggleFavorite(product)
                                    }
                                },
                                onAddToCart: {
                                    cartManager.addToCart(product)
                                }
                            )
                            .onTapGesture {
                                showingProductDetail = product
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Favorites")
            .sheet(item: $showingProductDetail) { product in
                ProductDetailView(product: product)
                    .environmentObject(cartManager)
            }
        }
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("No Favorites Yet")
                .font(.custom("Gilroy-Bold", size: 20))
            
            Text("Add items to your favorites\nto see them here")
                .font(.custom("Gilroy-Medium", size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct FavoriteProductCard: View {
    let product: ProductModel
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    let onAddToCart: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Product Image
            ZStack(alignment: .topTrailing) {
                Image(product.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 120)
                
                Button(action: onFavoriteToggle) {
                    Image(isFavorite ? "favorite" : "fav")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(8)
                }
            }
            
            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.custom("Gilroy-SemiBold", size: 16))
                    .lineLimit(2)
                
                Text(product.unit)
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.gray)
                
                HStack {
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.custom("Gilroy-Bold", size: 16))
                        .foregroundColor(.green)
                    
                    Spacer()
                    
                    Button(action: onAddToCart) {
                        Image("add_to_cart")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    FavoritesView()
        .environmentObject(AuthViewModel())
        .environmentObject(CartManager())
        .environmentObject(FavoritesManager())
} 
