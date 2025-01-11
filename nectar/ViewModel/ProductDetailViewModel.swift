import SwiftUI

class ProductDetailViewModel: ObservableObject {
    @Published var quantity = 1
    @Published var isFavorite: Bool = false
    private let product: ProductModel
    
    let nutritionFacts = [
        NutritionFact(name: "Calories", value: "89"),
        NutritionFact(name: "Protein", value: "1.1g"),
        NutritionFact(name: "Carbs", value: "22.8g"),
        NutritionFact(name: "Fat", value: "0.3g")
    ]
    
    init(product: ProductModel) {
        self.product = product
    }
    
    func incrementQuantity() {
        quantity += 1
    }
    
    func decrementQuantity() {
        guard quantity > 1 else { return }
        quantity -= 1
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
    }
} 