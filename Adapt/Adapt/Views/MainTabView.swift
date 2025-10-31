import SwiftUI

struct MainTabView: View {
    let homeViewModel: HomeViewModel

    var body: some View {
        TabView {
            HomeView(viewModel: homeViewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            Text("Progress")
                .tabItem {
                    Label("Progress", systemImage: "chart.pie.fill")
                }
        }
    }
}

#Preview {
    MainTabView(homeViewModel: HomeViewModel())
}


