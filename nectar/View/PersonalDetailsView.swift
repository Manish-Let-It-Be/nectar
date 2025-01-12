import SwiftUI

struct PersonalDetailsView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject private var viewModel = PersonalDetailsViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Image Section
                VStack(spacing: 8) {
                    if let image = viewModel.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image("u1")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                    
                    Button("Change Profile Picture") {
                        viewModel.showImagePicker = true
                    }
                    .font(.custom("Gilroy-Medium", size: 14))
                    .foregroundColor(.green)
                }
                
                // Form Fields
                VStack(spacing: 16) {
                    CustomTextField(
                        title: "Full Name",
                        text: $viewModel.name,
                        error: viewModel.nameError
                    )
                    
                    CustomTextField(
                        title: "Email",
                        text: $viewModel.email,
                        keyboardType: .emailAddress,
                        error: viewModel.emailError
                    )
                    
                    CustomTextField(
                        title: "Phone Number",
                        text: $viewModel.phone,
                        keyboardType: .phonePad,
                        error: viewModel.phoneError
                    )
                    
                    DateField(
                        title: "Date of Birth",
                        date: $viewModel.dateOfBirth
                    )
                    
                    GenderPicker(
                        title: "Gender",
                        selection: $viewModel.gender
                    )
                }
                .padding(.horizontal)
                
                // Save Button
                Button(action: {
                    if viewModel.validateFields() {
                        viewModel.saveChanges()
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    if viewModel.isSaving {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Save Changes")
                            .font(.custom("Gilroy-SemiBold", size: 18))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .disabled(viewModel.isSaving)
            }
            .padding(.vertical)
        }
        .navigationTitle("Personal Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(image: $viewModel.profileImage)
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// Supporting Views
struct CustomTextField: View {
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var error: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Gilroy-Medium", size: 14))
                .foregroundColor(.gray)
            
            TextField(title, text: $text)
                .keyboardType(keyboardType)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if let error = error {
                Text(error)
                    .font(.custom("Gilroy-Medium", size: 12))
                    .foregroundColor(.red)
            }
        }
    }
}

struct DateField: View {
    let title: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Gilroy-Medium", size: 14))
                .foregroundColor(.gray)
            
            DatePicker(
                "",
                selection: $date,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

struct GenderPicker: View {
    let title: String
    @Binding var selection: String
    let options = ["Male", "Female", "Other"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Gilroy-Medium", size: 14))
                .foregroundColor(.gray)
            
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

// ViewModel
class PersonalDetailsViewModel: ObservableObject {
    @Published var profileImage: UIImage?
    @Published var name = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var dateOfBirth = Date()
    @Published var gender = "Male"
    
    @Published var nameError: String?
    @Published var emailError: String?
    @Published var phoneError: String?
    
    @Published var showImagePicker = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var isSaving = false
    
    func validateFields() -> Bool {
        var isValid = true
        
        // Reset errors
        nameError = nil
        emailError = nil
        phoneError = nil
        
        // Validate name
        if name.isEmpty {
            nameError = "Name is required"
            isValid = false
        }
        
        // Validate email
        if !email.isValidEmail() {
            emailError = "Please enter a valid email"
            isValid = false
        }
        
        // Validate phone
        if !phone.isEmpty && !phone.isValidPhone() {
            phoneError = "Please enter a valid phone number"
            isValid = false
        }
        
        return isValid
    }
    
    func saveChanges() {
        isSaving = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isSaving = false
            // Handle success/failure
        }
    }
}

extension String {
    func isValidPhone() -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

#Preview {
    PersonalDetailsView()
        .environmentObject(AuthViewModel())
} 