import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var showSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var isSecured = true
    
    var body: some View {
        VStack(spacing: 20) {
            // Logo and Title
            VStack(spacing: 15) {
                Image("color_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 56)
                
                Text("Sign In")
                    .font(.custom("Gilroy-SemiBold", size: 26))
                
                Text("Enter your credentials to continue")
                    .font(.custom("Gilroy-Medium", size: 16))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 20)
            
            // Form Fields
            VStack(spacing: 25) {
                // Email
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.custom("Gilroy-Medium", size: 16))
                    TextField("Enter your email", text: $email)
                        .textFieldStyle(CustomTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                // Password
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.custom("Gilroy-Medium", size: 16))
                    HStack {
                        if isSecured {
                            SecureField("Enter your password", text: $password)
                        } else {
                            TextField("Enter your password", text: $password)
                        }
                        
                        Button(action: { isSecured.toggle() }) {
                            Image(systemName: isSecured ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .textFieldStyle(CustomTextFieldStyle())
                }
            }
            .padding(.horizontal)
            
            // Sign In Button
            Button(action: signIn) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Sign In")
                        .font(.custom("Gilroy-SemiBold", size: 18))
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .cornerRadius(10)
            .disabled(authViewModel.isLoading)
            .padding(.horizontal)
            .padding(.top)
            
            // Don't have account
            HStack {
                Text("Don't have an account?")
                    .font(.custom("Gilroy-Medium", size: 14))
                
                Button(action: { showSignUp = true }) {
                    Text("Sign Up")
                        .font(.custom("Gilroy-SemiBold", size: 14))
                        .foregroundColor(.green)
                }
            }
            .padding(.top)
            
            Spacer()
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showSignUp) {
            SignUp()
        }
        .alert("Error", isPresented: $authViewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authViewModel.errorMessage)
        }
    }
    
    private func signIn() {
        authViewModel.signIn(email: email, password: password)
    }
} 