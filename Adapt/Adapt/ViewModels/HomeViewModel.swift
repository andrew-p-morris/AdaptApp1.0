import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var dailyPlan: DailyPlanResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    private let authViewModel = AuthViewModel()
    
    func fetchDailyPlan() {
        isLoading = true
        errorMessage = nil
        
        // For now, use mock data - in real app, get from user defaults/database
        let mockInputs = AlgorithmInputs(
            userProfile: UserProfile(
                goal: "weight_loss",
                age: 30,
                sex: "male", 
                height_cm: 180,
                activity_level: "active",
                baseline_calories: 2200
            ),
            currentWeight: 75.5,
            historicalData: HistoricalData(
                weightHistory: [76.1, 75.8, 75.9, 75.7, 75.5, 75.6, 75.4],
                calorieHistory: [2100, 2250, 1900, 2350, 2200, 2150, 2180],
                previousPlan: PreviousPlan(
                    calorieTarget: 2200,
                    workoutCalorieEstimate: 350
                )
            )
        )
        
        let userId = authViewModel.currentUser?.id ?? UUID() // In real app, use actual user ID
        
        apiService.generateDailyPlan(userId: userId, algorithmInputs: mockInputs) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let plan):
                    self?.dailyPlan = plan
                    self?.errorMessage = nil
                    print("Daily plan received: \(plan.calorieTarget) calories")
                    
                case .failure(let error):
                    self?.errorMessage = "Failed to load daily plan: \(error.localizedDescription)"
                    print("Error fetching daily plan: \(error)")
                }
            }
        }
    }
}


