import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack(spacing: 12) {
            Text("Welcome back,")
            Text(viewModel.displayName)
                .font(.title2).bold()

            VStack(spacing: 8) {
                Text("Today's Calories")
                Text("\(viewModel.consumedCalories)/\(viewModel.targetCalories)")
                    .font(.title)
            }

            List(viewModel.recentFoodLogs) { log in
                HStack {
                    Text(log.name)
                    Spacer()
                    Text("\(log.calories) cal")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}


