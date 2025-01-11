import SwiftUI

struct ProductModel: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let image: String
    let unit: String
    let category: Category
    var isFavorite: Bool
    
    enum Category: String, Codable, CaseIterable {
        case fruits = "Fresh Fruits"
        case vegetables = "Vegetables"
        case meat = "Meat & Fish"
        case dairy = "Dairy & Eggs"
        case beverages = "Beverages"
        case snacks = "Bakery & Snacks"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        lhs.id == rhs.id
    }
} 