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
    
    static func fromDictionary(_ dict: [String : Any]) -> Meal {
        let meal: [String] = (dict["DDISH_NM"] as! String).components(separatedBy: "<br/>")
        let origin: [String] = (dict["ORPLC_INFO"] as! String).components(separatedBy: "<br/>")
        let calories = Double((dict["CAL_INFO"] as! String).replacingOccurrences(of: " Kcal", with: ""))
        let nutrition: [String : Double] = {
            var temp = [String : Double]()
            for component in (dict["NTR_INFO"] as! String).components(separatedBy: "<br/>") {
                let split = component.components(separatedBy: " : ")
                
                temp[String(split[0])] = Double(split[1])
            }
            return temp
        }()
        
        
        let mealDate = {
            let f = DateFormatter()
            f.dateFormat = "yyyyMMdd"
            return f.date(from: (dict["MLSV_YMD"] as! String))
        }()
        
        
        let mealType: MealType = {
            switch (dict["MMEAL_SC_CODE"] as! String) {
            case "1":
                if Calendar.current.component(.day, from: Date()) != Calendar.current.component(.day, from: mealDate ?? Date()) {
                    return MealType.nextDayBreakfast
                } else {
                    return MealType.breakfast
                }
            case "2":
                if Calendar.current.component(.day, from: Date()) != Calendar.current.component(.day, from: mealDate ?? Date()) {
                    return MealType.nextDatLunch
                } else {
                    return MealType.lunch
                }
            case "3":
                return MealType.dinner
            default:
                return MealType.lunch
            }
        }()
        
        return Meal(meal: meal, origin: origin, calories: calories!, nutrition: nutrition, mealType: mealType)
    }
}

enum MealType: Int, Codable {
    case breakfast = 1
    case lunch = 2
    case dinner = 3
    case nextDayBreakfast = 4
    case nextDatLunch = 5
}
