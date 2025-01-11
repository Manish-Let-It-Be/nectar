import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    
    let categories = [
        ("frash_fruits", "Fresh Fruits & Vegetables"),
        ("cooking_oil", "Cooking Oil & Ghee"),
        ("meat_fish", "Meat & Fish"),
        ("bakery_snacks", "Bakery & Snacks"),
        ("dairy_eggs", "Dairy & Eggs"),
        ("beverages", "Beverages")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Search Bar
                    HStack {
                        Image("search")
                            .resizable()
                            .frame(width: 20, height: 20)
                        TextField("Search Store", text: $searchText)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Categories Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(categories, id: \.0) { category in
                            CategoryGridItem(image: category.0, title: category.1)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Find Products")
        }
    }
}

struct CategoryGridItem: View {
    let image: String
    let title: String
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            Text(title)
                .font(.custom("Gilroy-Medium", size: 14))
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
} 