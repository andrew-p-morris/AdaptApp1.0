import Foundation

func generateAdaptivePlan(inputs: AlgorithmInputs) -> DailyPlanResponse {
    // 1. Calculate Weight Trend (7-day moving average)
    let weightTrend = calculateWeightTrend(weights: inputs.historicalData.weightHistory)
    
    // 2. Calculate Caloric Balance
    let expectedBurn = inputs.userProfile.baseline_calories + inputs.historicalData.previousPlan.workoutCalorieEstimate
    let lastCalorieIntake = inputs.historicalData.calorieHistory.last ?? inputs.userProfile.baseline_calories
    let actualBalance = lastCalorieIntake - expectedBurn
    
    // 3. Adjust Calorie Target Based on Goal
    var targetCalories = adjustCalorieTarget(
        profile: inputs.userProfile,
        weightTrend: weightTrend,
        actualBalance: actualBalance
    )
    
    // 4. Generate Workout Routine
    let workout = generateWorkoutRoutine(
        profile: inputs.userProfile,
        targetCalories: targetCalories,
        actualBalance: actualBalance
    )
    
    // 5. Return Daily Plan
    return DailyPlanResponse(
        date: Date().addingTimeInterval(86400), // Tomorrow
        calorieTarget: targetCalories,
        workoutRoutine: workout
    )
}

private func calculateWeightTrend(weights: [Double]) -> Double {
    guard !weights.isEmpty else { return 0.0 }
    let sum = weights.reduce(0, +)
    return sum / Double(weights.count)
}

private func adjustCalorieTarget(profile: UserProfile, weightTrend: Double, actualBalance: Int) -> Int {
    var baseTarget = profile.baseline_calories
    
    switch profile.goal {
    case "weight_loss":
        baseTarget -= 500 // Start with 500 calorie deficit
        // Simple adjustment based on trend (in real app, use more sophisticated logic)
        if actualBalance > 300 { // If overate
            baseTarget -= 100
        } else if actualBalance < -300 { // If underate
            baseTarget += 100
        }
        
    case "muscle_gain":
        baseTarget += 300 // Start with 300 calorie surplus
        if actualBalance < 200 { // If not eating enough
            baseTarget += 100
        }
        
    default: // maintain
        break
    }
    
    // Safety guard: don't adjust more than ±150 from original calculation
    let originalTarget = profile.baseline_calories + (profile.goal == "weight_loss" ? -500 : profile.goal == "muscle_gain" ? 300 : 0)
    let maxAdjustment = 150
    
    if baseTarget > originalTarget + maxAdjustment {
        baseTarget = originalTarget + maxAdjustment
    } else if baseTarget < originalTarget - maxAdjustment {
        baseTarget = originalTarget - maxAdjustment
    }
    
    return baseTarget
}

private func generateWorkoutRoutine(profile: UserProfile, targetCalories: Int, actualBalance: Int) -> WorkoutRoutine {
    var type = "Cardio"
    var intensity = "medium"
    var duration = 30
    var exercises = ["Walking", "Light Jogging"]
    var calorieEstimate = 200
    
    switch profile.goal {
    case "weight_loss":
        if actualBalance > 200 {
            type = "HIIT"
            intensity = "high"
            duration = 45
            exercises = ["Burpees", "Mountain Climbers", "Jump Squats", "High Knees"]
            calorieEstimate = 400
        } else {
            type = "Cardio"
            intensity = "medium"
            duration = 35
            exercises = ["Running", "Cycling", "Jump Rope"]
            calorieEstimate = 300
        }
        
    case "muscle_gain":
        type = "Strength"
        intensity = actualBalance >= 0 ? "high" : "medium"
        duration = 60
        exercises = ["Squats", "Bench Press", "Deadlifts", "Rows"]
        calorieEstimate = 350
        
    default: // maintain
        type = "Mixed"
        intensity = "medium"
        duration = 40
        exercises = ["Yoga", "Bodyweight Exercises", "Light Cardio"]
        calorieEstimate = 250
    }
    
    return WorkoutRoutine(
        type: type,
        duration: duration,
        intensity: intensity,
        exercises: exercises,
        calorieEstimate: calorieEstimate
    )
}

