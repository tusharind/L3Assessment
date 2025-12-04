import SwiftUI

struct LoginView: View {

    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                Spacer()

                Text("Enter your login credentials")

                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()

                    HStack {

                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)

                    }
                }
                .padding(.horizontal, 30)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 30)
                }

                Button(action: {
                    viewModel.login(email: email, password: password)
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(
                    email.isEmpty || password.isEmpty ? Color.gray : Color.blue
                )
                .cornerRadius(10)
                .padding(.horizontal, 30)
                .padding(.top, 10)
                .disabled(
                    email.isEmpty || password.isEmpty || viewModel.isLoading
                )

                Spacer()
            }
            .padding()
            .navigationBarTitle("Welcome Back")
        }

    }

}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
