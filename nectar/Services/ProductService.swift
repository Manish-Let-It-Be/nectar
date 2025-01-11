import Foundation
import Combine

class ProductService: ObservableObject {
    @Published var products: [ProductModel] = []
    @Published var filteredProducts: [ProductModel] = []
    @Published var categories: [ProductModel.Category] = ProductModel.Category.allCases
    @Published var selectedCategory: ProductModel.Category?
    @Published var searchText = ""
    @Published var sortOption: FilterView.SortOption = .nameAsc
    @Published var priceRange: ClosedRange<Double> = 0...100
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadProducts()
        setupSearchAndFilterPublishers()
    }
    
    private func setupSearchAndFilterPublishers() {
        Publishers.CombineLatest3($searchText, $selectedCategory, $sortOption)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] (searchText, category, sortOption) in
                self?.filterAndSortProducts(
                    searchText: searchText,
                    category: category,
                    sortOption: sortOption
                )
            }
            .store(in: &cancellables)
    }
    
    private func filterAndSortProducts(
        searchText: String,
        category: ProductModel.Category?,
        sortOption: FilterView.SortOption
    ) {
        let searchTextLowercased = searchText.lowercased()
        
        // Filter products
        filteredProducts = products.filter { product in
            let matchesCategory = category == nil || product.category == category
            let matchesSearch = searchText.isEmpty ||
                product.name.lowercased().contains(searchTextLowercased) ||
                product.description.lowercased().contains(searchTextLowercased)
            let matchesPriceRange = product.price >= priceRange.lowerBound &&
                product.price <= priceRange.upperBound
            
            return matchesCategory && matchesSearch && matchesPriceRange
        }
        
        // Sort products
        filteredProducts.sort { first, second in
            switch sortOption {
            case .nameAsc:
                return first.name < second.name
            case .nameDesc:
                return first.name > second.name
            case .priceLowToHigh:
                return first.price < second.price
            case .priceHighToLow:
                return first.price > second.price
            }
        }
    }
    
    private func loadProducts() {
        products = [
            ProductModel(
                id: "1",
                name: "Organic Bananas",
                description: "Fresh organic bananas from Ecuador. Rich in potassium and vitamins.",
                price: 4.99,
                image: "banana",
                unit: "7pcs",
                category: .fruits,
                isFavorite: false
            ),
            ProductModel(
                id: "2",
                name: "Red Apple",
                description: "Sweet and crispy red apples. Perfect for snacking or baking.",
                price: 3.99,
                image: "apple_red",
                unit: "1kg",
                category: .fruits,
                isFavorite: false
            ),
            ProductModel(
                id: "3",
                name: "Bell Pepper Red",
                description: "Fresh red bell peppers. Great for salads and cooking.",
                price: 2.99,
                image: "bell_pepper_red",
                unit: "1kg",
                category: .vegetables,
                isFavorite: false
            ),
            ProductModel(
                id: "4",
                name: "Ginger",
                description: "Fresh ginger root. Essential for Asian cuisine and tea.",
                price: 1.99,
                image: "ginger",
                unit: "250g",
                category: .vegetables,
                isFavorite: false
            ),
            ProductModel(
                id: "5",
                name: "Chicken Eggs",
                description: "Farm fresh chicken eggs. High in protein and versatile.",
                price: 5.99,
                image: "egg_chicken_red",
                unit: "12pcs",
                category: .dairy,
                isFavorite: false
            ),
            ProductModel(
                id: "6",
                name: "Broiler Chicken",
                description: "Fresh whole broiler chicken. Perfect for roasting.",
                price: 8.99,
                image: "broiler_chicken",
                unit: "1kg",
                category: .meat,
                isFavorite: false
            ),
            ProductModel(
                id: "7",
                name: "Coca-Cola",
                description: "Classic Coca-Cola. Best served chilled.",
                price: 2.49,
                image: "cocacola_can",
                unit: "330ml",
                category: .beverages,
                isFavorite: false
            ),
            ProductModel(
                id: "8",
                name: "Diet Coke",
                description: "Sugar-free Coca-Cola. Zero calories.",
                price: 2.49,
                image: "diet_coke",
                unit: "330ml",
                category: .beverages,
                isFavorite: false
            )
        ]
        
        filteredProducts = products
    }
} 