import SwiftUI

struct FavoritesView: View {
    @State private var favoriteItems: [FavoriteItem] = [
        FavoriteItem(id: 1, name: "Organic Bananas", price: 4.99, image: "banana"),
        FavoriteItem(id: 2, name: "Red Apple", price: 3.99, image: "apple")
    ]
    
    var body: some View {
        NavigationView {
            Group {
                if favoriteItems.isEmpty {
                    EmptyFavoritesView()
                } else {
                    List {
                        ForEach(favoriteItems) { item in
                            FavoriteItemRow(item: item)
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        favoriteItems.remove(atOffsets: offsets)
    }
}

struct FavoriteItem: Identifiable {
    let id: Int
    let name: String
    let price: Double
    let image: String
}

struct FavoriteItemRow: View {
    let item: FavoriteItem
    
    var body: some View {
        HStack {
            Image(item.image)
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.custom("Gilroy-SemiBold", size: 16))
                Text("$\(item.price, specifier: "%.2f")")
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            Button(action: {
                // Add to cart action
            }) {
                Text("Add to Cart")
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .cornerRadius(8)
            }
        }
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No favorites yet")
                .font(.custom("Gilroy-SemiBold", size: 20))
            Text("Add items to your favorites")
                .font(.custom("Gilroy-Medium", size: 16))
                .foregroundColor(.gray)
        }
    }
} 