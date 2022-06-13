//
//  Meal.swift
//  Runner
//
//  Created by 박성헌 on 2022/05/14.
//

import Foundation

struct Meal: Codable {
    let meal: [String]
    let origin: [String]
    let calories: Double
    let nutrition: [String : Double]
    let mealType: MealType
}

enum MealType: Int, Codable {
    case breakfast = 1
    case lunch = 2
    case dinner = 3
    case nextDayBreakfast = 4
    case nextDatLunch = 5
}
