import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var name = ""
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
                Text("Sign Up")
                    .font(.custom("Gilroy-Bold", size: 26))
                
                Text("Enter your credentials to continue")
                    .font(.custom("Gilroy-Medium", size: 16))
                    .foregroundColor(.gray)
                
                VStack(spacing: 15) {
                    TextField("Username", text: $name)
                        .textFieldStyle(CustomTextFieldStyle())
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(CustomTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
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
                
                VStack(spacing: 10) {
                    Text("By continuing you agree to our")
                        .font(.custom("Gilroy-Medium", size: 14))
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("Terms of Service")
                            .foregroundColor(.green)
                        Text("and")
                            .foregroundColor(.gray)
                        Text("Privacy Policy")
                            .foregroundColor(.green)
                    }
                    .font(.custom("Gilroy-Medium", size: 14))
                }
            }
            
            Button(action: {
                authViewModel.signUp(name: name, email: email, password: password)
            }) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Sign Up")
                        .font(.custom("Gilroy-SemiBold", size: 18))
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .cornerRadius(10)
            .disabled(authViewModel.isLoading)
            
            // Add error alert
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
            
            HStack {
                Text("Already have an account?")
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.gray)
                
                NavigationLink(destination: SignInView()) {
                    Text("Login")
                        .font(.custom("Gilroy-SemiBold", size: 14))
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(false)
    }
} 