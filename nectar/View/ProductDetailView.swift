import SwiftUI

struct ProductDetailView: View {
    let product: ProductModel
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var viewModel: ProductDetailViewModel
    @EnvironmentObject private var cartManager: CartManager
    @Environment(\.presentationMode) var presentationMode
    
    init(product: ProductModel) {
        self.product = product
        // Initialize viewModel with the product and favoritesManager
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(product: product))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Product Image
                ZStack(alignment: .topTrailing) {
                    Image(product.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                    
                    Button(action: { viewModel.toggleFavorite() }) {
                        Image(viewModel.isFavorite ? "favorite" : "fav")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .padding()
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Product Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.name)
                            .font(.custom("Gilroy-Bold", size: 24))
                        
                        Text(product.unit)
                            .font(.custom("Gilroy-Medium", size: 16))
                            .foregroundColor(.gray)
                        
                        Text("$\(product.price, specifier: "%.2f")")
                            .font(.custom("Gilroy-Bold", size: 24))
                            .foregroundColor(.green)
                    }
                    
                    Divider()
                    
                    // Product Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Product Details")
                            .font(.custom("Gilroy-Bold", size: 18))
                        
                        Text(product.description)
                            .font(.custom("Gilroy-Medium", size: 16))
                            .foregroundColor(.gray)
                            .lineSpacing(4)
                    }
                    
                    Divider()
                    
                    // Nutrition Facts
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Nutrition Facts")
                            .font(.custom("Gilroy-Bold", size: 18))
                        
                        NutritionGrid(nutritionFacts: viewModel.nutritionFacts)
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.primary)
            }
        )
        .overlay(
            VStack {
                Spacer()
                
                // Add to Cart Button
                HStack {
                    // Quantity Stepper
                    HStack {
                        Button(action: { viewModel.decrementQuantity() }) {
                            Image(systemName: "minus")
                                .padding(8)
                        }
                        
                        Text("\(viewModel.quantity)")
                            .font(.custom("Gilroy-Bold", size: 18))
                            .frame(width: 40)
                        
                        Button(action: { viewModel.incrementQuantity() }) {
                            Image("add_to_cart")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    Button(action: {
                        cartManager.addToCart(product, quantity: viewModel.quantity)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Add to Cart")
                            .font(.custom("Gilroy-Bold", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .shadow(radius: 2)
            }
        )
    }
}

struct NutritionGrid: View {
    let nutritionFacts: [NutritionFact]
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            ForEach(nutritionFacts) { fact in
                VStack(spacing: 4) {
                    Text(fact.value)
                        .font(.custom("Gilroy-Bold", size: 16))
                    Text(fact.name)
                        .font(.custom("Gilroy-Medium", size: 14))
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct NutritionFact: Identifiable {
    let id = UUID()
    let name: String
    let value: String
}

// class ProductDetailViewModel: ObservableObject {
//     @Published var quantity = 1
//     @Published var isFavorite: Bool
//     private let favoritesManager: FavoritesManager
//     private let product: Product
    
//     let nutritionFacts = [
//         NutritionFact(name: "Calories", value: "89"),
//         NutritionFact(name: "Protein", value: "1.1g"),
//         NutritionFact(name: "Carbs", value: "22.8g"),
//         NutritionFact(name: "Fat", value: "0.3g")
//     ]
    
//     init(product: Product, favoritesManager: FavoritesManager) {
//         self.product = product
//         self.favoritesManager = favoritesManager
//         self.isFavorite = favoritesManager.isFavorite(product)
//     }
    
//     func incrementQuantity() {
//         quantity += 1
//     }
    
//     func decrementQuantity() {
//         guard quantity > 1 else { return }
//         quantity -= 1
//     }
    
//     func toggleFavorite() {
//         favoritesManager.toggleFavorite(product)
//         isFavorite.toggle()
//     }
// } 