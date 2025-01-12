//
//  signUp.swift
//  nectar
//
//  Created by Abhijeet Rai on 11/01/25.
//

import SwiftUI

struct SignUp: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var username = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var selectedCountry = Country(name: "United States", code: "US", phoneCode: "+1")
    @State private var showCountryPicker = false
    @State private var isSecured = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Logo and Title
                VStack(spacing: 15) {
                    Image("color_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 56)
                    
                    Text("Sign Up")
                        .font(.custom("Gilroy-SemiBold", size: 26))
                    
                    Text("Enter your credentials to continue")
                        .font(.custom("Gilroy-Medium", size: 16))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 20)
                
                // Form Fields
                VStack(spacing: 25) {
                    // Username
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Username")
                            .font(.custom("Gilroy-Medium", size: 16))
                        TextField("Enter your username", text: $username)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Email
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.custom("Gilroy-Medium", size: 16))
                        TextField("Enter your email", text: $email)
                            .textFieldStyle(CustomTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    
                    // Phone Number
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone Number")
                            .font(.custom("Gilroy-Medium", size: 16))
                        phoneNumberField
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
                
                // Terms and Policy
                Text("By continuing you agree to our Terms of Service and Privacy Policy")
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top)
                
                // Sign Up Button
                Button(action: signUp) {
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
                .padding(.horizontal)
                .padding(.top)
                
                // Already have account
                HStack {
                    Text("Already have an account?")
                        .font(.custom("Gilroy-Medium", size: 14))
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Sign In")
                            .font(.custom("Gilroy-SemiBold", size: 14))
                            .foregroundColor(.green)
                    }
                }
                .padding(.top)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .alert("Error", isPresented: $authViewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authViewModel.errorMessage)
            }
            .onChange(of: authViewModel.isAuthenticated) { isAuthenticated in
                if isAuthenticated {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    var phoneNumberField: some View {
        HStack {
            Button(action: { showCountryPicker = true }) {
                HStack {
                    Text(selectedCountry.flag)
                    Text(selectedCountry.phoneCode)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
            }
            .sheet(isPresented: $showCountryPicker) {
                CountryPicker(selectedCountry: $selectedCountry)
            }
            
            TextField("Phone Number", text: $phoneNumber)
                .keyboardType(.numberPad)
        }
        .textFieldStyle(CustomTextFieldStyle())
    }
    
    private func signUp() {
        authViewModel.signUp(name: username, email: email, password: password)
    }
}

// struct CustomTextFieldStyle: TextFieldStyle {
//     func _body(configuration: TextField<Self._Label>) -> some View {
//         configuration
//             .padding()
//             .background(Color(.systemGray6))
//             .cornerRadius(10)
//     }
// }

#Preview {
    SignUp()
        .environmentObject(AuthViewModel())
        .environmentObject(CartManager())
        .environmentObject(CheckoutViewModel())
        .environmentObject(FavoritesManager())
        .environmentObject(HomeViewModel(productService: ProductService()))
        .environmentObject(ProductDetailViewModel(product: ProductModel(
            id: "",
            name: "",
            description: "",
            price: 0.0,
            image: "",
            unit: "",
            category: .fruits,
            isFavorite: false
        )))
}

