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
        
        
        let mealDate: Date = {
            let f = DateFormatter()
            f.dateFormat = "yyyyMMdd"
            return f.date(from: (dict["MLSV_YMD"] as! String)) ?? Date()
        }()
        
        
        let mealType: MealType = {
            switch (dict["MMEAL_SC_CODE"] as! String) {
            case "1":
                if Calendar.current.component(.day, from: Date()) != Calendar.current.component(.day, from: mealDate) {
                    return MealType.nextDayBreakfast
                } else {
                    return MealType.breakfast
                }
            case "2":
                if Calendar.current.component(.day, from: Date()) != Calendar.current.component(.day, from: mealDate) {
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

func autoMealType() -> MealType {
    return {
        let zero = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let breakfast = Calendar.current.date(bySettingHour: 7, minute: 00, second: 00, of: Date())!
        let lunch = Calendar.current.date(bySettingHour: 13, minute: 00, second: 00, of: Date())!
        let dinner = Calendar.current.date(bySettingHour: 19, minute: 00, second: 00, of: Date())!
        
        switch Date() {
        case zero...breakfast:
            return MealType.breakfast
        case breakfast...lunch:
            return MealType.lunch
        case lunch...dinner:
            return MealType.dinner
        default:
            return MealType.nextDayBreakfast
        }
    }()
}
