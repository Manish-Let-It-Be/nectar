import SwiftUI
import UIKit

struct AboutView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About My Project")
                .font(.title)
                .fontWeight(.bold)
            
            Text("My project was developed with the help of Cursor AI and the SweetPad extension, leveraging the power of these tools to create an innovative solution within a tight time frame. Guided by the principles of learning by experimentation and reverse engineering, I was able to deeply understand the problem and tailor my application to the needs of my target audience. This project is a personal endeavor, driven by my desire to learn and grow in the field of iOS app development.")
                .font(.body)
            
            Text("Powered by Cursor AI and SweetPad")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Cursor AI and the SweetPad extension played a crucial role in the development of my project. These tools allowed me to efficiently prototype, iterate, and refine my ideas, enabling me to deliver a polished and user-friendly application.")
                .font(.body)
            
            Text("Learning by Experimenting")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("My development process was driven by a hands-on, experiential approach. By embracing the philosophy of learning by doing and reverse engineering, I was able to quickly adapt to new challenges and continuously improve my solution.")
                .font(.body)
        
            
            Spacer()
            
            Button(action: {
                if let url = URL(string: "https://github.com/Manish-Let-It-Be") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Learn More")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

#Preview {
    AboutView()
        .environmentObject(AuthViewModel())
}
