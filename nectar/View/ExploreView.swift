import SwiftUI

struct ExploreView: View {
    @StateObject private var productService = ProductService()
    @EnvironmentObject private var favoritesManager: FavoritesManager
    @EnvironmentObject private var cartManager: CartManager
    @State private var showingProductDetail: ProductModel?
    @State private var showFilters = false
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchBar
                categoryScrollView
                productsGrid
            }
            .navigationTitle("Explore")
            .navigationBarItems(trailing: filterButton)
            .sheet(isPresented: $showFilters) {
                FilterView(productService: productService)
            }
            .sheet(item: $showingProductDetail) { product in
                ProductDetailView(product: product)
                    .environmentObject(cartManager)
            }
        }
    }

    private var searchBar: some View {
        SearchBar(text: $productService.searchText)
            .padding()
    }

    private var categoryScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryButton(
                    title: "All",
                    isSelected: productService.selectedCategory == nil,
                    action: { productService.selectedCategory = nil }
                )

                ForEach(ProductModel.Category.allCases, id: \.self) { category in
                    CategoryButton(
                        title: category.rawValue,
                        isSelected: productService.selectedCategory == category,
                        action: { productService.selectedCategory = category }
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
    }

    private var productsGrid: some View {
        ScrollView {
            if productService.filteredProducts.isEmpty {
                EmptySearchView()
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(productService.filteredProducts) { product in
                        let isFavorite = favoritesManager.isFavorite(product)
                        
                        ProductCard(
                            product: product,
                            isFavorite: isFavorite,
                            onFavoriteToggle: {
                                favoritesManager.toggleFavorite(product)
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
    }

    private var filterButton: some View {
        Button(action: { showFilters = true }) {
            Image("filter_ic")
                .renderingMode(.template)
                .foregroundColor(.primary)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search Store", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Gilroy-SemiBold", size: 14))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.green : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct EmptySearchView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Results Found")
                .font(.custom("Gilroy-Bold", size: 20))
            
            Text("Try adjusting your search or filters\nto find what you're looking for")
                .font(.custom("Gilroy-Medium", size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    ExploreView()
        .environmentObject(AuthViewModel())
        .environmentObject(CartManager())
        .environmentObject(FavoritesManager())
} 