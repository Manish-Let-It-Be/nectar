import SwiftUI

struct ThemeToggle: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some View {
        Button(action: {
            isDarkMode.toggle()
        }) {
            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                .foregroundColor(.green)
        }
        .accessibilityLabel("Toggle Dark Mode")
    }
}

#Preview {
    ThemeToggle()
} 