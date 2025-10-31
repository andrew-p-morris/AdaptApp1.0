import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentUser: User?

    var onAuthChange: ((Bool) -> Void)?
    private var cancellables = Set<AnyCancellable>()

    func login(email: String, password: String) {
        errorMessage = nil
        isLoading = true

        // Placeholder flow until backend is ready
        Just(true)
            .delay(for: .milliseconds(600), scheduler: DispatchQueue.main)
            .sink { [weak self] success in
                guard let self = self else { return }
                self.isLoading = false
                if success {
                    self.currentUser = User(id: UUID(), name: "Adapt User", email: email)
                    self.isAuthenticated = true
                    self.onAuthChange?(true)
                } else {
                    self.errorMessage = "Invalid credentials"
                }
            }
            .store(in: &cancellables)
    }

    func logout() {
        isAuthenticated = false
        onAuthChange?(false)
    }
}


