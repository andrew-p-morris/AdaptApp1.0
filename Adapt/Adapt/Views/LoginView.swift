import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Adapt")
                .font(.largeTitle).bold()

            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            Button(action: { viewModel.login(email: email, password: password) }) {
                HStack {
                    if viewModel.isLoading { ProgressView() }
                    Text("Log In")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isLoading)

            if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red).font(.footnote)
            }
        }
        .padding()
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel())
}


