//
//  IntentHandler.swift
//  SiriExtension
//
//  Created by Seongheon Park on 2022/06/18.
//

import Intents

class IntentHandler: INExtension, FetchMealIntentHandling, FetchTimeTableIntentHandling {
    
    func handle(intent: FetchMealIntent) async -> FetchMealIntentResponse {
        APIService.instance.setAppGroup()
        if let dateComponent = intent.date {
            guard let date = dateComponent.date else {
                fatalError("Could not convert to Date")
            }
            var mealType: MealType?
            switch intent.mealType {
            case .unknown:
                fatalError("unknown mealType")
            case .breakfast:
                mealType = .breakfast
            case .lunch:
                mealType = .lunch
            case .dinner:
                mealType = .dinner
            case .nextDayBreakfast:
                mealType = .nextDayBreakfast
            case .nextDayLunch:
                mealType = .nextDatLunch
            }
            do {
                let meal = try await APIService.instance.fetchMeal(date: date, mealType: mealType!)
                return FetchMealIntentResponse.success(result: meal.meal)
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("Found nil on intent.date")
        }
    }
    
    func resolveDate(for intent: FetchMealIntent) async -> INDateComponentsResolutionResult {
        if let date = intent.date {
            return INDateComponentsResolutionResult.success(with: date)
        } else {
            return INDateComponentsResolutionResult.needsValue()
        }
    }
    
    func resolveMealType(for intent: FetchMealIntent) async -> SiriMealTypeResolutionResult {
        if intent.mealType == .unknown {
            return SiriMealTypeResolutionResult.needsValue()
        } else {
            return SiriMealTypeResolutionResult.success(with: intent.mealType)
        }
    }
    
    func handle(intent: FetchTimeTableIntent) async -> FetchTimeTableIntentResponse {
        APIService.instance.setAppGroup()
        if let dateComponent = intent.date {
            guard let date = dateComponent.date else {
                fatalError("Could not convert to Date")
            }
            
            do {
                let timeTable = try await APIService.instance.fetchTimeTable(date: date)
                var result: [SiriTimeTableItem] = []
                for item in timeTable.items {
                    result.append(SiriTimeTableItem(identifier: "\(item.period)", display: item.subject))
                }
                return FetchTimeTableIntentResponse.success(timeTableItems: result)
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("Found nil on intent.date")
        }
    }
    
    func resolveDate(for intent: FetchTimeTableIntent) async -> INDateComponentsResolutionResult {
        if let date = intent.date {
            return INDateComponentsResolutionResult.success(with: date)
        } else {
            return INDateComponentsResolutionResult.needsValue()
        }
    }
}
