import Foundation

class FavoritesManager: ObservableObject {
    @Published var favoriteProducts: [ProductModel] = []
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favoriteProducts"
    
    init() {
        loadFavorites()
    }
    
    func toggleFavorite(_ product: ProductModel) {
        if let index = favoriteProducts.firstIndex(where: { $0.id == product.id }) {
            favoriteProducts.remove(at: index)
        } else {
            favoriteProducts.append(product)
        }
        saveFavorites()
    }
    
    func isFavorite(_ product: ProductModel) -> Bool {
        favoriteProducts.contains(where: { $0.id == product.id })
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteProducts) {
            userDefaults.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() {
        if let data = userDefaults.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([ProductModel].self, from: data) {
            favoriteProducts = decoded
        }
    }
} 