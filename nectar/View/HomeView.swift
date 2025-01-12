import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @ObservedObject var locationService: LocationService
    @ObservedObject var productService: ProductService
    @EnvironmentObject private var cartManager: CartManager
    @EnvironmentObject private var favoritesManager: FavoritesManager
    @State private var showLocationPicker = false
    @State private var showingProductDetail: ProductModel?
    
    init(locationService: LocationService, productService: ProductService) {
        self.locationService = locationService
        self.productService = productService
        _viewModel = StateObject(wrappedValue: HomeViewModel(productService: productService))
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Location Header
                    LocationHeader(
                        location: locationService.locationString,
                        onLocationTap: { showLocationPicker = true }
                    )
                    
                    // Featured Products Carousel
                    if !viewModel.featuredProducts.isEmpty {
                        FeaturedCarousel(products: viewModel.featuredProducts) { product in
                            showingProductDetail = product
                        }
                    }
                    
                    // Exclusive Offers
                    ProductSection(
                        title: "Exclusive Offers",
                        products: viewModel.exclusiveOffers,
                        onProductTap: { showingProductDetail = $0 },
                        onFavoriteToggle: { favoritesManager.toggleFavorite($0) },
                        onAddToCart: { cartManager.addToCart($0) }
                    )
                    
                    // Best Selling
                    ProductSection(
                        title: "Best Selling",
                        products: viewModel.bestSelling,
                        onProductTap: { showingProductDetail = $0 },
                        onFavoriteToggle: { favoritesManager.toggleFavorite($0) },
                        onAddToCart: { cartManager.addToCart($0) }
                    )
                    
                    // Recommended
                    ProductSection(
                        title: "Recommended",
                        products: viewModel.recommendedProducts,
                        onProductTap: { showingProductDetail = $0 },
                        onFavoriteToggle: { favoritesManager.toggleFavorite($0) },
                        onAddToCart: { cartManager.addToCart($0) }
                    )
                    
                    // Groceries
                    ProductSection(
                        title: "Groceries",
                        products: viewModel.groceries,
                        onProductTap: { showingProductDetail = $0 },
                        onFavoriteToggle: { favoritesManager.toggleFavorite($0) },
                        onAddToCart: { cartManager.addToCart($0) }
                    )
                }
                .padding(.bottom)
            }
            .refreshable {
                viewModel.refreshData()
            }
            .overlay(
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.1))
                    }
                }
            )
            .sheet(isPresented: $showLocationPicker) {
                LocationPickerView(selectedLocation: $locationService.selectedLocation)
            }
            .sheet(item: $showingProductDetail) { product in
                ProductDetailView(product: product)
                    .environmentObject(cartManager)
            }
        }
    }
}

struct LocationHeader: View {
    let location: String
    let onLocationTap: () -> Void
    
    var body: some View {
        Button(action: onLocationTap) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.green)
                Text(location)
                    .font(.custom("Gilroy-SemiBold", size: 18))
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}

struct FeaturedCarousel: View {
    let products: [ProductModel]
    let onProductTap: (ProductModel) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(products) { product in
                    FeaturedProductCard(product: product)
                        .onTapGesture {
                            onProductTap(product)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct FeaturedProductCard: View {
    let product: ProductModel
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(product.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 270, height: 150)
                .clipped()
                .cornerRadius(15)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .cornerRadius(15)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.custom("Gilroy-Bold", size: 18))
                    .foregroundColor(.white)
                
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.custom("Gilroy-SemiBold", size: 16))
                    .foregroundColor(.green)
            }
            .padding()
        }
    }
}

struct ProductSection: View {
    let title: String
    let products: [ProductModel]
    let onProductTap: (ProductModel) -> Void
    let onFavoriteToggle: (ProductModel) -> Void
    let onAddToCart: (ProductModel) -> Void
    @EnvironmentObject private var favoritesManager: FavoritesManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.custom("Gilroy-Bold", size: 20))
                
                Spacer()
                
                NavigationLink(destination: ExploreView()) {
                    Text("See All")
                        .font(.custom("Gilroy-SemiBold", size: 14))
                        .foregroundColor(.green)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(products) { product in
                        ProductCard(
                            product: product,
                            isFavorite: favoritesManager.isFavorite(product),
                            onFavoriteToggle: { onFavoriteToggle(product) },
                            onAddToCart: { onAddToCart(product) }
                        )
                        .onTapGesture {
                            onProductTap(product)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ProductCard: View {
    let product: ProductModel
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    let onAddToCart: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                Image(product.image)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
                
                Button(action: onFavoriteToggle) {
                    Image(isFavorite ? "favorite" : "fav")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.custom("Gilroy-SemiBold", size: 16))
                Text(product.unit)
                    .font(.custom("Gilroy-Medium", size: 12))
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
            .padding(.horizontal, 8)
        }
        .frame(width: 170)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    HomeView(locationService: LocationService(), productService: ProductService())
        .environmentObject(AuthViewModel())
        .environmentObject(CartManager())
        .environmentObject(FavoritesManager())
        .environmentObject(HomeViewModel(productService: ProductService()))
} 