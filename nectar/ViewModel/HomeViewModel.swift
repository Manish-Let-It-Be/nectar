import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var featuredProducts: [ProductModel] = []
    @Published var recommendedProducts: [ProductModel] = []
    @Published var exclusiveOffers: [ProductModel] = []
    @Published var bestSelling: [ProductModel] = []
    @Published var groceries: [ProductModel] = []
    @Published var isLoading = false
    
    private let productService: ProductService
    private var cancellables = Set<AnyCancellable>()
    
    init(productService: ProductService) {
        self.productService = productService
        loadHomeData()
    }
    
    func loadHomeData() {
        isLoading = true
        
        // Simulate API call delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            let allProducts = self.productService.products
            
            // Featured products (random selection)
            self.featuredProducts = Array(allProducts.shuffled().prefix(3))
            
            // Exclusive offers (products with price < 3.0)
            self.exclusiveOffers = allProducts.filter { $0.price < 3.0 }
            
            // Best selling (random selection)
            self.bestSelling = Array(allProducts.shuffled().prefix(4))
            
            // Recommended (random selection different from best selling)
            let remainingProducts = Set(allProducts).subtracting(Set(self.bestSelling))
            self.recommendedProducts = Array(remainingProducts).shuffled().prefix(4).map { $0 }
            
            // Groceries (random selection from remaining)
            let moreProducts = Set(remainingProducts).subtracting(Set(self.recommendedProducts))
            self.groceries = Array(moreProducts).shuffled().prefix(4).map { $0 }
            
            self.isLoading = false
        }
    }
    
    func refreshData() {
        loadHomeData()
    }
} 