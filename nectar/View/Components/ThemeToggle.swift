import SwiftUI
import Combine

struct ThemeToggle: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some View {
        Toggle(isOn: $isDarkMode) {
            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                .foregroundColor(isDarkMode ? .yellow : .orange)
        }
        .toggleStyle(SwitchToggleStyle(tint: .green))
    }
}

#Preview {
    ThemeToggle()
} 