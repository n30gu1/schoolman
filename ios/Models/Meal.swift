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
    let mealType: Int
    let date: Date
}
