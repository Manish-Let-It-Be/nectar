import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    
    var body: some View {
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
                
                // Categories Section
                VStack(alignment: .leading) {
                    Text("Categories")
                        .font(.custom("Gilroy-Bold", size: 20))
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            CategoryCard(image: "frash_fruits", title: "Fresh Fruits")
                            CategoryCard(image: "cooking_oil", title: "Cooking Oil")
                            CategoryCard(image: "meat_fish", title: "Meat & Fish")
                            CategoryCard(image: "bakery_snacks", title: "Bakery")
                            CategoryCard(image: "dairy_eggs", title: "Dairy & Eggs")
                            CategoryCard(image: "beverages", title: "Beverages")
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Exclusive Offers
                VStack(alignment: .leading) {
                    Text("Exclusive Offers")
                        .font(.custom("Gilroy-Bold", size: 20))
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ProductCard(image: "banana", title: "Organic Bananas", price: "$4.99")
                            ProductCard(image: "apple", title: "Red Apple", price: "$3.99")
                            ProductCard(image: "bell_pepper_red", title: "Bell Pepper Red", price: "$5.99")
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle("Nectar")
    }
}

struct CategoryCard: View {
    let image: String
    let title: String
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            Text(title)
                .font(.custom("Gilroy-Medium", size: 14))
                .multilineTextAlignment(.center)
        }
        .frame(width: 120)
    }
}

struct ProductCard: View {
    let image: String
    let title: String
    let price: String
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .frame(width: 150, height: 150)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.custom("Gilroy-SemiBold", size: 16))
                Text(price)
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.green)
            }
        }
        .frame(width: 170)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
} 