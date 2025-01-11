import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Image("color_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
            
            VStack(alignment: .leading, spacing: 25) {
                Text("Login")
                    .font(.custom("Gilroy-Bold", size: 26))
                
                Text("Enter your email and password")
                    .font(.custom("Gilroy-Medium", size: 16))
                    .foregroundColor(.gray)
                
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .textFieldStyle(CustomTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    HStack {
                        if showPassword {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .textFieldStyle(CustomTextFieldStyle())
                }
                
                Button(action: {
                    // Forgot password action
                }) {
                    Text("Forgot Password?")
                        .font(.custom("Gilroy-Medium", size: 14))
                        .foregroundColor(.green)
                }
            }
            .padding(.top, 30)
            
            Button(action: {
                authViewModel.signIn(email: email, password: password)
            }) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Log In")
                        .font(.custom("Gilroy-SemiBold", size: 18))
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .cornerRadius(10)
            .disabled(authViewModel.isLoading)
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onChange(of: authViewModel.error) { error in
                if let error = error {
                    errorMessage = error
                    showError = true
                }
            }
            .padding(.top, 20)
            
            HStack {
                Text("Don't have an account?")
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.gray)
                
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                        .font(.custom("Gilroy-SemiBold", size: 14))
                        .foregroundColor(.green)
                }
            }
            
            VStack(spacing: 20) {
                Text("Or connect with")
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.gray)
                
                HStack(spacing: 20) {
                    SocialButton(image: "google_logo", action: {
                        // Google sign in
                    })
                    
                    SocialButton(image: "fb_logo", action: {
                        // Facebook sign in
                    })
                    
                    SocialButton(image: "apple_logo", action: {
                        // Apple sign in
                    })
                }
            }
            .padding(.top, 30)
            
            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .font(.custom("Gilroy-Medium", size: 16))
    }
}

struct SocialButton: View {
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(image)
                .resizable()
                .frame(width: 24, height: 24)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(Circle())
        }
    }
} 