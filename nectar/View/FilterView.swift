import SwiftUI

struct FilterView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var productService: ProductService
    @State private var selectedSortOption = SortOption.nameAsc
    @State private var priceRange: ClosedRange<Double> = 0...100
    
    enum SortOption: String, CaseIterable {
        case nameAsc = "Name (A-Z)"
        case nameDesc = "Name (Z-A)"
        case priceLowToHigh = "Price (Low to High)"
        case priceHighToLow = "Price (High to Low)"
    }
    
    var body: some View {
        NavigationView {
            Form {
                categorySection
                sortBySection
                priceRangeSection
            }
            .navigationTitle("Filters")
            .navigationBarItems(
                leading: Button("Reset") {
                    resetFilters()
                },
                trailing: Button("Apply") {
                    applyFilters()
                }
            )
        }
    }

    private var categorySection: some View {
        Section(header: Text("Categories")) {
            ForEach(ProductModel.Category.allCases, id: \.self) { category in
                HStack {
                    Text(category.rawValue)
                    Spacer()
                    if productService.selectedCategory?.rawValue == category.rawValue {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    productService.selectedCategory = category
                }
            }
        }
    }

    private var sortBySection: some View {
        Section(header: Text("Sort By")) {
            Picker("Sort", selection: $selectedSortOption) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }

    private var priceRangeSection: some View {
        Section(header: Text("Price Range")) {
            VStack {
                RangeSlider(value: $priceRange, in: 0...100)
                    .padding(.vertical)
                
                HStack {
                    Text("$\(Int(priceRange.lowerBound))")
                    Spacer()
                    Text("$\(Int(priceRange.upperBound))")
                }
                .font(.custom("Gilroy-Medium", size: 14))
            }
        }
    }
    
    private func resetFilters() {
        productService.selectedCategory = nil
        selectedSortOption = .nameAsc
        priceRange = 0...100
        productService.sortOption = .nameAsc
        productService.priceRange = 0...100
    }
    
    private func applyFilters() {
        productService.sortOption = selectedSortOption
        productService.priceRange = priceRange
        presentationMode.wrappedValue.dismiss()
    }
}

struct RangeSlider: View {
    @Binding var value: ClosedRange<Double>
    let bounds: ClosedRange<Double>
    
    init(value: Binding<ClosedRange<Double>>, in bounds: ClosedRange<Double>) {
        self._value = value
        self.bounds = bounds
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 4)
                
                Rectangle()
                    .fill(Color.green)
                    .frame(width: self.width(for: geometry.size.width),
                           height: 4)
                    .offset(x: self.offset(for: geometry.size.width))
                
                HStack(spacing: 0) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 24, height: 24)
                        .shadow(radius: 2)
                        .offset(x: self.lowerOffset(for: geometry.size.width))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.updateLowerBound(gesture: gesture,
                                                        width: geometry.size.width)
                                }
                        )
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 24, height: 24)
                        .shadow(radius: 2)
                        .offset(x: self.upperOffset(for: geometry.size.width))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.updateUpperBound(gesture: gesture,
                                                        width: geometry.size.width)
                                }
                        )
                }
            }
        }
        .frame(height: 24)
    }
    
    private func width(for totalWidth: CGFloat) -> CGFloat {
        let range = bounds.upperBound - bounds.lowerBound
        let valueRange = value.upperBound - value.lowerBound
        return (valueRange / range) * (totalWidth - 48)
    }
    
    private func offset(for totalWidth: CGFloat) -> CGFloat {
        let range = bounds.upperBound - bounds.lowerBound
        let lowerOffset = (value.lowerBound - bounds.lowerBound) / range
        return lowerOffset * (totalWidth - 48)
    }
    
    private func lowerOffset(for totalWidth: CGFloat) -> CGFloat {
        let range = bounds.upperBound - bounds.lowerBound
        let lowerOffset = (value.lowerBound - bounds.lowerBound) / range
        return lowerOffset * (totalWidth - 48)
    }
    
    private func upperOffset(for totalWidth: CGFloat) -> CGFloat {
        let range = bounds.upperBound - bounds.lowerBound
        let upperOffset = (value.upperBound - bounds.lowerBound) / range
        return upperOffset * (totalWidth - 48)
    }
    
    private func updateLowerBound(gesture: DragGesture.Value, width: CGFloat) {
        let range = bounds.upperBound - bounds.lowerBound
        let dragRatio = gesture.location.x / (width - 48)
        let newValue = bounds.lowerBound + (dragRatio * range)
        
        value = Swift.max(bounds.lowerBound, Swift.min(value.upperBound - 1, newValue))...value.upperBound
    }
    
    private func updateUpperBound(gesture: DragGesture.Value, width: CGFloat) {
        let range = bounds.upperBound - bounds.lowerBound
        let dragRatio = gesture.location.x / (width - 48)
        let newValue = bounds.lowerBound + (dragRatio * range)
        
        value = value.lowerBound...Swift.min(bounds.upperBound, Swift.max(value.lowerBound + 1, newValue))
    }
} 

#Preview {
    FilterView(productService: ProductService())
        .environmentObject(AuthViewModel())
} 