import Foundation
import SwiftUI

enum AppRoute: Hashable {
    case home
}

final class AppCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var isAuthenticated: Bool = false

    let authViewModel: AuthViewModel
    let homeViewModel: HomeViewModel

    init(authViewModel: AuthViewModel = AuthViewModel(),
         homeViewModel: HomeViewModel = HomeViewModel()) {
        self.authViewModel = authViewModel
        self.homeViewModel = homeViewModel
        self.isAuthenticated = authViewModel.isAuthenticated

        authViewModel.onAuthChange = { [weak self] isAuthed in
            self?.isAuthenticated = isAuthed
            if isAuthed {
                self?.goToHome()
            } else {
                self?.navigationPath = NavigationPath()
            }
        }
    }

    func goToHome() {
        navigationPath = NavigationPath()
    }
}

struct CoordinatorRootView: View {
    @StateObject private var coordinator: AppCoordinator

    init(coordinator: AppCoordinator = AppCoordinator()) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }

    var body: some View {
        Group {
            if coordinator.isAuthenticated {
                NavigationStack(path: $coordinator.navigationPath) {
                    MainTabView(homeViewModel: coordinator.homeViewModel)
                }
            } else {
                LoginView(viewModel: coordinator.authViewModel)
            }
        }
    }
}


